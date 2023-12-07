import 'package:chat_app_provider/presentation/providers/providers.dart';
import 'package:chat_app_provider/presentation/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_provider/config/config.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key,
    required this.text,
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    final isMyMessage = uid == authService.usuario!.uid;

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: isMyMessage
              ? MyMessage(
                  message: text,
                  uid: uid,
                )
              : IncomingMessage(
                  message: text,
                  uid: uid,
                ),
        ),
      ),
    );
  }
}

class MyMessage extends StatelessWidget {
  final String message;
  final String uid;

  const MyMessage({super.key, required this.message, required this.uid});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDarkModeActive = Provider.of<ThemeProvider>(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(size.width * .03),
        margin: EdgeInsets.only(
          bottom: size.height * .005,
          left: size.width * .2,
          right: size.width * .02,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: isDarkModeActive.appTheme.isDarkMode
              ? Colors.indigo[800]
              : Colors.indigo[200],
        ),
        child: Text(
          message,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppTheme.poppinsRegular,
            fontSize: size.width * .03,
            color: isDarkModeActive.appTheme.isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

class IncomingMessage extends StatelessWidget {
  final String message;
  final String uid;

  const IncomingMessage({super.key, required this.message, required this.uid});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDarkModeActive = Provider.of<ThemeProvider>(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(size.width * .03),
        margin: EdgeInsets.only(
          bottom: size.height * .005,
          left: size.width * .02,
          right: size.width * .2,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          color: isDarkModeActive.appTheme.isDarkMode
              ? Colors.grey[800]
              : Colors.grey[400],
        ),
        child: Text(
          message,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppTheme.poppinsRegular,
            fontSize: size.width * .03,
          ),
        ),
      ),
    );
  }
}
