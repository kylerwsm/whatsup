import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/app_state.dart';
import 'package:flutter_whatsapp/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.appName),
        ),
        body: Provider.of<AppState>(context).userEmail != null
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ChatContent(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InputTextArea(),
                  ),
                ],
              )
            : UnsignedInState(),
      ),
    );
  }
}

class UnsignedInState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.2,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Icon(
                Icons.close,
                color: Colors.red,
                size: MediaQuery.of(context).size.width * 0.4,
              ),
              Text(
                'Sign in to view chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The widget showing the past list of messages.
class ChatContent extends StatelessWidget {
  final reference = Firestore.instance
      .collection('chats/main/messages')
      .orderBy('dateCreated', descending: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
              reverse: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                final String author =
                    snapshot.data.documents[index].data['author'];
                return Padding(
                  padding: index == 0
                      ? const EdgeInsets.only(bottom: 8.0)
                      : index == snapshot.data.documents.length - 1
                          ? const EdgeInsets.only(top: 8.0)
                          : const EdgeInsets.all(0.0),
                  child: TextBubble(
                    snapshot.data.documents[index].data['content'],
                    Firestore.instance
                        .document('chats/main/users/$author')
                        .get()
                        .then(
                          (doc) => doc.data['name'],
                        ),
                    snapshot.data.documents[index].data['dateCreated'],
                    Provider.of<AppState>(context, listen: false).uid == author
                        ? TextBubbleType.sent
                        : TextBubbleType.received,
                  ),
                );
              },
            );
        }
      },
    );
  }
}

enum TextBubbleType { received, sent }

class TextBubble extends StatelessWidget {
  final String text;
  final Future<String> author;
  final int timeStamp;
  final TextBubbleType textBubbleType;

  TextBubble(this.text, this.author, this.timeStamp,
      [this.textBubbleType = TextBubbleType.received]);

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    switch (textBubbleType) {
      case TextBubbleType.received:
        alignment = Alignment.centerLeft;
        break;
      case TextBubbleType.sent:
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
                Opacity(
                  opacity: 0.7,
                  child: FutureBuilder(
                    future: author,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data);
                      } else {
                        return Text('Loading...');
                      }
                    },
                  ),
                ),
                Divider(),
                Text(text, style: TextStyle(fontSize: 18.0)),
                Divider(),
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    DateFormat('\'Created on\' dd MMM yy \'at\' HH:mm a')
                        .format(
                      DateTime.fromMillisecondsSinceEpoch(timeStamp),
                    ),
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
  final reference = Firestore.instance.collection('chats/main/messages');

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

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
                  controller: controller,
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
            onPressed: () async {
              final text = controller.text;
              controller.clear();
              await reference.document().setData({
                'author': Provider.of<AppState>(context, listen: false).uid,
                'content': text,
                'dateCreated': DateTime.now().millisecondsSinceEpoch,
              });
            },
          ),
        ],
      ),
    );
  }
}
