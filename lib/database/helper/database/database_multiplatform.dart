
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'database_mobile.dart';
import 'database_windows.dart';
import 'database_web.dart';

Future<DatabaseFactory> getDatabaseFactory() {
  if(kIsWeb) {
    return getDatabaseFactoryWeb();
  } else if(Platform.isAndroid || Platform.isIOS) {
    return getDatabaseFactoryMobile();
  } else if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return getDatabaseFactoryDesktop();
  }
  throw UnimplementedError("Not implemented platform");
}

Future<String> getDatabasePath() {
  if(kIsWeb) {
    return getDatabasePathWeb();
  } else if(Platform.isAndroid || Platform.isIOS) {
    return getDatabasePathMobile();
  } else if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return getDatabasePathDesktop();
  }
  throw UnimplementedError("Not implemented platform");
}

Future<Database> openDatabase({
  int? version,
  String? password = "only work in android",
  OnDatabaseConfigureFn? onConfigure,
  OnDatabaseCreateFn? onCreate,
  OnDatabaseVersionChangeFn? onUpgrade,
  OnDatabaseVersionChangeFn? onDowngrade,
  OnDatabaseOpenFn? onOpen,
  bool readOnly = false,
  bool singleInstance = true,
}) async {
  final dbPath = await getDatabasePath();
  final dbFactory = await getDatabaseFactory();

  final options = OpenDatabaseOptions(
    version: version,
    onConfigure: onConfigure,
    onCreate: onCreate,
    onUpgrade: onUpgrade,
    onDowngrade: onDowngrade,
    onOpen: onOpen,
    readOnly: readOnly,
    singleInstance: singleInstance,
  );

  if(kIsWeb) {
    return openDatabaseWeb(dbFactory, dbPath, options);
  } else if(Platform.isAndroid || Platform.isIOS) {
    return openDatabaseMobile(dbFactory, dbPath, password, options);
  } else if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return openDatabaseDesktop(dbFactory, dbPath, options);
  }
  throw UnimplementedError("Not implemented platform");
}