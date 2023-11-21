import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/services/services.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                Text(
                  'Validando información...',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsRegular,
                    fontSize: size.width * .04,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    print('check login state...');
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();
    print(autenticado);

    if (autenticado) {
      socketService.connect();
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/users'));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
    }
  }
}
