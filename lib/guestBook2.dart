import 'home.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import 'src/authentication.dart';
import 'src/widgets.dart';
import 'package:intl/intl.dart';

class GuestBook2 extends StatefulWidget {
  const GuestBook2({super.key, required this.addMessage});
  final FutureOr<void> Function(String message, String title) addMessage;
  // final FutureOr<void> Function(String title) addTitle;

  @override
  _GuestBookState2 createState() => _GuestBookState2();
}

class _GuestBookState2 extends State<GuestBook2> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState2');
  final _controller_title = TextEditingController();
  final _controller = TextEditingController();

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child:
            Column(
              children: [
                StyledButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/camera');

                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      // Text('SEND'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller_title,
                        decoration: const InputDecoration(
                          hintText: '제목',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '제목을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력하세요.',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '내용을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    StyledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.addMessage(_controller_title.text, _controller.text);
                          _controller.clear();
                          _controller_title.clear();
                        }

                      },
                      child: Row(
                        children: const [
                          Icon(Icons.send),
                          SizedBox(width: 4),
                          Text('SEND'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ),
        const SizedBox(height: 8),

      ],
    );
  }
}