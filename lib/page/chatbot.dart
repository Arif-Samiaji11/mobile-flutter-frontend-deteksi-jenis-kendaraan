import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _chatMessages = [];

  void _sendMessage(String message) {
    setState(() {
      _chatMessages.add('User: $message');
      // Implement logic to get and display response from chatbot API or other sources.
      // For example, you can use a chatbot service or a predefined set of responses.
      _chatMessages.add('Chatbot: Terima kasih atas pesan Anda!');
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(146, 146, 189, 1),
        title: Text('Chatbot'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 215, 215, 215), // Ganti warna background sesuai keinginan
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_chatMessages[index]),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatbotPage(),
  ));
}
