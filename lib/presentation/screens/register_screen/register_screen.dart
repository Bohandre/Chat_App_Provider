import 'package:chat_app_provider/config/helpers/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/providers/providers.dart';
import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/presentation/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                    title: 'Crear una cuenta',
                  ),
                  _RegisterForm(),
                  Labels(
                    questionText: '¿Ya tienes una cuenta?',
                    textButton: 'Ingresa ahora!',
                    route: '/login',
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

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  final nameCtrl = TextEditingController(text: '');
  final emailCtrl = TextEditingController(text: '');
  final passCtrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    // ** Provider
    final passwordVisibility = Provider.of<PasswordVisibilityProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    // **

    // * Declaración de medíaQuery
    final size = MediaQuery.of(context).size;
    // *

    final textStyle = TextStyle(
      fontFamily: AppTheme.poppinsRegular,
      fontSize: size.width * .035,
      color: Colors.black54,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .03,
      ),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            CustomTextFormField(
              controller: nameCtrl,
              keyboardType: TextInputType.name,
              hint: 'Nombre',
              hintStyle: textStyle,
              prefixIcon: Icon(
                Icons.person_outlined,
                color: Colors.black45,
                size: size.width * .05,
              ),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            CustomTextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.name,
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
              text: 'Crear cuenta',
              style: TextStyle(
                fontFamily: AppTheme.poppinsRegular,
                fontSize: size.width * .04,
              ),
              buttonColor: Colors.blue[600],
              fixedSize: Size(size.width * .5, size.height * .04),
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final registerOk = await authService.resgister(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );

                      if (registerOk == true) {
                        // * Conectar al socket server
                        socketService.connect();
                        // *

                        // * Navegación
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => context.go('/users'));
                        // *
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            showSnackBar(
                                context, registerOk, 'Registro incorrecto'));
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () {},
      child: Text(
        'Términos y condiciones de uso',
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .04,
          color: Colors.black54,
        ),
      ),
    );
  }
}
