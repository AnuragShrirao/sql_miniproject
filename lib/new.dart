import 'package:dbms_project/loadingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class New extends StatefulWidget {
  final List<Map> user;

  New({this.user});

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  List<Map> selectedUser = [];

  DataTable dataBody() {
    return DataTable(
      showBottomBorder: true,
        columns: [
          DataColumn(
            label: Text("SrNo"),
            numeric: false,
            tooltip: "This is Name",
          ),
          DataColumn(
            label: Text("ID"),
            numeric: false,
            tooltip: "This is SR no",
          ),
          DataColumn(
            label: Text("Name"),
            numeric: false,
            tooltip: "This is ID",
          )
        ],
        rows: widget.user
            .map((e) => DataRow(cells: [
                  DataCell(
                    Text(
                      e["sn"].toString(),
                    ),
                  ),
                  DataCell(
                    Text(
                      e["id"].toString(),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(
                        e["name"].toString(),
                      ),
                    ),
                    showEditIcon: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Select Option"),
                          // content: ,
                          actions: [
                            RaisedButton(
                                child: Text(
                                  "UPDATE",
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("Add Data"),
                                      content: UpdateDataForm(
                                        studentId: e["id"].toString(),
                                        studentName: e["name"].toString(),
                                        studentSn: e["sn"],
                                      ),
                                    ),
                                  );
                                },
                                color: Colors.greenAccent),
                            RaisedButton(
                              onPressed: () async {
                                await DatabaseHelper.instance.delete(e["sn"]);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Loading()));
                              },
                              child: Text(
                                "DELETE",
                              ),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ]))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("DBMS Project"),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Add Data"),
              content: DataForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DataForm extends StatefulWidget {
  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: kInputDecoration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _idController,
              decoration: kInputDecoration.copyWith(
                hintText: "Enter the student ID",
                labelText: "Student ID",
              ),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await DatabaseHelper.instance.insert(
                {
                  DatabaseHelper.studentName: "${_nameController.text}",
                  DatabaseHelper.studentId: "${_idController.text}",
                },
              );
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Loading()));
            },
            child: Text("SUBMIT"),
          ),
        ],
      ),
    );
  }
}

const kInputDecoration = InputDecoration(
  hintText: "Enter the student Name",
  labelText: "Student Name",
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

class UpdateDataForm extends StatefulWidget {
  final studentName;
  final studentId;
  final studentSn;
  UpdateDataForm({this.studentId, this.studentName,this.studentSn});

  @override
  _UpdateDataFormState createState() => _UpdateDataFormState();
}

class _UpdateDataFormState extends State<UpdateDataForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController =
        TextEditingController(text: widget.studentName);
    TextEditingController _idController =
        TextEditingController(text: widget.studentId);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: kInputDecoration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _idController,
              decoration: kInputDecoration.copyWith(
                hintText: "Enter the student ID",
                labelText: "Student ID",
              ),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await DatabaseHelper.instance.update(
                {
                  DatabaseHelper.studentName: "${_nameController.text}",
                  DatabaseHelper.studentId: "${_idController.text}",
                  DatabaseHelper.studentSn : widget.studentSn,
                },
              );
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Loading()));
            },
            child: Text("SUBMIT"),
          ),
        ],
      ),
    );
  }
}

