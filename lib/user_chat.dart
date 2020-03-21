import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatContent(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InputTextArea(),
            ),
          ],
        ),
      ),
    );
  }
}

/// The widget showing the past list of messages.
class ChatContent extends StatelessWidget {
  final reference = Firestore.instance.collection('chats/main/messages').orderBy('dateCreated');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              // When loading, do not show anything.
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(top: 8.0)
                        : const EdgeInsets.only(top: 0.0),
                    child: TextBubble(
                      snapshot.data.documents[index].data['content'],
                      snapshot.data.documents[index].data['dateCreated'],
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

enum TextBubbleType { received, sent }

class TextBubble extends StatelessWidget {
  final String text;
  final int timeStamp;
  final TextBubbleType textBubbleType;

  TextBubble(this.text, this.timeStamp,
      [this.textBubbleType = TextBubbleType.received]);

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    switch (textBubbleType) {
      case TextBubbleType.received:
        alignment = Alignment.centerLeft;
        break;
      case TextBubbleType.received:
        alignment = Alignment.centerRight;
        break;
      default:
        throw Exception(
          'Invalid TextBubbleType: $textBubbleType',
        );
    }
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              const Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text, style: TextStyle(fontSize: 18.0)),
                Divider(),
                Text(
                  DateFormat('\'Created on\' dd MMM yy \'at\' HH:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(timeStamp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The widget where the user can type in the text message and send.
class InputTextArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: 'Write a message...',
                  ),
                ),
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Icon(Icons.send),
            onPressed: () {
              print('Send button is pressed');
            },
          ),
        ],
      ),
    );
  }
}
