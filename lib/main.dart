import 'package:aps_dsd/src/ui/pages/map_app/map_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/application/bindings/map_app_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child ?? const SizedBox(),
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/map_app',
      getPages: [
        GetPage(
          name: '/map_app',
          page: () => const MapApp(),
          binding: MapAppBinding(),
        )
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
