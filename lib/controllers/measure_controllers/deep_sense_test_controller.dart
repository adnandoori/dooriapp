import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/helper/scan_device_helper.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class DeepSenseTestController extends BaseController
    with WidgetsBindingObserver {
  late BuildContext context;

  BluetoothCharacteristic? writeChar;
  BluetoothCharacteristic? readChar;

  bool isCommandSent = false;

  StreamSubscription<List<int>>? readCharSubOne;
  StreamSubscription<BluetoothConnectionState>? deviceStateCallback;

  DisconnectType disconnectType = DisconnectType.WHILE_CONNECTING;

  bool forceScan = false;

  Timer? scanningTimer;
  Timer? connectingTimer;

  StreamSubscription<List<ScanResult>>? scanCallback;

  // String UUID_SERVICE = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  String uuidService = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";

  Future<void>? deviceConnectTimer;

  MeasureResult? measureModel;

  var retryConnectionAttempt = -1;

  DeepSenseTestController(this.context);

  var arguments = Get.arguments;

  //var CMD_HEX = '';
  //var CMD_STOP = 'stop';

  var cmdHex = ''; //CMD_HEX = '';
  var cmdStop = 'stop'; //CMD_STOP = 'stop';

  BluetoothConnectionState state = BluetoothConnectionState.disconnected;

  //static const String UUID_CHAR_NOTIFY = "202e3974-a23b-40af-98e9-531396ad0064";
  //static const String UUID_CHAR_WRITE = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  static const String uuidCharNotify = "202e3974-a23b-40af-98e9-531396ad0064";
  static const String uuidCharWrite = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  //late BluetoothDevice deviceId;
  var userId = '';
  bool isScanning = false;

  var title = 'place_your_finger'.tr;
  var content = 'place_your_finger_on_the_sensor'.tr;
  var progress = '0';
  bool isFingerDetected = false;
  String pendingReading = '';

  BluetoothDevice? device;
  BluetoothDevice? saveDevice;

  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  var tag = "Doori";
  var mylogFileName = "DoorilogFile";
  var toggle = false;
  var logStatus = '';
  static Completer completer = Completer<String>();

  bool isDeviceConnected = false;
  bool isHrvFirst = false;
  bool isEFirst = false;

  bool isReadingCompleted = false;
  bool isReadingProcessStarted =
      false; // This flag is used to avoid duplicate/2nd time connection and reading process
  bool isBluetoothON =
      false; // This flag is used specifically for iOS to manage device scanning & connection after BLUETOOTH is ON

  List<String> hrvList = [];
  List<String> eList = [];

  Map<String, String> dialogTitle = {
    "scanning": 'scanning'.tr,
    "init": 'connected'.tr, //'Initializing...',
    "connecting": 'connecting'.tr,
    "connected": 'connected'.tr
  };

  Map<String, String> dialogMsg = {
    "scanning": 'tap_device_to_connect'.tr,
    "init": 'starting_measurement'.tr, // 'Detecting the finger...',
    "connecting": 'please_wait'.tr, //Please wait...
    "connected": 'please_wait'.tr,
  };

  bool isConnecting = false;

  Timer? timer;
  int remainingSeconds = 30;

  bool isTimeStart = false;

  List<int> listForI = [];
  List<int> listForR = [];
  List<int> listForTime = [];

  List<DeepSenseModel> listForDeepSense = [];

  List<int> listForSubtractions = [];
  List<int> listForSubtractionsValues = [];

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);

      printf('init_deep_sense_test_measure');
      KeepScreenOn.turnOn()
          .whenComplete(() => {logFile('-------screen_keep_ON------------')});

      setUpLogs();

      logFile(
          '\n ----------------------------------------------------------- \n ');

      logFile('init_deep_sense_test_measure');
      Utility.isConnected().then((value) async {
        if (value) {
          User user = AuthenticationHelper().user;
          userId = user.uid;
        } else {
          getLastUserId();
        }
      });

      if (arguments != null) {
        cmdHex = arguments[0];
      } else {
        logFile('null_arguments');
      }

      logFile('------deep-sense-test----code---->$cmdHex');

      //startTimer();

      checkDeviceId().then(
          (value) => {logFile("VALUE > $value"), checkBluetoothPermission()});
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
      } else {
        printf('---time--is---over------please-go-back--and--retry--->');
        timer.cancel();
        stopAndGoBack();

        printf(
            '---time--is---over--------------------------------------------------------------------------');
        if (listForDeepSense.isNotEmpty) {
          int consecutiveValidCount = 0;

          for (int i = 0; i < listForDeepSense.length; i++) {
            // logFile(
            //     '----deep-test----I--> ${listForDeepSense[i]
            //         .i} <---->R-->  ${listForDeepSense[i]
            //         .r} <----> ${listForDeepSense[i]
            //         .millisecond}---second--->${listForDeepSense[i]
            //         .second}----diff---->${listForDeepSense[i].diff}');

            if (listForDeepSense[i].i > -1500) {
              //logFile('----deep-test--if--I--> ${listForDeepSense[i].i} second}----diff---->${listForDeepSense[i].diff}');

              if (listForDeepSense[i].diff >= -50 &&
                  listForDeepSense[i].diff <= 50) {
                consecutiveValidCount++;

                if (consecutiveValidCount > 1000) {
                  for (int j = i - 1000 + 1; j <= i; j++) {
                    //validSignal[validCount++] = ppgSignal[j];
                    logFile('-------------value-for--j----------------->$j');
                  }
                  break;
                }
              } else {
                consecutiveValidCount = 0;
                //logFile('------------if--else-->I--> ${listForDeepSense[i].i} ----diff---->${listForDeepSense[i].diff}');
              }
            } else {
              //logFile('------else--I--> ${listForDeepSense[i].i} ----diff---->${listForDeepSense[i].diff}');
              consecutiveValidCount = 0;
            }
            logFile(
                '--------------consecutiveValidCount---->$consecutiveValidCount <------->${listForDeepSense[i].i} ----diff---->${listForDeepSense[i].diff}');
          }

          // if (consecutiveValidCount >= 1000) {
          //   for (int j = i - 1000 + 1; j <= i; j++) {
          //     //validSignal[validCount++] = ppgSignal[j];
          //     printf('--------->$j');
          //   }
          //   break;
          // } else {
          //   printf(
          //       '--------No valid segment found for 3 continuous seconds---------');
          // }
        }
        update();
      }
    });
  }

  void listenCommand() {
    logFile('Subscribed to ${readChar?.uuid}');
    logFile('device_connected_listen_value');

    //print('timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}');
    int mill = 0;

    int d = 0;

    readCharSubOne = readChar?.lastValueStream.listen((value) async {
      String bar = utf8.decode(value);
      logFile('val_get: $bar');

      cancelScanningTimer();
      connectingTimer?.cancel();

      if (bar.isNotEmpty) {
        if (!isTimeStart) {
          startTimer();
          isTimeStart = true;
        }

        String I = bar.substring(bar.indexOf('I') + 'I'.length,
            bar.indexOf('R', bar.indexOf('I') + 'I'.length));

        String R = bar.substring(bar.indexOf('R') + 'R'.length,
            bar.indexOf('H', bar.indexOf('R') + 'R'.length));

        DateTime now = DateTime.now();

        int i = int.parse(I.toString()) * -1;
        mill = mill + 3;

        // subtract 2-1 value

        int count = d - i;
        d = i;

        logFile(
            '----value --->I: $I <-----into-I-> $i ---diff---->$count<-----R-> $R <----> ${now.hour}:${now.minute}:${now.second}.${now.millisecond} - micro--->${now.microsecond}');

        //logFile('----value --->I: $I <-----into-I-> $i ---diff---->$count  <----> ${now.hour}:${now.minute}:${now.second}.${now.millisecond}');

        // 1. if I value is <-1500 show place your finger.
        // 2. IF diff value is >50 or <-50 show too much movement detected
        // 3. elase --> measuring

        if (i < -1500) {
          printf('-------------value----I----->$i');
          title = 'place_your_finger'.tr;
          content = 'place_your_finger_on_the_sensor'.tr;
          isDeviceConnected = true;
          update();
        } else {
          if (count > 50) {
            title = 'too_much_movement'.tr;
            content = 'be_steady_while_taking_the_reading'.tr;
            isFingerDetected = false;
            isDeviceConnected = true;
            update();
          } else if (count < -50) {
            title = 'too_much_movement'.tr;
            content = 'be_steady_while_taking_the_reading'.tr;
            isFingerDetected = false;
            isDeviceConnected = true;
            update();
          } else {
            title = 'measuring'.tr;
            content = 'calibration_completed'.tr;
            isDeviceConnected = true;
            isFingerDetected = true;
            update();
          }
        }

        //listForSubtractionsValues.add(count);

        listForDeepSense.add(DeepSenseModel(
            i: i,
            r: int.parse(R.toString()),
            millisecond: mill,
            second: remainingSeconds,
            diff: count));
      }
    });

    var duration = const Duration(
      milliseconds: 30,
    );
    Timer(duration, () async {
      logFile('----check--device--state---$state');
      if (state == BluetoothConnectionState.connected) {
        readChar?.setNotifyValue(true).then((value) => {writeCommand(cmdHex)});
        logFile('characteristics.Write ${writeChar?.uuid}');
      } else {
        logFile('----device--state---');
      }
    });
  }

  Future<bool> writeCommand(String cmd) async {
    if (state == BluetoothConnectionState.connected && device != null) {
      logFile('writing command: $cmd to device: ${device?.remoteId}');
      isCommandSent = true;
      var value = utf8.encode(cmd);
      logFile('Sending Command : $cmd - [$value]');
      try {
        if (writeChar != null) {
          writeChar!.write(value);
          return true;
        } else {
          return true;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Register device callback for different state of connection of the device
  ///
  ///  @param device - targeted device object
  ///
  /// @author Yagna Joshi
  void registerDeviceCallBack(BluetoothDevice btDevice) {
    logFile('Registering Device CallBack -${saveDevice?.remoteId}');
    //First remove the previous device callback if registered
    unregisterDeviceCallback();

    /// BLE updated
    deviceStateCallback = btDevice.connectionState.listen((event) async {
      logFile('Device State Callback: $event');
      if (event == BluetoothConnectionState.disconnected) {
        if (state == BluetoothConnectionState.connected) {
          if (disconnectType == DisconnectType.UNKNOWN_DISCONNECTED) {
            logFile('unknown_device_disconnected');
            //here
            state = BluetoothConnectionState.disconnected;

            readChar = null;
            writeChar = null;

            if (device != null) {
              //device!.cancelWhenDisconnected(scanCallback!);
              device!.cancelWhenDisconnected(deviceStateCallback!);
              if (readCharSubOne != null) {
                device!.cancelWhenDisconnected(readCharSubOne!);
              }

              await device?.disconnect();
              scanCallback?.cancel();
              deviceStateCallback?.cancel();
            } else {
              printf('---retry--scaning---else');
            }

            releaseDeviceInitFromDevice(22).whenComplete(() {
              logFile("Device is released now");
            });
            update();
            connectionRetryOrCancelDialog();
            //onDisconnectAndRetry(1);
          } else if (disconnectType == DisconnectType.FORCED_FROM_APP) {
            if (Platform.isIOS) {
              readChar = null;
              writeChar = null;
            }

            releaseDeviceInitFromDevice(1).then((value) =>
                {context.loaderOverlay.hide(), Get.back(result: 'back')});
          } else if (disconnectType == DisconnectType.ON_MEASURE_COMPLETION) {
            if (context.mounted) {
              logFile('---go-forward-next---711');
              scanCallback?.cancel();
              readChar = null;
              writeChar = null;

              FlutterBluePlus.stopScan().whenComplete(() {
                logFile('-------stop_scanning------714');
              });
              update();
            } else {
              logFile('-------unmounted-----720');
            }
            releaseDeviceInitFromDevice(60).then((value) => {
                  if (context.mounted)
                    {stopAndGOForward()}
                  else
                    {logFile('unMounted-stopGoForward')}
                });
          } else {
            //Utility().snackBarError("Device Disconnected");
            releaseDeviceInitFromDevice(7);
          }
        } else {
          logFile(
              "Fot BluetoothDeviceState.disconnected event, Device State: $state");
        }
      } else if (event == BluetoothConnectionState.connected) {
        onConnected(btDevice);
      }
    });

    ///----------------------------------------------------------------
  }

  Future<void> unregisterDeviceCallback() async {
    await deviceStateCallback?.cancel();
  }

  ///Main Important Method for discover services and characteristics of connected devices
  ///should be called once after connected
  ///
  /// @author Yagna Joshi
  void discoverServices() {
    //if (state == BluetoothConnectionState.connected)
    if (isConnecting) {
      state = BluetoothConnectionState.connected;
      isConnecting = false;
      update();
      if (device == null || !context.mounted) {
        logFile('device is null');
        logFile("CONTEXT MOUNTED? : ${context.mounted ? "YES" : "NO"}");
        return;
      }
      logFile('DISCOVER SERVICES');

      printf('----call---direct--read--command---');

      device?.discoverServices().then((services) {
        logFile('discoverServices success ${services.length}');

        var service = services.firstWhereOrNull(
            (element) => element.uuid.toString() == uuidService);

        readChar = service?.characteristics.firstWhereOrNull(
            (element) => element.uuid.toString() == uuidCharNotify);

        writeChar = service?.characteristics.firstWhereOrNull(
            (element) => element.uuid.toString() == uuidCharWrite);

        if (readChar != null && writeChar != null) {
          Timer(
              const Duration(
                milliseconds: 0,
              ), () async
          {
            readChar?.setNotifyValue(true).then((value) =>
            {
                  if (!isReadingProcessStarted)
                    {
                      isReadingProcessStarted = true,
                      listenCommand()
                    }
                });

            logFile('----------------characteristics.READ ${readChar?.uuid}');
          });
        }
      }).catchError((error) {
        state = BluetoothConnectionState.disconnected;
        readChar = null;
        writeChar = null;
        logFile('------------Error in DiscoverServices : $error');
      });
    }
  }

  void setUpLogs() async {
    await FlutterLogs.initLogs(
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: [mylogFileName],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        debugFileOperations: true,
        isDebuggable: true);

    FlutterLogs.channel.setMethodCallHandler((call) async {
      if (call.method == 'logsExported') {
        // Contains file name of zip
        FlutterLogs.logInfo(
            tag, "setUpLogs", "logsExported: ${call.arguments.toString()}");

        // Notify Future with value
        completer.complete(call.arguments.toString());
      } else if (call.method == 'logsPrinted') {
        FlutterLogs.logInfo(
            tag, "setUpLogs", "logsPrinted: ${call.arguments.toString()}");
      }
    });
  }

  void logFile(String logMsg) {
    FlutterLogs.logToFile(
        appendTimeStamp: true,
        overwrite: false,
        logMessage: '\n $logMsg',
        logFileName: mylogFileName);
  }

  void getLastUserId() async {
    try {
      userId = await Utility.getUserId();
      logFile('userIdOffline-$userId');
      update();
    } catch (exe) {
      logFile('exe-deviceToken$exe');
    }
  }

  Future checkDeviceId() async {
    logFile('get_device_id');
    try {
      String deviceId = await Utility.getDeviceId();
      //String deviceName = await Utility.getDeviceName();

      saveDevice = BluetoothDevice.fromId(deviceId);

      // TODO BLE update here
      //saveDevice = BLEDeviceHelper.createBluetoothDevice(
      //  deviceName = deviceName, deviceId = deviceId);

      logFile(
          "checkDeviceId > saveDevice: $saveDevice \n DeviceID: ${saveDevice?.remoteId}");
    } catch (exe) {
      logFile('exception > checkDeviceId > Reason: $exe');
    }
  }

  void checkLocationService() async {
    var status = await Permission.location.status;
    if (await Permission.location.isGranted) {
      logFile('location is on');
      checkBluetoothPermission();
    } else {
      await Permission.location.request();
      logFile('location is off');
    }
    logFile('status-${status.name}');
  }

  void onDisconnectAndRetry(int from) {
    state = BluetoothConnectionState.disconnected;
    device = null;
    isFingerDetected = false;

    if (retryConnectionAttempt < 5) {
      // Utility().snackBarError("Connection Failed. Retrying...");
      logFile('onDisconnect...$from');
      retryConnectionAttempt++;
      update();
      if (kDebugMode) {
        print('RETRYING');
      }
      initConnection(3);
    } else {
      if (context.mounted) {
        Utility().snackBarError("connection_failed".tr);
      } else {
        logFile('mounted_false_toast');
      }
      //update();
      logFile('---call----disconnect--and retry----stop--method---816');
      stopAndGoBack();
    }
  }

  /// Start LE scanning
  ///
  /// @author Yagna Joshi
  void startScan() {
    logFile('scanning...');

    isScanning = true;

    // TODO BLE
    //flutterBlue.startScan();

    /// BLE updated
    FlutterBluePlus.startScan();

    startScanningTimer();
  }

  /// Stop LE scanning
  ///
  /// @author Yagna Joshi
  Future stopScanning(int from) async {
    logFile('-------------stop_method_called_1008------------------');
    logFile('STOP SCANNING from $from');

    cancelScanningTimer();
    isScanning = false;

    //flutterBlue.stopScan();

    /// BLE updated

    if (scanCallback != null) {
      FlutterBluePlus.cancelWhenScanComplete(scanCallback!);
    }

    FlutterBluePlus.stopScan();
    scanCallback?.cancel();
  }

  /// Method for forced exit if device not found since long time
  ///
  ///
  /// @author Yagna joshi
  void stopAndGoBack() {
    context.loaderOverlay.show();
    disconnectType = DisconnectType.FORCED_FROM_APP;
    if (device != null) {
      if (state == BluetoothConnectionState.connected && device != null) {
        logFile('writing command: $cmdStop to device: ${device?.remoteId}');
        isCommandSent = true;
        //var value = utf8.encode(CMD_STOP);
        logFile('-----call----stop----command----');
        releaseDeviceInitFromApp(51).then((value) => {
              logFile('stopAndGoBack - if--stop-command'),
              context.loaderOverlay.hide(),
              Get.back(result: 'back')
            });
      } else {
        printf('--else--write--command--1063');
        releaseDeviceInitFromApp(2).then((value) => {
              logFile('stopAndGoBack - else--stop-command'),
              context.loaderOverlay.hide(),
              Get.back(result: 'back')
            });
      }
    } else {
      releaseDeviceInitFromApp(2).then((value) => {
            logFile('stopAndGoBack - else'),
            context.loaderOverlay.hide(),
            Get.back(result: 'back')
          });
    }
  }

  /// Method for Go Forward to show result screen
  ///@param  measureModel - measurement result data
  ///
  /// @author Yagna joshi
  Future<void> stopAndGOForward() async {
    logFile('STOP AND GO FORWARD-> MeasureResultScreen');

    final result = await Get.toNamed(Routes.measureResultScreen,
        arguments: [measureModel]);
    Get.context!.loaderOverlay.hide();

    if (result.toString() == 'back') {
      printf(
          '----------retry------------------back---------------here-----------');
      if (device != null) {
        device!.cancelWhenDisconnected(deviceStateCallback!);
        if (readCharSubOne != null) {
          device!.cancelWhenDisconnected(readCharSubOne!);
        }

        await device?.disconnect();
        deviceStateCallback?.cancel();
      } else {
        printf('---retry---else');
      }
      Get.back();
      logFile('start_measure_return_back');
    } else if (result.toString() == 'save') {
      Get.back(result: result);
      releaseDeviceInitFromApp(11);
      logFile('start_measure_return_save');
    }
  }

  ///Set Device free, Disconnect it and its callbacks
  ///
  ///
  ///
  Future releaseDeviceInitFromApp(int from) async {
    if (device != null) {
      await unregisterDeviceCallback();
      deviceConnectTimer?.ignore();
      // await readCharSubOne?.cancel();
      //await deviceStateCallback?.cancel();
      // await stopScanning(3);
      device!.cancelWhenDisconnected(deviceStateCallback!);
      if (readCharSubOne != null) {
        device!.cancelWhenDisconnected(readCharSubOne!);
      }
      await device?.disconnect();
      deviceStateCallback?.cancel();
      // device = null;
    }

    logFile('Release Device Init From App$from');
    update();
  }

  ///Set Device free, Disconnect it and its callbacks
  ///
  ///
  ///
  Future releaseDeviceInitFromDevice(int from) async {
    await unregisterDeviceCallback();
    deviceConnectTimer?.ignore();
    //await readCharSubOne?.cancel();
    //await deviceStateCallback?.cancel();
    //await stopScanning(3);
    device!.cancelWhenDisconnected(deviceStateCallback!);
    if (readCharSubOne != null) {
      device!.cancelWhenDisconnected(readCharSubOne!);
    }
    deviceStateCallback?.cancel();
    //device = null;
    //logFile('Release Device Init From Device from$from');
    logFile('Release Device Init From Device from$from');
    update();
  }

  Future<bool?> onConnected(BluetoothDevice newDevice) async {
    logFile('---on---connected-------1114');
    deviceConnectTimer = null;
    logFile(
        'CONNECTION COMPLETE :${newDevice.remoteId} - ${newDevice.advName}');
    // state = BluetoothConnectionState.connecting;
    isConnecting = true;
    disconnectType = DisconnectType.UNKNOWN_DISCONNECTED;

    discoverServices();
    return Future.value(true);

    // Timer(const Duration(milliseconds: 1500), () async {
    //   deviceConnectTimer = null;
    //   logFile('CONNECTION COMPLETE :${newDevice.id} - ${newDevice.name}');
    //   state = BluetoothDeviceState.connecting;
    //   disconnectType = DisconnectType.UNKNOWN_DISCONNECTED;

    //   discoverServices();
    //   return Future.value(true);
    // });
    // return null;
  }

  void enableLocation() async {
    logFile('check_location_permission \n');
    Location location = Location();
    bool isOn = await location.serviceEnabled();
    if (!isOn) {
      logFile('request_location_permission \n');

      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        logFile('location_on_start_scanning \n');

        initConnection(1);
      } else {
        enableLocation();
        logFile('location_off_else \n');
      }
    } else {
      logFile('location_on_gr anted_start_scanning \n');
      initConnection(2);
    }
  }

  checkBluetoothPermission() async {
    logFile('check_permission \n');

    if (Platform.isAndroid) {
      if (!await Permission.bluetoothScan.isGranted) {
        logFile('bluetoothScan');

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

      BluetoothEnable.enableBluetooth.then((result) {
        if (result == "true") {
          logFile('Ble_on.... \n ');
          enableLocation();
        } else if (result == "false") {
          logFile('Ble_off... \n ');
          checkBluetoothPermission();
        }
      });
    } else {
      BluetoothEnable.enableBluetooth.then((result) {
        if (result == "true") {
          logFile('Ble_on.... \n ');
          enableLocation();
        } else if (result == "false") {
          logFile('Ble_off... \n ');
          checkBluetoothPermission();
        }
      });
    }
  }

  void requestTurnOnBluetooth() async {
    if (Platform.isAndroid) {
      if (!await Permission.bluetoothConnect.isGranted) {
        Permission.bluetoothConnect
            .request()
            .then((value) => requestTurnOnBluetooth());
        return;
      }

      if (!await Permission.bluetoothScan.isGranted) {
        Permission.bluetoothScan
            .request()
            .then((value) => requestTurnOnBluetooth());
        return;
      }

      if (Platform.isAndroid && !await Permission.locationWhenInUse.isGranted) {
        Permission.locationWhenInUse
            .request()
            .then((value) => requestTurnOnBluetooth());
        return;
      }

      BluetoothEnable.enableBluetooth.then((result) {
        if (result == "true") {
          logFile('Ble_on.... \n');
          enableLocation();
        } else if (result == "false") {
          logFile('Ble_off... \n ');
        }
      });
    } else {
      BluetoothEnable.enableBluetooth.then((result) {
        if (result == "true") {
          logFile('Ble_on.... \n');
          enableLocation();
        } else if (result == "false") {
          logFile('Ble_off... \n ');
        }
      });
    }
  }

  void connectionRetryOrCancelDialog() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('disconnected'.tr),
        content: Text('measurement_complete'.tr),
        actions: [
          TextButton(
            child: Text("retry".tr),
            onPressed: () {
              Get.back();
              title = 'place_your_finger'.tr;
              content = 'place_your_finger_on_the_sensor'.tr;
              isDeviceConnected = false;
              isFingerDetected = false;
              isReadingProcessStarted = false;
              state = BluetoothConnectionState.disconnected;
              update();
              initConnection(11);
              //onDisconnectAndRetry(1);
            },
          ),
          TextButton(
            child: Text("cancel".tr),
            onPressed: () {
              Get.back();
              //here2
              backToHome();
            },
          ),
        ],
      ),
    );
  }

  Future<void> backToHome() async {
    await unregisterDeviceCallback();
    deviceConnectTimer?.ignore();
    //await readCharSubOne?.cancel();
    //await stopScanning(3);

    device?.cancelWhenDisconnected(deviceStateCallback!);
    if (readCharSubOne != null) {
      device?.cancelWhenDisconnected(readCharSubOne!);
    }
    await device?.disconnect();
    await deviceStateCallback?.cancel();
    //device = null;
    logFile('back to home');
    update();
    Get.back(result: 'exit');
  }

  String getValueAfterCharacter(String input, String character) {
    int charIndex = input.indexOf(character);
    if (charIndex == -1 || charIndex == input.length - 1) {
      // Character not found or it's the last character in the string
      return '';
    }
    // Return the substring after the character
    return input.substring(charIndex + 1);
  }

  int? getMaxValue(List<String>? sysList) {
    if (sysList == null || sysList.isEmpty) {
      return null; // Return null if the list is null or empty
    }

    // Convert strings to integers
    List<int> intList = sysList.map((str) => int.parse(str)).toList();

    // Find the maximum value
    return intList.reduce((curr, next) => curr > next ? curr : next);
  }

  int? getMinValue(List<String>? sysList) {
    if (sysList == null || sysList.isEmpty) {
      return null; // Return null if the list is null or empty
    }

    try {
      // Convert strings to integers
      List<int> intList = sysList.map((str) => int.parse(str)).toList();

      // Find the minimum value
      return intList.reduce((curr, next) => curr < next ? curr : next);
    } catch (e) {
      print('Error parsing the list: $e');
      return null; // Return null if parsing fails
    }
  }

  @override
  void onClose() {
    logFile('close_start_measure \n');
    timer?.cancel();
    if (Platform.isIOS) {
      isReadingProcessStarted = false;
      releaseDeviceInitFromApp(2);
    }
    KeepScreenOn.turnOff()
        .whenComplete(() => {logFile('-------screen_keep_OFF------------')});
    WidgetsBinding.instance.removeObserver(this);
  }

  void startScanningTimer() {
    logFile('startScanningTimer');

    /// Cancel previous timer
    cancelScanningTimer();
    scanningTimer = Timer(const Duration(seconds: 30), () async {
      //Utility().snackBarError("Device not found. Please try again!");
      Timer(const Duration(seconds: 2), () async {
        logFile('---call----timeout----call---stop--method');

        stopAndGoBack();
      });
    });
  }

  void cancelScanningTimer() {
    scanningTimer?.cancel();
  }

  void initConnection(int from) {
    if (context.mounted) {
      logFile("Context is Mounted? : ${context.mounted}");
      logFile("SavedDevice? : $saveDevice");

      if (saveDevice != null && !forceScan) {
        printf('------save--device---found--->${saveDevice!.remoteId.str}');
        logFile(
            'Connecting Save device : ${saveDevice!.remoteId.str.toString()}');

        isReadingProcessStarted = false;

        if (Platform.isAndroid) {
          //cancelScanningTimer();
          printf(
              '-----------start----connecting------------timer-------------');
          connectingTimer = Timer(const Duration(seconds: 60), () async {
            if (context.mounted) {
              Utility().snackBarError("connection_failed".tr);
            } else {
              logFile('mounted_false_toast');
            }
            //update();
            logFile('---call----connect--device---stop--method---308');
            stopAndGoBack();
          });

          connectDevice(saveDevice!);
        } else {
          logFile("INIT_CONNECTION - For iOS");

          /// BLE updated

          FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
            logFile("FLUTTER BLUETOOTH STATE INSIDE LISTENER: $state");

            if (state == BluetoothAdapterState.on && !isBluetoothON) {
              isBluetoothON = true;

              if (isBluetoothON) {
                startScan();
                scanCallback = FlutterBluePlus.scanResults.listen((event) {
                  for (ScanResult r in event) {
                    if (r.device.advName
                        .toLowerCase()
                        .contains('Doori'.toLowerCase())) {
                      logFile(
                          '${r.device.advName} found! rssi: ${r.device.remoteId.str}');
                      if (saveDevice?.remoteId.str ==
                          r.device.remoteId.str.toString()) {
                        // if (device == null) {
                        logFile(
                            'DOORI DEVICE FOUND --- success--${r.device.toString()}');
                        stopScanning(23)
                            .then((value) => {connectDevice(r.device)});
                        // } else {
                        //   logFile('device_else_else');
                        // }
                      }
                    }
                  }
                });
              } else {
                logFile("BLUETOOTH IS OFF YET FOR IOS");
              }
            } else {
              logFile(
                  "ELSE > BLUETOOTH STATE: $state && isBluetoothON: $isBluetoothON");
            }
          });

          ///---------------------------------------
        }
      } else {
        printf('---save--device--is---null-----');

        startScan();

        /// BLE updated
        scanCallback = FlutterBluePlus.scanResults.listen((event) {
          for (ScanResult r in event) {
            if (r.device.advName
                .toLowerCase()
                .contains('Doori'.toLowerCase())) {
              logFile(
                  '${r.device.advName} found! rssi: ${r.device.remoteId.str}');
              //if (saveDevice?.id.toString() == r.device.id.toString())
              {
                if (device == null) {
                  logFile(
                      'DOORI DEVICE FOUND --- success--${r.device.toString()}');
                  stopScanning(2).then((value) => {connectDevice(r.device)});
                } else {
                  logFile('device_else_else');
                }
              }
            }
          }
        });

        ///-----------------------------------------------
      }

      update();
    } else {
      logFile('initConnection...unmount');
    }
  }

  Future<bool?> connectDevice(BluetoothDevice newDevice) async {
    Future<bool> returnValue = Future.value(false);
    device = newDevice;
    cancelScanningTimer();
    registerDeviceCallBack(device!);
    logFile('CONNECTING ${newDevice.remoteId} - ${newDevice.advName}');

    isConnecting = true;

    //state = BluetoothConnectionState.connecting;
    update();
    try {
      deviceConnectTimer = newDevice
          .connect(autoConnect: true, mtu: null)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        logFile('TIMEOUT WHILE CONNECTING');
        logFile('timeout_method_call');
        logFile("context.mounted : ${context.mounted ? "YES" : "NO"}");

        if (device != null && context.mounted) {
          deviceConnectTimer = null;
          returnValue = Future.value(false);
          Timer(const Duration(seconds: 1), () async {
            //onDisconnectAndRetry(3);
            if (context.mounted) {
              Utility().snackBarError("connection_failed".tr);
            } else {
              logFile('mounted_false_toast');
            }
            //update();
            logFile('---call----connect--device---stop--method---308');
            stopAndGoBack();
          });
        }
      });

      return returnValue;
    } catch (ex) {
      logFile(
          'Could not connect with device - ${device!.remoteId}, with EXCEPTION : ${ex.toString()}');
      device?.disconnect();
      // update();
      // stopAndGoBack();

      if (context.mounted) {
        onDisconnectAndRetry(2);
      } else {
        logFile('unMounted-dialog');
      }

      returnValue;
    }
    return null;
  }
}

class DeepSenseModel {
  int i = 0;
  int r = 0;
  int millisecond = 0;
  int second = 0;
  int diff = 0;

  DeepSenseModel({
    required this.i,
    required this.r,
    required this.millisecond,
    required this.second,
    required this.diff,
  });
}
