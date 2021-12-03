import 'package:flutter/material.dart';
import '../data/sp_helper.dart';
import '../data/session.dart';

class SesssionScreen extends StatefulWidget {
  const SesssionScreen({Key? key}) : super(key: key);

  @override
  _SesssionScreenState createState() => _SesssionScreenState();
}

class _SesssionScreenState extends State<SesssionScreen> {
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final SPhelper helper = SPhelper();
  List<Session> sessions = [];

  @override
  void initState() {
    helper.init().then((value) => updateScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your training Sessions')),
      body: ListView(
        children: getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSessionDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> showSessionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insert Training Session'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtDescription,
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                  TextField(
                    controller: txtDuration,
                    decoration: InputDecoration(hintText: 'Duration'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    txtDescription.text = '';
                    txtDuration.text = '';
                  },
                  child: Text('Cancel')),
              ElevatedButton(onPressed: saveSession, child: Text('Save'))
            ],
          );
        });
  }

  Future saveSession() async {
    DateTime now = DateTime.now();
    String today = '${now.year}-${now.month}-${now.day}';
    int durationText =
        int.parse(txtDuration.text == '' ? '0' : txtDuration.text);
    int id = helper.getCounter() + 1;

    Session newSession = Session(id, today, txtDescription.text, durationText);

    helper.writeSession(newSession).then((_) {
      updateScreen();
      helper.setCounter();
    });

    txtDescription.text = '';
    txtDuration.text = '';
    Navigator.pop(context);
  }

  List<Widget> getContent() {
    List<Widget> titles = [];
    sessions.forEach((Session session) {
      titles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          helper.deleteSession(session.id).then((value) => updateScreen());
        },
        child: ListTile(
          title: Text(session.description),
          subtitle: Text('${session.date} - duration: ${session.duration} min'),
        ),
      ));
    });
    return titles;
  }

  void updateScreen() {
    sessions = helper.getSetssions();
    setState(() {});
  }
}
