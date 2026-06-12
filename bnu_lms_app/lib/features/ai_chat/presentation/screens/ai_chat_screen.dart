import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../data/data_sources/ai_remote_data_source.dart';
import '../../data/models/ai_models.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/ai_state.dart';
import '../widgets/ai_chat_drawer.dart';
import '../widgets/message_buble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/message_input.dart';
import '../widgets/empty_state.dart';
import 'package:dio/dio.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';

class AiChatScreen extends StatelessWidget {
  final int? sessionId;

  const AiChatScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AICubit(AIRemoteDataSourceImpl(getIt<Dio>()));
        if (sessionId != null && sessionId! > 0) {
          cubit.loadMessages(sessionId!);
        }
        return cubit;
      },
      child: _AiChatBody(initialSessionId: sessionId),
    );
  }
}

class _AiChatBody extends StatefulWidget {
  final int? initialSessionId;

  const _AiChatBody({this.initialSessionId});

  @override
  State<_AiChatBody> createState() => _AiChatBodyState();
}

class _AiChatBodyState extends State<_AiChatBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  int? _currentSessionId;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.initialSessionId;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;
    
    String? base64Image;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }
    
    _messageController.clear();
    setState(() {
      _selectedImage = null;
    });
    
    await context.read<AICubit>().sendMessage(_currentSessionId, text, base64Image: base64Image);
  }

  void _handleAttachment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Color(0xFF00BCD4)),
              title: const Text('Upload Image from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF00BCD4)),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, bool isLight) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF00BCD4)),
              title: const Text('About AI Assistant'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Assistant'),
        content: const Text(
          'This AI assistant is designed to help you with your studies at BNU. Ask questions, get explanations, and enhance your learning experience.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocListener<AICubit, AIState>(
      listenWhen: (prev, curr) =>
          curr is AIMessagesLoaded ||
          curr is AIMessageSending ||
          curr is AIError,
      listener: (context, state) {
        if (state is AIMessagesLoaded) {
          // Persist the resolved session id (important for brand-new chats)
          if (_currentSessionId == null || _currentSessionId == 0) {
            setState(() => _currentSessionId = state.currentSessionId);
          }
          _scrollToBottom();
        } else if (state is AIMessageSending) {
          _scrollToBottom();
        } else if (state is AIError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
          drawer: const AiChatDrawer(),
        appBar: _buildAppBar(isLight),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<AICubit, AIState>(
                builder: (context, state) {
                  if (state is AILoadingMessages) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BCD4),
                      ),
                    );
                  }

                  List<ChatMessageModel> messages = [];
                  bool isSending = false;

                  if (state is AIMessagesLoaded) {
                    messages = state.messages;
                  } else if (state is AIMessageSending) {
                    messages = state.messages;
                    isSending = true;
                  }

                  if (messages.isEmpty && !isSending) {
                    return EmptyState(isLight: isLight);
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg.sender == 'User';
                      final showAvatar = index == 0 ||
                          (messages[index].sender !=
                              messages[index - 1].sender);
                      return MessageBubble(
                        message: msg,
                        isLight: isLight,
                        showAvatar: showAvatar,
                        isUser: isUser,
                      );
                    },
                  );
                },
              ),
            ),
            // Typing indicator while the AI response is in-flight
            BlocBuilder<AICubit, AIState>(
              builder: (context, state) {
                if (state is AIMessageSending) {
                  return TypingIndicator(isLight: isLight);
                }
                return const SizedBox.shrink();
              },
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -8,
                          top: -8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            MessageInput(
              controller: _messageController,
              focusNode: _focusNode,
              isLight: isLight,
              onSend: _sendMessage,
              onAttachment: () => _handleAttachment(context),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isLight) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isLight ? Colors.black87 : Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'AI Assistant',
        style: isLight
            ? AppLightTextStyles.headlineLarge
            : AppDarkTextStyles.headlineLarge,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: isLight ? Colors.black87 : Colors.white,
          ),
          onPressed: () => _showOptions(context, isLight),
        ),
      ],
    );
  }
}