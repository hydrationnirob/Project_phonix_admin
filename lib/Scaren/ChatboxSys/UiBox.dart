import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:phoenix_user/Utiletis/reUseAble/DateTimeClass.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> chatData;
  String collectionName = "notices";


  @override
  void initState() {
    super.initState();
    chatData = FirebaseFirestore.instance.collection(collectionName).get();
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      // You can implement Firestore logic here to send the message
    }
  }

  Widget _buildChatList() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: chatData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        }

        final documents = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            final data = documents[index].data();

            return ChatMessage(
              notice: data['Notice'],
              title: data['Title'],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: _buildChatList(),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted('Message sent'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String? notice;

 final DateTimeClass dateTimeClass = DateTimeClass();


  final String? title;

  ChatMessage({super.key,
    required this.notice,

    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: GFAvatar(
                      shape: GFAvatarShape.standard,
                      backgroundImage: AssetImage('images/2553.jpg'),
                    ),
                  ),
                 const SizedBox(width: 10,),
                  Text(
                    '$title',
                    style: const TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold,),
                  ),
                  Text(
                    dateTimeClass.formattedTime,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5,),


              Text(
                '$notice',
                style: const TextStyle(color: Colors.white, fontSize: 16.0,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
