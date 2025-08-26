import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/my_theme.dart';

Future<void> main() async {
  //wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

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
  // await AwesomeNotificationsHelper.init(); 

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
