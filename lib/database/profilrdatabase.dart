import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
class ProfileDatabase {
  //data service
  
  //store data
  String? databaseName;
  //if didn't login yet => login

  //if logged => show
  ProfileDatabase({this.databaseName});

  Future<String>openDatabase() async{
    //find location of data
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String databaseLocation = join(appDirectory.path,databaseName);
    // DatabaseFactory databaseFactory = await databaseFactoryIo;
    return databaseLocation;
  }
}