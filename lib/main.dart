import 'package:firebase/crashanalytic/crashanalytic.dart';
import 'package:firebase/login.dart';
import 'package:firebase/start.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signup.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:/*Crash_anlytic(),*/
      FutureBuilder<RemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
          return snapshot.hasData
              ? Home(remoteConfig: snapshot.requireData)
              : Center(
                child: const Text("No data available"),
              );
        },
      ),

      routes: <String,WidgetBuilder>{
        "Login" : (BuildContext context)=>Login(),
        "SignUp":(BuildContext context)=>SignUp(),
        "start":(BuildContext context)=>Start(),
      },

    );
  }



}


class Home extends AnimatedWidget {
  final RemoteConfig remoteConfig;

  Home({this.remoteConfig}) : super(listenable: remoteConfig);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Config"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Image.network(remoteConfig.getString("Image")),
              SizedBox(
                height: 50.0,
              ),
              Text(
                remoteConfig.getString("Text"),
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(remoteConfig.lastFetchStatus.toString()),
              SizedBox(
                height: 20.0,
              ),
              Text(remoteConfig.lastFetchTime.toString()),
              SizedBox(
                height: 20.0,
              ),
              FloatingActionButton(onPressed: () async {
                try {
                  await remoteConfig.setConfigSettings(RemoteConfigSettings(
                      fetchTimeout: Duration(seconds: 10),
                      minimumFetchInterval: Duration.zero));
                  await remoteConfig.fetchAndActivate();
                } catch (e) {
                  print(e.toString());
                }
              },child: const Icon(Icons.refresh),)
            ],
          ),
        ),
      ),
    );
  }
}

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  await remoteConfig.fetch();
  await remoteConfig.activate();


//testing
  print(remoteConfig.getString("Text"));

  return remoteConfig;
}




