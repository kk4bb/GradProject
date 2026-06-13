import 'package:equatable/equatable.dart';
import '../../data/models/ai_models.dart';

abstract class AIState extends Equatable {
  const AIState();

  @override
  List<Object?> get props => [];
}

class AIInitial extends AIState {
  const AIInitial();
}

class AILoadingSessions extends AIState {
  const AILoadingSessions();
}

class AISessionsLoaded extends AIState {
  final List<ChatSessionModel> sessions;

  const AISessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class AILoadingMessages extends AIState {
  const AILoadingMessages();
}

/// Active chat view: messages loaded successfully.
class AIMessagesLoaded extends AIState {
  final List<ChatMessageModel> messages;
  final int currentSessionId;

  const AIMessagesLoaded({
    required this.messages,
    required this.currentSessionId,
  });

  @override
  List<Object?> get props => [messages, currentSessionId];
}

/// A message is in-flight — keep showing the current history so UI doesn't flicker.
class AIMessageSending extends AIState {
  final List<ChatMessageModel> messages;

  const AIMessageSending(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AIError extends AIState {
  final String message;

  const AIError(this.message);

  @override
  List<Object?> get props => [message];
}
