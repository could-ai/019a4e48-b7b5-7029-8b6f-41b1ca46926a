import 'package:flutter/material.dart';
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

  ChatMessage({required this.text, required this.isUser, required this.engine});
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
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(
          ChatMessage(text: _controller.text, isUser: true, engine: _selectedEngine));
      _messages.add(ChatMessage(
          text: "This is a simulated response from $_selectedEngine.",
          isUser: false,
          engine: _selectedEngine));
    });

    _controller.clear();
    _scrollToBottom();
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

  void _showFeatureNotImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is not yet implemented."),
        duration: Duration(seconds: 2),
      ),
    );
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
            onPressed: () {
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
            },
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$name engine selected."),
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
              onPressed: _showFeatureNotImplemented,
              tooltip: 'Image Analysis',
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_outlined),
              onPressed: _showFeatureNotImplemented,
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

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
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
            Text(
              message.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
