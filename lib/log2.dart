import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';

class log2 extends StatefulWidget {
  const log2({super.key, required this.addMessage});
  final FutureOr<void> Function(String message, String title) addMessage;

  @override
  _logState2 createState() => _logState2();
}

class _logState2 extends State<log2> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_logState2');
  final _controller_title = TextEditingController();
  final _controller = TextEditingController();

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(290, 0, 0, 0),
        //   child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: const Color(0xFFffcdd2),
        //         shape:
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(18.0),
        //         ),
        //       ),
        //       onPressed: () {
        //         // 버튼을 누르면 실행될 코드 작성
        //       },
        //       child: const Text('SAVE')
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child:
            Column(
              children: [
                // StyledButton(
                //   onPressed: () async {
                //     Navigator.pushNamed(context, '/camera');
                //
                //   },
                //   child: Row(
                //     children: const [
                //       Icon(Icons.send),
                //       SizedBox(width: 4),
                //       // Text('SEND'),
                //     ],
                //   ),
                // ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFef9a9a),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await widget.addMessage(_controller_title.text, _controller.text);
                              _controller.clear();
                              _controller_title.clear();
                            }
                          },
                          child: const Text('SAVE')
                      ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                          color: Color(0xFFffcdd2),
                        fontSize: 30,
                      ),
                      controller: _controller_title,
                      cursorColor: const Color(0xFFffcdd2),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:'제목',
                        hintStyle: TextStyle(fontSize: 30.0, color: Color(0xFFffcdd2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '제목을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    // Expanded(
                    //
                    //   child: TextFormField(
                    //     controller: _controller_title,
                    //     decoration: const InputDecoration(
                    //       hintText: '제목',
                    //     ),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return '제목을 입력해주세요.';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    const Divider(
                      height: 8,
                      thickness: 2,
                      // indent: 8,
                      // endIndent: 8,
                      color: Color(0xFFffcdd2),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 320,
                      // width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '내용을 입력하세요.',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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