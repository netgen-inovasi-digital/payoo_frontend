import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/my_theme.dart';

Future<void> main() async {
  //wait for bindingsx`
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage first
  await GetStorage.init();

  // Initialize permissions status (optional - akan di-request saat diperlukan)
  await Permission.bluetooth.status;
  await Permission.bluetoothConnect.status;
  await Permission.bluetoothScan.status;
  // await Permission.location.status;

  // initialize local db (hive) and register our custom adapters
  // await MyHive.init(
  //     registerAdapters: (hive) {
  //       hive.registerAdapter(UserModelAdapter());
  //       //myHive.registerAdapter(OtherAdapter());
  //     }
  // );

  // // init shared preference
  // await MySharedPref.init();   

  // // inti fcm services
  // await FcmHelper.initFcm();

  // // initialize local notifications service
  // await AwesomeNotificationsHe lper.init(); 

  runApp(ScreenUtilInit(
    //todo add your (Xd/Figma) artboard size
    designSize: const Size(360, 640),
    minTextAdapt: true,
    splitScreenMode: true,
    useInheritedMediaQuery: true,
    rebuildFactor: (old, data) => true,
    builder: (context, widget) {
      return GetMaterialApp(
        //todo add your app name (Payoo)
        title: 'Payoo',
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          bool themeIsLight = true;
          return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              // prevent font from scalling (some people use big/small device fonts)
              // but we want our app font to still the same and dont get affected
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              )); 
        },    
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
   
      );
    },
  ));
}
