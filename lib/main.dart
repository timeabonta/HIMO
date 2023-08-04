import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'launchscreen/launch.dart';
import 'package:flutter/services.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => runApp(MyApp()));

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child){
        return MaterialApp(
          title: 'HIMO',
          home: LaunchScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            //primaryColor: Color(0xff74bec9)
          ),
        );
      },
      designSize: const Size(375, 667),
    );
  }
}
