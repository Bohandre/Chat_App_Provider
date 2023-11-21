import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_app_provider/config/config.dart';

//* Labels
class Labels extends StatelessWidget {
  final String route;
  final String questionText;
  final String textButton;

  const Labels(
      {super.key,
      required this.route,
      required this.questionText,
      required this.textButton});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .03,
      ),
      child: Column(
        children: [
          Text(
            questionText,
            style: TextStyle(
              fontFamily: AppTheme.poppinsRegular,
              fontSize: size.width * .04,
            ),
          ),
          TextButton(
            onPressed: () {
              context.push(route);
            },
            child: Text(
              textButton,
              style: TextStyle(
                fontFamily: AppTheme.poppinsMedium,
                fontSize: size.width * .05,
                color: Colors.blue[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// !