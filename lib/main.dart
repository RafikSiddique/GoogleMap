


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geolocator/geolocator.dart';
import 'package:location_util/location.service.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("initState");
    getLocation();
  }

  String currentAddress = "My Address";
  Position? currentPosition;
  LocationService locationService = LocationService();
  bool open = false;
  opensSetting() async {
    try {
      open = await locationService.openSettings();
      print("open: ========> : $open ");
    } catch (e) {
      Fluttertoast.showToast(msg: "my exception");
    }
  }

  getLocation() async {
    try {
      currentPosition = await locationService.getCurrentLocation();
      if (currentPosition != null) {
        currentAddress = await locationService.getCurrentAddress(
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude,
        );
      }
      setState(() {});
    } catch (e) {
      debugPrint("$e");

      showDialog(

       // barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 150,
            width: 150,
            child: AlertDialog(
              content: Column(
                children: <Widget>[],
              ),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.blue),
                    onPressed: () {
                      opensSetting();
                      setState(() {
                        open = true;
                      });
                      Navigator.pop(context, open);
                    },
                    child: const Text("Open Location Settings")),
              ],
            ),
          );
        },
      );
      Fluttertoast.showToast(msg: "denied forerver====? $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Text(
                  currentAddress,
                  //currentAddress,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     opensSetting();
            //     // bool isOpened = await locationService.openSettings();
            //     // if (isOpened) {
            //     //   getLocation();
            //     // }
            //   },
            //   child: const Text('Open Location Settings'),
            // ),
          ],
        ),
      ),
    );
  }
}
