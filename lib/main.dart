import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/presentation/providers/providers.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => PasswordVisibilityProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(AppTheme()),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthService(),
          ),
          ChangeNotifierProvider(
            create: (context) => SocketService(),
          ),
          ChangeNotifierProvider(
            create: (context) => ChatService(),
          )
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.appTheme.getTheme(context),
      routerConfig: appRouter,
      title: 'Chat App - Provider',
    );
  }
}
