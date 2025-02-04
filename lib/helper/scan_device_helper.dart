import 'package:flutter_blue_plus/flutter_blue_plus.dart';

//import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart' as proto;

enum DeviceBtType { LE, CLASSIC, DUAL, UNKNOWN }

enum DisconnectType {
  WHILE_CONNECTING,
  FORCED_FROM_APP,
  UNKNOWN_DISCONNECTED,
  ON_MEASURE_COMPLETION
}

class BLEDeviceHelper {


// static BluetoothDevice createBluetoothDevice(
//     String deviceName, String deviceIdentifier) {
//   proto.BluetoothDevice p = proto.BluetoothDevice.create();
//   p.name = deviceName;
//   p.remoteId = deviceIdentifier;
//   p.type = proto.BluetoothDevice_Type.LE;
//   return BluetoothDevice.fromProto(p);
//  }

}
