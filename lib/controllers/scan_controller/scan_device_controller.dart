import 'dart:async';
import 'dart:io';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ScanDeviceController extends BaseController {
  BuildContext context;

  Timer? scanTimer;

  ScanDeviceController(this.context);

  bool isScanning = false;

  List<BluetoothDevice> deviceList = [];

  var tag = "Doori";
  var myLogFileName = "DooriScanLogFile";
  var toggle = false;
  var logStatus = '';
  static Completer completer = Completer<String>();

//
  late BluetoothConnectionState state;
  BluetoothDevice? device;

  //FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  StreamSubscription<List<int>>? readCharSubOne;
  StreamSubscription<BluetoothConnectionState>? deviceStateSub;
  StreamSubscription<bool>? bluetoothScanningCallback;
  StreamSubscription<BluetoothAdapterState>? bluetoothStateCallback;
  StreamSubscription<List<ScanResult>>? bleScanResultCallback;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_scan_device');
      checkBluetoothPermission();
    });
    super.onInit();
  }

  void checkLocationService() async {
    //var status = await Permission.location.status;
    if (await Permission.location.isGranted) {
      //printf('location is on');
      checkBluetoothPermission();
    } else {
      await Permission.location.request();
      //printf('location is off');
    }

    //printf('status-${status.name}');
  }

  void startScanning(int from) {
    printf('StartScanning Called...$from}');
    printf('SCANNING state $isScanning');
    isScanning = true;
    deviceList.clear();
    update();

    FlutterBluePlus.stopScan().whenComplete(() {
      printf('startScanning > stop_completed');
    });

    //
    //
    // flutterBlue.stopScan().whenComplete(() {
    //   printf('startScanning > stop_completed');
    // });
    //

    Timer(const Duration(seconds: 1), () async {
      printf("Starting the Scan timer");
      startScanningTimer();
      FlutterBluePlus.startScan();
      unregisterBleScanResultCallback();
      bleScanResultCallback = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          printf('----result----${r.device.advName}------');
          if (r.device.advName.contains('Doori')) {
            printf('${r.device.advName} found! rssi: ${r.rssi}');

            var dev = deviceList.firstWhereOrNull((element) =>
                element.remoteId.toString() == r.device.remoteId.toString());

            if (dev == null) {
              deviceList.add(r.device);
              update();
            } else {
              dev = r.device;
            }
          } else {
            printf('No any \'Doori\' device found');
          }
        }
      });

      // flutterBlue.startScan();
      // unregisterBleScanResultCallback();
      // bleScanResultCallback = flutterBlue.scanResults.listen((results) {
      //   for (ScanResult r in results) {
      //     //printf('devicess---' + r.device.name);
      //     if (r.device.name.contains('Doori')) {
      //       printf('${r.device.name} found! rssi: ${r.rssi}');
      //       var dev = deviceList.firstWhereOrNull(
      //               (element) => element.id.toString() == r.device.id.toString());
      //       if (dev == null) {
      //         deviceList.add(r.device);
      //         update();
      //       } else {
      //         dev = r.device;
      //       }
      //     } else {
      //       printf('No any \'Doori\' device found');
      //     }
      //   }
      // });
    });

    update();
  }

  void connectDevice(BluetoothDevice newDevice) async {
    printf('call_connect_device ${newDevice.toString()}');
    device = newDevice;

    update();
    context.loaderOverlay.show();

    await device!.connect().whenComplete(() async {
      List<BluetoothService> services = await device!.discoverServices();
      if (services.isNotEmpty) {
        Utility.setDeviceId(device!.remoteId.str);
        Utility.setDeviceName(device!.advName);
        //Utility.setDeviceType(device!.type);
      }
      services.forEach((service) async {
        printf('services-${services.length}');
        context.loaderOverlay.hide();
        if (device != null) {
          device!.disconnect();
        }
        Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
        Timer(const Duration(milliseconds: 300),
            () => Get.delete<ScanDeviceController>());
      });
    });
  }

  /// Only save the device and navigate to the Dashboard screen
  ///
  /// @param newDevice - selected device from the scan result
  ///
  /// @author Yagna Joshi
  ///
  void saveDevice(BluetoothDevice newDevice) async {
    printf('call_connect_device ${newDevice.toString()}');
    device = newDevice;

    update();

    Utility.setDeviceId(device!.remoteId.str);
    Utility.setDeviceName(device!.advName);
    //Utility.setDeviceType(device!.type);

    Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
    Timer(const Duration(milliseconds: 300),
        () => Get.delete<ScanDeviceController>());
  }

  void scanAgain() {
    stopScanning(1).then((value) async {
      checkBluetoothPermission();
    });
  }

  Future<void> stopScanning(int from) async {
    printf('stop_scanning..from $from');
    stopScanningTimer();

    FlutterBluePlus.stopScan();
    //await flutterBlue.stopScan();
  }

  void stopScanningTimer() {
    scanTimer?.cancel();
  }

  void enableLocation(int from) async {
    //printf("enableLocation from $from");
    Location location = Location();
    bool isOn = await location.serviceEnabled();
    if (!isOn) {
      printf("Location Service is Off. Requesting the permission now");
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        try {
          printf("Location Service is turned ON");
          startScanning(1);
        } catch (e) {
          printf('exception while enabling location service - $e');
        }
      } else {
        printf("Location Service is still Off.");
        enableLocation(1);
        //printf("GPS Device is still OFF");
      }
    } else {
      try {
        printf("Location Service is already ON. Start the Scan process now");
        //printf("GPS device is turned ON");
        startScanning(2);
      } catch (e) {
        printf('exe-$e');
      }
      //startScanning();
    }
  }

  checkBluetoothPermission() async {
    if (Platform.isAndroid) {
      if (!await Permission.bluetoothScan.isGranted) {
        Permission.bluetoothScan
            .request()
            .then((value) => checkBluetoothPermission());
        return;
      }

      if (!await Permission.bluetoothConnect.isGranted) {
        Permission.bluetoothConnect
            .request()
            .then((value) => checkBluetoothPermission());
        return;
      }

      if (Platform.isAndroid && !await Permission.locationWhenInUse.isGranted) {
        Permission.locationWhenInUse
            .request()
            .then((value) => checkBluetoothPermission());
        return;
      }
      enableBluetooth(1);
    } else {
      printf("Enabling Bluetooth for iOS");
      enableBluetooth(2);
    }
  }

  void enableBluetooth(int i) {
    printf("EnableBluetooth from $i");

    FlutterBluePlus.adapterState.first.then((value) {
      printf("CURRENT BLUETOOTH STATE : POWER $value");
      if (value.toString() == 'BluetoothAdapterState.on') {
        printf("Enabling Location Permission for iOS");
        enableLocation(4);
      } else {
        debugPrint("BLUETOOTH POWERING ON...");

        BluetoothEnable.enableBluetooth;

        Timer(
            const Duration(milliseconds: 1000),
            () => {
                  debugPrint(
                      "Enabling Location after turning on the Bluetooth now"),
                  enableLocation(5),
                });
      }
    });

    // flutterBlue.isOn.then((value) => {
    //   printf("CURRENT BLUETOOTH STATE : POWER $value"),
    //   if (value)
    //     {printf("Enabling Location Permission for iOS"), enableLocation(4)}
    //   else
    //     {
    //       debugPrint("BLUETOOTH POWERING ON..."),
    //       BluetoothEnable.enableBluetooth,
    //       Timer(
    //           const Duration(milliseconds: 1000),
    //               () => {
    //             debugPrint(
    //                 "Enabling Location after turning on the Bluetooth now"),
    //             enableLocation(5),
    //           })
    //     }
    // });
  }

  void registerBluetoothStateCallBack() {
    printf('Registering Device CallBack ');
    //First remove the previous device callback if registered
    // unregisterBluetoothStateCallback();
    // bluetoothStateCallback = flutterBlue.state.listen((event) async {
    //   printf('Bluetooth State Callback: $event');
    //   if (event == BluetoothState.on) {
    //     enableLocation(5);
    //   }
    // });
    //
    // bluetoothScanningCallback = flutterBlue.isScanning.listen((event) async {
    //   printf('BLE Scanning State Callback: $event');
    //   isScanning = event;
    //   update();
    // });
  }

  Future<void> unregisterBluetoothStateCallback() async {
    await bluetoothStateCallback?.cancel();
    await bluetoothScanningCallback?.cancel();
    await bleScanResultCallback?.cancel();
  }

  Future<void> unregisterBleScanResultCallback() async {
    await bleScanResultCallback?.cancel();
  }

  void startScanningTimer() {
    printf('scanning_timer start for 30 sec');
    var duration = const Duration(
      seconds: 30,
    );
    stopScanningTimer();
    scanTimer = Timer(duration, () async {
      isScanning = false;
      stopScanning(2);
      printf('stop_scanning_timer');
      update();
    });
  }

  @override
  void onClose() {
    printf('close_scan_device');
    stopScanning(3).then((value) => {
          if (device != null)
            {
              device?.disconnect(),
            },
          super.onClose()
        });
  }
}
