import 'package:flutter/foundation.dart';
import 'package:modmet/database/profilrdatabase.dart';
import 'package:modmet/model/profilemodel.dart';
class ProfileProvider with ChangeNotifier {
  //example data
  List<ProfileModel> profileModels =[
    ProfileModel(email: "A@email.com",password: "12345678"),
  ];
  //getting data
  List<ProfileModel> getProfileModel(){
    return profileModels;
  }
  addProfileProvider(ProfileModel statement) async {
    var db = await ProfileDatabase(databaseName: "profileModel.db").openDatabase();
    print(db);
    profileModels.insert(0,statement);
    profileModels.add(statement);
  }
}