import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ur_smart_note_taker/models/gen_message.dart';
import 'package:ur_smart_note_taker/models/note.dart';

class GenUiState {
  const GenUiState({
    this.messages = const [],
    this.notes = const [],
  });

  final List<GenMessage> messages;
  final List<Note> notes;

  GenUiState copyWith({
    List<GenMessage>? messages,
    List<Note>? notes,
  }) {
    return GenUiState(
      messages: messages ?? this.messages,
      notes: notes ?? this.notes,
    );
  }
}

class GenUiController extends StateNotifier<GenUiState> {
  GenUiController() : super(const GenUiState());

  void handleUserInput(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return;

    final now = DateTime.now();
    final userMessage = GenMessage(
      id: _nextId(),
      text: input,
      fromUser: true,
      createdAt: now,
    );

    final wantsNote = _containsCreateNote(input);
    Note? createdNote;
    if (wantsNote) {
      createdNote = _buildNoteFrom(input);
    }

    final botMessage = GenMessage(
      id: _nextId(),
      text: wantsNote
          ? 'Got it! I created a note for you.'
          : "I'm listening. Tell me what you need—say \"create note\" to capture one.",
      fromUser: false,
      createdAt: DateTime.now(),
    );

    final updatedMessages = List<GenMessage>.from(state.messages)
      ..addAll([userMessage, botMessage]);

    final updatedNotes = createdNote != null
        ? (List<Note>.from(state.notes)..add(createdNote))
        : state.notes;

    state = state.copyWith(messages: updatedMessages, notes: updatedNotes);
  }

  bool _containsCreateNote(String input) {
    return input.toLowerCase().contains('create note');
  }

  Note _buildNoteFrom(String input) {
    final normalized = input.toLowerCase();
    final phraseIndex = normalized.indexOf('create note');
    final afterPhrase = phraseIndex >= 0
        ? input
            .substring(min(input.length, phraseIndex + 'create note'.length))
            .trim()
        : '';
    final title = afterPhrase.isNotEmpty ? afterPhrase : 'New note';

    return Note(
      id: _nextId(),
      title: title,
      body: afterPhrase.isNotEmpty ? input : null,
      createdAt: DateTime.now(),
    );
  }

  String _nextId() => DateTime.now().microsecondsSinceEpoch.toString();
}

final genUiProvider = StateNotifierProvider<GenUiController, GenUiState>(
  (ref) => GenUiController(),
);
