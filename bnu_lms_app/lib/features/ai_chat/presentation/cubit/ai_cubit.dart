import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_sources/ai_remote_data_source.dart';
import '../../data/models/ai_models.dart';
import 'ai_state.dart';

class AICubit extends Cubit<AIState> {
  final AIRemoteDataSource _dataSource;

  AICubit(this._dataSource) : super(const AIInitial());

  // ─── Sessions ─────────────────────────────────────────────────────────────

  Future<void> loadSessions() async {
    emit(const AILoadingSessions());
    try {
      final sessions = await _dataSource.getSessions();
      emit(AISessionsLoaded(sessions));
    } catch (e) {
      emit(AIError(e.toString()));
    }
  }

  // ─── Messages ─────────────────────────────────────────────────────────────

  Future<void> loadMessages(int sessionId) async {
    emit(const AILoadingMessages());
    try {
      final messages = await _dataSource.getMessages(sessionId);
      emit(AIMessagesLoaded(messages: messages, currentSessionId: sessionId));
    } catch (e) {
      emit(AIError(e.toString()));
    }
  }

  // ─── Send Message ─────────────────────────────────────────────────────────

  Future<void> sendMessage(int? sessionId, String content, {String? base64Image}) async {
    // Grab whatever messages are already visible
    final currentMessages = _currentMessages();

    // Optimistically append the user's message before the API call
    final optimisticMessage = ChatMessageModel(
      id: -DateTime.now().millisecondsSinceEpoch, // fake local ID
      sender: 'User',
      content: content,
      createdAt: DateTime.now(),
    );
    emit(AIMessageSending([...currentMessages, optimisticMessage]));

    try {
      final reply = await _dataSource.sendMessage(sessionId, content, base64Image: base64Image);

      final aiMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch,
        sender: 'AI',
        content: reply,
        createdAt: DateTime.now(),
      );

      // Determine the resolved session id
      // If sessionId was null the backend created a new one — we'll
      // reload sessions in the background and use a sentinel until the
      // user navigates back to the session list.
      final resolvedSessionId = sessionId ?? 0;

      final updatedMessages = [...currentMessages, optimisticMessage, aiMessage];
      emit(AIMessagesLoaded(
        messages: updatedMessages,
        currentSessionId: resolvedSessionId,
      ));

      // If this was a brand-new chat, silently refresh the session list
      // so the drawer/sidebar stays up-to-date.
      if (sessionId == null || sessionId == 0) {
        _refreshSessionsSilently();
      }
    } catch (e) {
      // Roll back to whatever was shown before sending
      emit(AIError(e.toString()));
    }
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  Future<void> deleteSession(int sessionId) async {
    try {
      await _dataSource.deleteSession(sessionId);
      await loadSessions();
    } catch (e) {
      emit(AIError(e.toString()));
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  List<ChatMessageModel> _currentMessages() {
    final s = state;
    if (s is AIMessagesLoaded) return List.from(s.messages);
    if (s is AIMessageSending) return List.from(s.messages);
    return [];
  }

  /// Loads sessions in the background without touching the current UI state.
  void _refreshSessionsSilently() {
    _dataSource.getSessions().then((sessions) {
      // Only emit if the user has since navigated back to the sessions view
      if (state is AISessionsLoaded) {
        emit(AISessionsLoaded(sessions));
      }
    }).catchError((_) {
      // Silently ignore — this is a best-effort background refresh
    });
  }
}
