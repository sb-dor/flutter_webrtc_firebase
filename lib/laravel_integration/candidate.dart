// Model class for the outer candidate structure
import 'dart:convert';

import 'package:webrtc_tutorial/laravel_integration/inner_candidate.dart';

class Candidate {
  final int id;
  final int roomId;
  final InnerCandidate candidate;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  Candidate({
    required this.id,
    required this.roomId,
    required this.candidate,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] as int,
      roomId: json['room_id'] as int,
      candidate: InnerCandidate.fromJson(jsonDecode(json['candidate'])),
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'candidate': jsonEncode(candidate.toJson()),
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
