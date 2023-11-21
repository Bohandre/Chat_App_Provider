import 'package:chat_app_provider/config/helpers/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/providers/providers.dart';
import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: SizedBox(
              height: size.height * .9,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    title: 'Messenger',
                  ),
                  _Form(),
                  Labels(
                    questionText: '¿No tienes una cuenta?',
                    textButton: 'Crea una ahora',
                    route: '/register',
                  ),
                  _TermsAndConditions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController(text: '');
  final passCtrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    // ** Llamada a los providers
    final authService = Provider.of<AuthService>(context);
    final passwordVisibility = Provider.of<PasswordVisibilityProvider>(context);
    final socketService = Provider.of<SocketService>(context);
    // **

    final size = MediaQuery.of(context).size;

    final textStyle = TextStyle(
      fontFamily: AppTheme.poppinsRegular,
      fontSize: size.width * .035,
      color: Colors.black54,
    );

    return SizedBox(
      width: size.width * .8,
      child: Column(
        children: [
          CustomTextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            hint: 'Email',
            hintStyle: textStyle,
            prefixIcon: Icon(
              Icons.mail_outline_outlined,
              color: Colors.black45,
              size: size.width * .05,
            ),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          CustomTextFormField(
            controller: passCtrl,
            keyboardType: TextInputType.text,
            hint: 'Password',
            hintStyle: textStyle,
            obscureText: !passwordVisibility.isPasswordVisible,
            prefixIcon: IconButton(
              splashRadius: 1,
              onPressed: () {
                passwordVisibility.togglePasswordVisibility();
              },
              icon: passwordVisibility.isPasswordVisible
                  ? Icon(
                      Icons.lock_outline,
                      color: Colors.black45,
                      size: size.width * .05,
                    )
                  : Icon(
                      Icons.lock_open_outlined,
                      color: Colors.black45,
                      size: size.width * .05,
                    ),
            ),
          ),
          SizedBox(
            height: size.height * .04,
          ),
          CustomFilledButton(
            text: 'Ingresar',
            style: TextStyle(
              fontFamily: AppTheme.poppinsRegular,
              fontSize: size.width * .04,
            ),
            buttonColor: Colors.blue[600],
            fixedSize: Size(size.width * .5, size.height * .04),
            onPressed: authService.autenticando
                ? null
                : () async {
                    // print('******* ${emailCtrl.text} - ${passCtrl.text} *******');

                    // * Enviar los datos de los inputs a la petición de login
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    // *

                    if (loginOk == true) {
                      // * Conectar al socket server
                      socketService.connect();
                      // *

                      // * Navegación
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => context.go('/users'));
                      // *
                    } else {
                      // * Error de login
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          showSnackBar(context, loginOk, 'Login incorrecto'));
                      // *
                    }

                    FocusManager.instance.primaryFocus?.unfocus();

                    // context.go('/users');
                  },
          ),
        ],
      ),
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return TextButton(
      onPressed: () {},
      child: Text(
        'Términos y condiciones de uso',
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .035,
          color: themeProvider.appTheme.isDarkMode
              ? Colors.white.withOpacity(0.8)
              : Colors.black,
        ),
      ),
    );
  }
}
