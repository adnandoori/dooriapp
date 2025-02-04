import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

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

class StartMeasureController extends BaseController
    with WidgetsBindingObserver {
  BuildContext context;

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

  StartMeasureController(this.context);

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

  List<String> listSystolic = [];
  List<String> listDiastolic = [];

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);

      KeepScreenOn.turnOn()
          .whenComplete(() => {logFile('-------screen_keep_ON------------')});

      setUpLogs();

      logFile(
          '\n ----------------------------------------------------------- \n ');

      logFile('init_start_measure');
      logFile("Shrenik");
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

      checkDeviceId().then(
          (value) => {logFile("VALUE > $value"), checkBluetoothPermission()});
    });
  }

  @override
  void onClose() {
    logFile('close_start_measure \n');

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

  void listenCommand() {
    logFile('Subscribed to ${readChar?.uuid}');
    logFile('device_connected_listen_value');

    readCharSubOne = readChar?.lastValueStream.listen((value) async {
      String bar = utf8.decode(value);
      logFile('val_get: $bar');

      cancelScanningTimer();
      connectingTimer?.cancel();

      if (bar.isNotEmpty) {
        /*if (bar == 'no') {
          isDeviceConnected = true;
          update();
        }*/

        if (bar == 'start') {
          isDeviceConnected = true;
          //isFingerDetected = true;
          update();
        }

        if (bar == 'yes') {
          title = 'finger_detected'.tr;
          content = 'starting_calibration'.tr;
          isDeviceConnected = true;
          isFingerDetected = true;
          update();
        }

        if (bar == 'error') {
          releaseDeviceInitFromApp(2);
          final result = await Get.toNamed(Routes.errorConnectionScreen);
          logFile('result_error-$result');
          if (result.toString() == 'exit') {
            Get.back(result: 'exit');
          } else if (result.toString() == 'back') {
            Get.back();
          }
          Timer(const Duration(milliseconds: 300),
              () => Get.delete<StartMeasureController>());
        }

        if (bar.contains('p')) {
          title = 'calibrating'.tr;

          if (bar.length == 4) {
            content = '${'progress'.tr} : ${bar.substring(bar.length - 3)} %';
          } else if (bar.length == 2) {
            content = '${'progress'.tr} : ${bar.substring(bar.length - 1)} %';
          } else {
            content = '${'progress'.tr} : ${bar.substring(bar.length - 2)} %';
          }

          isFingerDetected = true;
          update();
        }

        if (bar == 'sh') {
          title = 'too_much_movement'.tr;
          content = 'be_steady_while_taking_the_reading'.tr;
          isFingerDetected = false;
          update();
        }

        if (bar.contains('m')) {
          title = 'measuring'.tr;
          content = 'calibration_completed'.tr;
          isFingerDetected = true;
          update();
        }

        if (bar.contains("[") && bar.contains("]")) {
          logFile("READING FINISHED. NOW CALCULATING THE MEASURE VALUE");
          logFile("isReadingProcessStarted: $isReadingProcessStarted");

          if (isReadingProcessStarted) {
            var duration = const Duration(
              milliseconds: 1000,
            );
            Timer(duration, () async {
              logFile('call_get_measure_value');
              getMeasureValue(input: bar);
            });
          }
        } else if (bar.contains("[")) {
          pendingReading = bar;
        } else if (bar.contains("]")) {
          pendingReading = pendingReading + bar;

          if (isReadingCompleted) {
            logFile('call_get_measure_method->$pendingReading');
          } else {
            isReadingCompleted = true;
            logFile('failed to call_get_measure_method->$pendingReading');
            getMeasureValue(
                input: pendingReading,
                sysList: listSystolic,
                diaList: listDiastolic);
          }
          update();
        }

        if (bar.contains('L')) {
          //String firstValue = '';
          title = 'measuring'.tr;
          content = 'calibration_completed'.tr;
          isFingerDetected = true;

          // TODO change here and parse bp value

          try {
            String s = bar.substring(bar.indexOf('A') + 'A'.length,
                bar.indexOf('B', bar.indexOf('A') + 'A'.length));

            String d = getValueAfterCharacter(bar, 'B');

            listSystolic.add(s);
            listDiastolic.add(d);

            printf('---------systolic---value----->$s---->$d');
          } catch (e) {
            printf('exe--->$e');
          }

          //

          // if (isHrvFirst)
          // {
          //   hrvList.add(bar);
          // } else {
          //   //firstValue = bar;
          //   isHrvFirst = true;
          //   logFile('firstHRV-$bar');
          //   //logFile('firstHRV-$firstValue');
          // }

          update();
        }

        // if (bar.contains('E'))
        // {
        //   if (isEFirst) {
        //     eList.add(bar);
        //   } else {
        //     isEFirst = true;
        //     logFile('firstE-$bar');
        //   }
        //   update();
        // }
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

  Future<void> getMeasureValue(
      {input, List<String>? sysList, List<String>? diaList}) async {
    logFile('input--------------------------->$cmdHex $input--------');

    String hrv = '0';
    // List<num> hrvListNumbers = [];
    // logFile('hrcList-${hrvList.length} eList-${eList.length}');
    //
    // if (hrvList.isNotEmpty)
    // {
    //   List<String> listHrv = hrvList.toSet().toList();
    //   logFile('totalHrv-${hrvList.length}');
    //   double totalOfSquare = 0.0;
    //   int squarOfDifference = 0;
    //
    //   for (int i = 0; i < listHrv.length; i++)
    //   {
    //     //heartRythm += listHrv[i];
    //     listHrv[i].substring(1);
    //     int num = 0;
    //
    //     try {
    //       num = int.parse(listHrv[i].substring(1));
    //       hrvListNumbers.add(num);
    //     } catch (exe) {
    //       logFile('could not parse-$exe');
    //     }
    //   }
    //
    //   logFile("NUMBERS ARRAY: $hrvListNumbers");
    //
    //   for (int i = 0; i < hrvListNumbers.length - 1; i++)
    //   {
    //     num diff = (hrvListNumbers[i] - hrvListNumbers[i + 1]).abs();
    //
    //     squarOfDifference = (diff.toInt() * diff.toInt());
    //
    //     totalOfSquare += squarOfDifference;
    //   }
    //
    //   if (totalOfSquare > 0.0)
    //   {
    //     totalOfSquare = totalOfSquare / (listHrv.length - 1);
    //     hrv = sqrt(totalOfSquare).toStringAsFixed(2);
    //     logFile("Final HRV Value: $hrv");
    //   }
    // }

    String H = input.substring(input.indexOf('H') + 'H'.length,
        input.indexOf('O', input.indexOf('H') + 'H'.length));

    String O = input.substring(input.indexOf('O') + 'O'.length,
        input.indexOf(r'$', input.indexOf('O') + 'O'.length));

    String S = input.substring(input.indexOf(r'$') + r'$'.length,
        input.indexOf('D', input.indexOf(r'$') + r'$'.length));

    String D = "";
    String V = "";

    if (input.contains("V")) {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('V', input.indexOf('D') + 'D'.length));

      V = input.substring(input.indexOf('V') + 'V'.length,
          input.indexOf('T', input.indexOf('V') + 'V'.length));

      hrv = V;
    } else {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('T', input.indexOf('D') + 'D'.length));
    }

    String T = input.substring(input.indexOf('T') + 'T'.length,
        input.indexOf(']', input.indexOf('T') + 'T'.length));

    if (V.isEmpty) {
      logFile('resultD -$H $O $S $D $T');
    } else {
      logFile('resultV -$H $O $S $D $V $T');
    }

    if (sysList!.isNotEmpty && diaList!.isNotEmpty)
    {
      printf('------------sys-->${sysList.length}----dia-->${diaList.length}');

      int? maxSys = getMaxValue(sysList);

      //S = maxSys.toString();

      //printf('<--------systolic---->$S');

      try {
        double adjustSys = adjustSystolicBP(
            maxSys!.toDouble(), int.parse(H.toString()), double.parse(hrv));
        S = adjustSys.toInt().toString();
        printf('<-----adjustSys---systolic---->$S---double--->$adjustSys');
      } catch (e) {
        S = maxSys.toString();
        printf('<------exe-adjust-sys--->$e');
      }

      int? maxDia = getMaxValue(diaList);

      D = maxDia.toString();

      //logFile('------------sys-total--->$maxSys----dia-total---->$maxDia');
      logFile('------------sys--max--->$S----dia--max-->$D');
      update();
    } else {
      logFile('------empty------sys-total--->');
      logFile('------empty------sys--max--->');
    }

    logFile('-----hrvValue----->$hrv');

    measureModel = MeasureResult();
    measureModel!.deviceId = device?.remoteId.str.toString();
    measureModel!.userId = userId;
    measureModel!.heartRate = H;
    measureModel!.oxygen = O;
    measureModel!.temperature = T;
    measureModel!.bloodPressure = '$S/$D';
    measureModel!.hrVariability = hrv;
    measureModel!.isSync = 'false';
    measureModel!.reading = input;
    measureModel!.eValues = eList.toList();
    measureModel!.lValues = hrvList.toList();
    disconnectType = DisconnectType.ON_MEASURE_COMPLETION;

    logFile('---call---stop---command---576');
    // await writeCommand(CMD_STOP);

    if (state == BluetoothConnectionState.connected && device != null) {
      logFile('writing command: $cmdStop to device: ${device?.remoteId}');
      isCommandSent = true;
      var value = utf8.encode(cmdStop);
      logFile('Sending Command : $cmdStop - [$value]');

      // try {
      //   writeChar!.write(value);
      // } catch (e) {
      //   printf('exe-->$e');
      // }
    } else {
      printf('--else--write--command--716');
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
              ), () async {
            readChar?.setNotifyValue(true).then((value) => {
                  if (!isReadingProcessStarted)
                    {isReadingProcessStarted = true, listenCommand()}
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
      // writeCommand(CMD_STOP).then((value) => {
      //       logFile('-----call----stop----command----'),
      //       if (!value)
      //         {
      //           releaseDeviceInitFromApp(2).then((value) => {
      //                 logFile('stopAndGoBack - if--stop-command'),
      //                 context.loaderOverlay.hide(),
      //                 Get.back(result: 'back')
      //               })
      //         }
      //     });
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

  double adjustSystolicBP(double baseSys, int hr, double hrv) {
    double adjustedSys = baseSys;

    // Adjust for HR if HR > 80
    if (hr > 80) {
      adjustedSys += 0.4 * (hr - 80);
    }

    // Adjust for HRV if HRV < 80
    if (hrv < 80) {
      adjustedSys += 0.2 * (80 - hrv);
    }

    return adjustedSys;
  }
}
