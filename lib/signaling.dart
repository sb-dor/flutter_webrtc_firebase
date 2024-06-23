import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:webrtc_tutorial/pusher_service.dart';

typedef void StreamStateCallback(MediaStream stream);

class Signaling {
  final String _url = "http://192.168.100.3:8000/api";

  // configuration for iceServers
  // they can be used for free
  // forex "stun" servers which are from google and there are for free usage
  // and "stun" servers are for changing your local IP into real IP (192.168..) into (64.25)

  // STUN - servers are necessary for connecting clients or devices in order each of them know
  // their external IP-address. It's necessary for properly making "communication" between computer
  // and other resources in internet
  //
  // all other "stun" servers you can find here:
  // https://gist.github.com/mondain/b0ec1cf5f60ae726202e
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ]
      }
    ]
  };

  // it's very necessary for webrtc part
  RTCPeerConnection? peerConnection;

  // media stream are for getting video from camera and audio
  MediaStream? localStream;
  MediaStream? remoteStream;

  // our future room id to participation
  String? roomId;
  String? currentRoomText;

  //
  //
  StreamStateCallback? onAddRemoteStream;

  StreamSubscription<void>? calleeStreamSubs; // same channel stream but accepts different data

  StreamSubscription<void>? callerStreamSubs; // same channel stream but accepts different data

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Create an offer
    RTCSessionDescription offer = await peerConnection!.createOffer();

    await peerConnection!.setLocalDescription(offer);

    print('Created offer: $offer');

    // Send offer to backend
    var response = await http.post(
      Uri.parse('$_url/create-room'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'offer': offer.toMap(),
      }),
    );

    var data = jsonDecode(response.body);

    var roomId = data['roomId'];

    print('New room created with SDK offer. Room ID: $roomId');

    currentRoomText = 'Current room is $roomId - You are the caller!';

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    // Code for collecting ICE candidates
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      addIceCandidate(candidate, roomId.toString(), 'caller');
      peerConnection?.addCandidate(candidate);
    };

    final pusherService = await PusherClientService.instance.subscriptionCreator();

    final channel = pusherService.publicChannel("webrtc_test_channel_name");

    calleeStreamSubs = pusherService.onConnectionEstablished.listen((e) {
      channel.subscribeIfNotUnsubscribed();
    });

    await pusherService.connect();

    channel.bind("webrtc_test_channel.event").listen((e) {
      // code here tomorrow
    });

    return roomId.toString();
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    // try {
    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    debugPrint("is peerConnection null: ${peerConnection == null}");

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // for getting room configuration
    var responseForRemoteConfig = await http.post(
      Uri.parse('$_url/join-room'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
      }),
    );

    var data = jsonDecode(responseForRemoteConfig.body);

    var offer = data['offer'];

    debugPrint("getting data for setting config: ${offer['sdp']} | type: ${offer['type']}");

    await peerConnection?.setRemoteDescription(
      new RTCSessionDescription(
        offer['sdp'],
        offer['type'],
      ),
    );

    var answer = await peerConnection!.createAnswer();

    await peerConnection!.setLocalDescription(answer);

    print('Created Answer $answer');

    var localDesc = await peerConnection!.getLocalDescription();

    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      addIceCandidate(candidate, roomId, 'callee');
    };

    debugPrint("local desc is: ${localDesc?.toMap()}");

    var response = await http.post(
      Uri.parse('$_url/join-room'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
        'answer': localDesc?.toMap(),
      }),
    );

    // Create an answer

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };
    // } catch (e) {
    //   debugPrint("is any error in join room: $e");
    // }
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': false, // set true in the future
    });

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  // close all
  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((document) => document.reference.delete());

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) => document.reference.delete());

      await roomRef.delete();
    }

    calleeStreamSubs?.cancel();
    callerStreamSubs?.cancel();
    localStream!.dispose();
    remoteStream?.dispose();
  }

  void addIceCandidate(RTCIceCandidate candidate, String roomId, String role) async {
    final response = await http.post(
      Uri.parse('$_url/add-ice-candidate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
        'candidate': candidate.toMap(),
        'role': role,
      }),
    );
    debugPrint("adding Ice candidate data: ${response.body}");
  }

  Future<void> getIceCandidates(String roomId, String role) async {
    var response = await http.get(
      Uri.parse('$_url/api/get-ice-candidates/$roomId/$role'),
    );

    var data = jsonDecode(response.body);
    var candidates = data['candidates'];

    for (var candidate in candidates) {
      peerConnection!.addCandidate(
        RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ),
      );
    }
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
