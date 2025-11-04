import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EhsanAiApp());
}

class EhsanAiApp extends StatelessWidget {
  const EhsanAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ehsan AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF131314),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String engine;
  final bool isImagePlaceholder;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.engine,
    this.isImagePlaceholder = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
        text: "Hello! I'm Ehsan AI. How can I help you today?",
        isUser: false,
        engine: 'Ehsan Pro'),
  ];
  String _selectedEngine = 'Ehsan Pro';
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final userInput = _controller.text;

    setState(() {
      _messages.add(
          ChatMessage(text: userInput, isUser: true, engine: _selectedEngine));
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)), () {
      final aiResponse = _generateMockResponse(userInput);
      setState(() {
        _messages.add(aiResponse);
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  ChatMessage _generateMockResponse(String input) {
    input = input.toLowerCase();
    String responseText;

    if (input.contains('hello') || input.contains('hi')) {
      responseText = 'Hello there! How can I assist you further?';
    } else if (input.contains('generate code')) {
      responseText = """Sure, here is a simple "Hello, World!" program in Python:
```python
def hello_world():
    print("Hello, World!")

hello_world()
```""";
    } else if (input.contains('how are you')) {
      responseText = "I'm just a set of algorithms, but I'm operating at peak efficiency! Thanks for asking.";
    } else if (input.contains('image analysis')) {
        responseText = "I can analyze images to identify objects, text, and more. Please provide an image, and I'll do my best to describe it.";
    }
    else {
      responseText = "This is a simulated response from $_selectedEngine. I'm still under development, but I'm learning fast!";
    }

    return ChatMessage(text: responseText, isUser: false, engine: _selectedEngine);
  }

  void _handleImageSelection() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'User uploaded an image.',
        isUser: true,
        engine: _selectedEngine,
        isImagePlaceholder: true,
      ));
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(ChatMessage(
          text: "A beautiful landscape! I see mountains, a lake, and a clear blue sky. It looks very peaceful.",
          isUser: false,
          engine: _selectedEngine,
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _handleVoiceInput() {
    // Simulate voice-to-text
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Listening..."),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _controller.text = "Tell me a fun fact about space.";
      });
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Voice input captured!"),
          duration: Duration(seconds: 2),
        ),
      );
    });
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

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          text: "Hello! I'm Ehsan AI. How can I help you today?",
          isUser: false,
          engine: _selectedEngine,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ehsan AI'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1e1f20),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _clearChat,
            tooltip: 'New Chat',
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF131314),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1e1f20),
              ),
              child: Text(
                'Select AI Engine',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildEngineTile('Ehsan Pro', 'Powerful and balanced'),
            _buildEngineTile('Ehsan Ultra', 'For complex reasoning'),
            _buildEngineTile('Ehsan Flash', 'For speed and efficiency'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessageWidget(message: message);
              },
            ),
          ),
          if (_isTyping) const TypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEngineTile(String name, String description) {
    bool isSelected = _selectedEngine == name;
    return ListTile(
      title: Text(name, style: TextStyle(color: isSelected ? Colors.deepPurple.shade300 : Colors.white)),
      subtitle: Text(description, style: TextStyle(color: isSelected ? Colors.deepPurple.shade200 : Colors.grey)),
      tileColor: isSelected ? Colors.deepPurple.withOpacity(0.2) : null,
      onTap: () {
        setState(() {
          _selectedEngine = name;
        });
        Navigator.pop(context);
        _clearChat();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$name engine selected. New chat started."),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1e1f20),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: _handleImageSelection,
              tooltip: 'Image Analysis',
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_outlined),
              onPressed: _handleVoiceInput,
              tooltip: 'Voice Input',
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Message Ehsan AI...',
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              tooltip: 'Send Message',
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade200),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Ehsan AI is thinking...',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}


class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (message.isImagePlaceholder) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade400,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("Image", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUser
                ? Colors.deepPurple.shade400
                : const Color(0xFF1e1f20),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    message.engine,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade200,
                      fontSize: 12,
                    ),
                  ),
                ),
              _buildMessageContent(context, message.text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, String text) {
    if (text.contains("```")) {
      final parts = text.split("```");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (parts.isNotEmpty) Text(parts[0], style: const TextStyle(color: Colors.white)),
          if (parts.length > 1) CodeBlock(code: parts[1]),
          if (parts.length > 2 && parts[2].trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(parts[2], style: const TextStyle(color: Colors.white)),
            ),
        ],
      );
    }
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final codeParts = code.split('\n');
    final language = codeParts.first.trim();
    final codeContent = codeParts.sublist(1).join('\n');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade700)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: TextStyle(color: Colors.yellow.shade200, fontSize: 12),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: codeContent));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard!')),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.copy, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Copy', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const Divider(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              codeContent,
              style: GoogleFonts.firaCode(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
