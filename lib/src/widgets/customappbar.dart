
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:20,vertical:10),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.chevronLeft),
            Spacer(),
            FaIcon(FontAwesomeIcons.comment),
            SizedBox(width:20),
            FaIcon(FontAwesomeIcons.headphones),
          ],
        ),
      ),
    );
  }
}