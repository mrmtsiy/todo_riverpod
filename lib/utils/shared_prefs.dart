// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   static SharedPreferences? prefsInstance;

//   static Future<void> setInstance() async {
//     //sharedPrefsがnullなら
//     prefsInstance ??= await SharedPreferences.getInstance();
//   }

//   static Future<void> setUid(String newUid) async {
//     await prefsInstance!.setString('uid', newUid);
//   }

//   static String? getUid() {
//     String? uid = prefsInstance!.getString('uid') ?? '';
//     return uid;
//   }
// }
