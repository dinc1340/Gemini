import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai/Models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const key = "";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: key);
  TextEditingController control = TextEditingController();
  List<Message> messagelist = [];
  void sendMessage() async {
    messagelist.add(
        Message(message: control.text, isUser: true, date: DateTime.now()));
    final content = [Content.text(control.text)];
    final response = await model.generateContent(content);
    messagelist.add(Message(
        message: response.text ?? "", isUser: false, date: DateTime.now()));
    control.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gemini-AI",
          style: TextStyle(fontSize: 27, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: messagelist.length,
              itemBuilder: (context, index) {
                return BubbleNormal(
                  text: messagelist[index].message,
                  isSender: messagelist[index].isUser,
                );
              },
            )),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: control,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11))),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
