import 'package:flutter/material.dart';

import 'package:chat_app_provider/config/config.dart';

//* Logo
class Logo extends StatelessWidget {
  final String title;

  const Logo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .05,
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/tag-logo.png',
              width: size.width * .4,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: size.height * .02,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: AppTheme.poppinsSemiBold,
                fontSize: size.width * .05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// !