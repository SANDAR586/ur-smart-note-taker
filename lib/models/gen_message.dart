import 'package:flutter/foundation.dart';

/// Represents a chat-like GenUI message.
@immutable
class GenMessage {
  const GenMessage({
    required this.id,
    required this.text,
    required this.fromUser,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool fromUser;
  final DateTime createdAt;
}
