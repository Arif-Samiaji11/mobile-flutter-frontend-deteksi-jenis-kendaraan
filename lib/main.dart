import 'package:flutter/material.dart';
import 'package:apkksaya/core/style.dart';
import 'package:apkksaya/page/splash_Page.dart';

void main() {
  runApp(apkksaya());
}

class apkksaya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Stlyes.themeData(),
        home: HomePage(),
      ),
    );
  }
}
