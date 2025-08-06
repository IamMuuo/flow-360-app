import 'package:flow_360/config/config.dart';
import 'package:flutter/material.dart';

class Flow360App extends StatelessWidget {
  const Flow360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flow 360",
      routerConfig: AppRouter.router,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorSchemeSeed: Color(0xff285094),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorSchemeSeed: Color(0xff285094),
        brightness: Brightness.dark,
      ),
    );
  }
}
