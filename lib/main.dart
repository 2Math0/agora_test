import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_test/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Agora Group Video Call'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    errorText:
                        _validateError ? 'Channel name is mandatory' : null,
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1)),
                    hintText: 'Channel Name'),
              ),
              RadioListTile(
                  title: const Text('BroadcastChannel'),
                  value: ClientRole.Broadcaster,
                  groupValue: _role,
                  onChanged: (ClientRole? value) =>
                      setState(() => _role = value)),
              RadioListTile(
                  title: const Text('Audience'),
                  value: ClientRole.Audience,
                  groupValue: _role,
                  onChanged: (ClientRole? value) =>
                      setState(() => _role = value)),
              ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                child: const Text('join'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      myController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    await Permission.camera.request();
    await Permission.microphone.request();

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: myController.text,
            role: _role,
          ),
        ));
  }
}
