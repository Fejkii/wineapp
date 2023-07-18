import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:wine_app/bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final todoQuery = FirebaseFirestore.instance.collection("todos");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("asdasd"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ahoj"),
          // BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          //   if (state is LoggedInState) {
          //     return Container();
          //   } else {
          //     return Container();
          //   }
          // }),
          FirestoreListView(
            shrinkWrap: true,
            query: todoQuery,
            itemBuilder: ((context, doc) {
              final todoName = doc.get("todo");
              final todoDone = doc.get("isDone");
              if (todoName != null && todoDone != null) {
                return Row(
                  children: [
                    Text(todoName),
                    SizedBox(
                      width: 30,
                    ),
                    Text(todoDone == true ? "done" : "not"),
                  ],
                );
              } else {
                return const Text("nic nenaleyeno");
              }
            }),
          ),
        ],
      ),
    );
  }
}
