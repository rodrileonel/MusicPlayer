import 'package:flutter/material.dart';
import 'package:musicplayer/src/pages/home_page.dart';
import 'package:musicplayer/src/theme/theme.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Music Player',
      home: HomePage(),
    );
  }
}