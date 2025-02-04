
import 'package:flutter/material.dart';

class BleConectionScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return BleConnectionState();
  }
  
}

class BleConnectionState extends State<BleConectionScreen>
{

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return const Scaffold(
      body: Center(
        child: Text('List of devices '),
      ),
    );
  }

}