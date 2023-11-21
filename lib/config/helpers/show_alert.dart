import 'dart:io';

import 'package:chat_app_provider/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:go_router/go_router.dart';

// ** Función que muestra el snackBar de error
void showSnackBar(BuildContext context, String message, String? title) {
  final size = MediaQuery.of(context).size;

  if (Platform.isAndroid) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        clipBehavior: Clip.none,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          title ?? 'Error',
          style: TextStyle(
            fontFamily: AppTheme.poppinsSemiBold,
            fontSize: size.width * .04,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: AppTheme.poppinsRegular,
            fontSize: size.width * .035,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Ok',
              style: TextStyle(
                fontFamily: AppTheme.poppinsSemiBold,
                fontSize: size.width * .04,
              ),
            ),
            onPressed: () => context.pop(),
          )
        ],
      ),
    );
  }
}
  // **