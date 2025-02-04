import 'dart:async';

import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "doori.db";
  static const databaseVersion = 1;

  static const table = 'MeasureTable';
  static const columnId = 'id';
  static const columnDeviceId = 'deviceId';
  static const columnUserId = 'userId';
  static const columnHeartRate = 'heartRate';
  static const columnOxygen = 'oxygen';
  static const columnTemperature = 'temperature';
  static const columnBloodPressure = 'bloodPressure';
  static const columnHrVariability = 'hrVariability';
  static const columnActivity = 'activity';
  static const columnBodyHealth = 'bodyHealth';
  static const columnDateTime = 'dateTime';
  static const columnMeasureTime = 'measureTime';
  static const columnIsSync = 'isSync';
  static const columnReading = 'reading';
  static const columnTimeStamp = 'timeStamp';
  static const columnHealthTips = 'healthTips';

  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  getDatabase() async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return openDatabase(path, version: databaseVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDeviceId TEXT NOT NULL,
            $columnUserId TEXT NOT NULL,
            $columnHeartRate TEXT NOT NULL,
            $columnOxygen TEXT NOT NULL,
            $columnTemperature TEXT NOT NULL,
            $columnBloodPressure TEXT NOT NULL,
            $columnHrVariability TEXT NOT NULL,
            $columnActivity TEXT NOT NULL,
            $columnBodyHealth TEXT NOT NULL,
            $columnDateTime TEXT NOT NULL,
            $columnMeasureTime TEXT NOT NULL,
            $columnIsSync TEXT NOT NULL,
            $columnReading TEXT NOT NULL,
            $columnTimeStamp INTEGER NOT NULL,
            $columnHealthTips TEXT NOT NULL
            )
          ''');
  }

  Future<int> insert(MeasureResult measureResult) async {
    Database db = await instance.database;

    return await db
        .insert(table, getTableFormatData(measureResult))
        .whenComplete(() {
      //printf('record_inserted');
    });
  }

  Future<void> update(Database db, MeasureResult measureResult) async {
    await db.update(table, getTableFormatData(measureResult),
        where: 'id = ?', whereArgs: [measureResult.id]);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(userId) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnUserId LIKE '%$userId%'");
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryNonSyncRows(Database db) async {
    printf("SYNC_CALL - queryNonSyncRows1");
    printf("SYNC_CALL - queryNonSyncRows2");
    return await db.query(table,
        where: "$columnIsSync = ?", whereArgs: [AppConstants.isFalse]);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTable() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<void> syncNonSyncedRows(List<Map<String, dynamic>> value,
      FirebaseDatabase dbRef, Database db) async {
    printf("SYNC_CALL - ${value.length}");

    List<MeasureResult> measureList = [];
    for (var row in value) {
      printf("SYNC_CALL - For loop row start $row");
      measureList.add(MeasureResult.fromJson(row));
      printf("SYNC_CALL - For loop row end $row");
    }
    printf("SYNC_CALL -  measureList.length = ${measureList.length}");

    var da = dbRef.ref().child(AppConstants.tableMeasure);
    printf("SYNC_CALL - $da");
    for (var measureModel in measureList) {
      printf("SYNC_CALL - For loop measureModel start");

      measureModel.isSync = AppConstants.isTrue;
      await da
          .child(measureModel.userId.toString())
          .push()
          .set(measureModel.toJson())
          .whenComplete(() async {
        printf("SYNC_CALL -  Synced = ${measureModel.dateTime}");
        await instance.update(db, measureModel);
        printf(
            'SYNC_CALL- Updated local ${measureModel.dateTime} ${measureModel.id}');
      }).onError((error, stackTrace) => {
                printf(
                    'SYNC_CALL- Sync Failed =  ${measureModel.dateTime}\n $error \n\n $stackTrace')
              });
    }

    return;
  }

  Map<String, Object?> getTableFormatData(MeasureResult measureResult) {
    return {
      columnDeviceId: measureResult.deviceId,
      columnUserId: measureResult.userId,
      columnHeartRate: measureResult.heartRate,
      columnOxygen: measureResult.oxygen,
      columnTemperature: measureResult.temperature,
      columnBloodPressure: measureResult.bloodPressure,
      columnHrVariability: measureResult.hrVariability,
      columnActivity: measureResult.activity,
      columnBodyHealth: measureResult.bodyHealth,
      columnDateTime: measureResult.dateTime,
      columnMeasureTime: measureResult.measureTime,
      columnIsSync: measureResult.isSync,
      columnReading: measureResult.reading,
      columnTimeStamp: measureResult.timeStamp,
      columnHealthTips: measureResult.healthTips,
    };
  }
}
