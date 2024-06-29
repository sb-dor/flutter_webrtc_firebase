class InnerCandidate {
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;

  InnerCandidate({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });

  factory InnerCandidate.fromJson(Map<String, dynamic> json) {
    return InnerCandidate(
      candidate: json['candidate'] as String,
      sdpMid: json['sdpMid'] as String,
      sdpMLineIndex: json['sdpMLineIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex,
    };
  }
}
