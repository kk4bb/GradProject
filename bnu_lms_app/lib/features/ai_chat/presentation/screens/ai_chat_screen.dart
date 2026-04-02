import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../widgets/message_buble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/message_input.dart';
import '../widgets/empty_state.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    _messages.add(
      ChatMessage(
        text: 'Hello! How can I assist you today with your studies at BNU?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: messageText,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response (replace with actual API call)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _generateResponse(messageText),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  String _generateResponse(String query) {
    // Replace this with your actual AI API integration
    if (query.toLowerCase().contains('quantum')) {
      return 'Quantum entanglement is a phenomenon where two or more particles become linked in such a way that they share the same fate, no matter how far apart they are. If you measure a property of one particle, you instantly know the corresponding property of the other, even if they\'re light-years away. It\'s like having two coins that are magically linked: if one lands on heads, the other instantly lands on tails, and vice versa.';
    }
    return 'I understand your question. Let me help you with that. This is a demonstration response. Please integrate your AI API here for actual intelligent responses.';
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
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                // Handle image upload
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF00BCD4)),
              title: const Text('Upload Document'),
              onTap: () {
                Navigator.pop(context);
                // Handle document upload
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
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
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _clearChat();
              },
            ),
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

  void _clearChat() {
    setState(() {
      _messages.clear();
      _initializeChat();
    });
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

    return Scaffold(
      // backgroundColor: isLight ? const Color(0xFFF5F5F5) : const Color(0xFF121212),
      appBar: _buildAppBar(isLight),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? EmptyState(isLight: isLight)
                : _buildMessagesList(isLight),
          ),
          if (_isTyping) TypingIndicator(isLight: isLight),
          MessageInput(
            controller: _messageController,
            focusNode: _focusNode,
            isLight: isLight,
            onSend: _sendMessage,
            onAttachment: () => _handleAttachment(context),
          ),
        ],
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   width: 32,
          //   height: 32,
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
          //     ),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          // ),
          // const SizedBox(width: 12),
          Text(
            'AI Assistant',
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: isLight ? Colors.black87 : Colors.white,
          ),
          onPressed: () => _showOptions(context),
        ),
      ],
    );
  }

  Widget _buildMessagesList(bool isLight) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(
          message: _messages[index],
          isLight: isLight,
          showAvatar: index == 0 ||
              _messages[index].isUser != _messages[index - 1].isUser,
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}