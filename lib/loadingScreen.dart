import 'package:dbms_project/new.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    wait();
    super.initState();
  }

  wait() async {
    List<Map<String, dynamic>> users =
        await DatabaseHelper.instance.querryAll();
    if (users != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => New(
            user: users,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }
}
