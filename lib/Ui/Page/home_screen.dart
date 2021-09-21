// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:devtask/Ui/Widgets/conectivity_widget.dart';
import 'package:devtask/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? internet;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  String? bluetooth;
  Location location = new Location();


  bool serviceEnabled=false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    /// Create a connection to the device
    // Listen to scan results
    liveCheck();
    connectivityResult();
    bluetoothCheck();

    locationPermission();

    super.initState();
  }

  void locationPermission()async{
    bool? _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled!){
      setState(() {
        serviceEnabled=false;
      });
    }else{
      setState(() {
        serviceEnabled=true;
      });
    }
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();


  }
  void liveCheck(){
    _connectivitySubscription= Connectivity().onConnectivityChanged.listen((result) {
      if(result== ConnectivityResult.mobile){
        setState(() {
          internet="mobile";
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Mobile data"),
          duration: Duration(milliseconds: 500),
        ));
      }else if(result==ConnectivityResult.wifi){
        setState(() {
          internet="wifi";
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wifi "),
          duration: Duration(milliseconds: 500),
        ));
      }else if(result==ConnectivityResult.none){
        setState(() {
          internet="Disconected";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Disconnect"),
          duration: Duration(milliseconds: 500),
        ));
      }
    });
  }
  void connectivityResult()async{
    var connectivityResult= await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        internet="mobile";
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        internet="wifi";
      });
    }else if(connectivityResult == ConnectivityResult.none){
      setState(() {
        internet="Disconected";
      });
    }
  }
  void bluetoothCheck() {
    flutterBlue.state.listen((event) {
      if(event==BluetoothState.on){
        bluetooth="on";
      }else if(event==BluetoothState.off){
        bluetooth="off";
      }

    });
// Stop scanning
    flutterBlue.stopScan();
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text("help me to find what is wrong",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22),),
            ConectivityWidget(text: "Permission granted",colors:serviceEnabled? Colors.green:Colors.white,colors2:serviceEnabled? Colors.orange:Colors.grey,),
            ConectivityWidget(text: "internet($internet) connection",colors: internet=="Disconected"?Colors.white: Colors.green,colors2:internet=="Disconected"?Colors.grey: Colors.orange ,),
            ConectivityWidget(text: "Bluetooth connection($bluetooth)",colors:bluetooth=="off"?Colors.white: Colors.green,colors2:bluetooth=="off"?Colors.grey: Colors.orange,),

            Container(
              width: MediaQuery.of(context).size.width*0.6,
              padding: EdgeInsets.all(10),
              decoration:  BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child:Text("Troubleshoot",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }


}
