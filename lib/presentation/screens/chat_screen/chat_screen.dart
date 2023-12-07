import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/models/models.dart';
import 'package:chat_app_provider/presentation/providers/providers.dart';
import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/presentation/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final textInputController = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  bool _isWriting = false;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService!.socket.on('personal-message', _listenMessage);

    _loadMessageHistory(chatService!.userReceiving!.uid);
  }

  void _loadMessageHistory(String userId) async {
    List<Message> chat = await chatService!.getChats(userId);

    // print(chat);

    // Toma el historial de chat y lo mapea a un ChatMessage
    final history = chat.map((m) => ChatMessage(
          text: m.message,
          uid: m.de,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));

    // Inserta el historial de chat.
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
      uid: payload['de'],
      text: payload['message'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final userReceiving = chatService!.userReceiving;

    final isDarkModeActive = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: size.height * .07,
          elevation: 0.5,
          title: Column(
            children: [
              CircleAvatar(
                maxRadius: 18,
                child: Text(
                  userReceiving!.nombre.substring(0, 2),
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsRegular,
                    fontSize: size.width * .04,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .01,
              ),
              Text(
                userReceiving.nombre,
                style: TextStyle(
                  fontFamily: AppTheme.poppinsRegular,
                  fontSize: size.width * .03,
                ),
              )
            ],
          ),
        ),
        body: SizedBox(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .03,
                  vertical: size.height * .02,
                ),
                child: SizedBox(
                  child: SafeArea(
                    child: SizedBox(
                      width: size.width * .9,
                      child: CustomTextFormField(
                        controller: textInputController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.text,
                        hint: 'Escribe un mensaje...',
                        hintStyle: TextStyle(
                          fontFamily: AppTheme.poppinsMedium,
                          fontSize: size.width * .0321,
                          color: isDarkModeActive.appTheme.isDarkMode
                              ? Colors.indigo[500]
                              : Colors.grey,
                        ),
                        onFieldSubmitted: (value) {
                          _handleSubmit(value);
                        },
                        onChanged: (text) {
                          setState(() {
                            if (text.trim().isNotEmpty) {
                              _isWriting = true;
                            } else {
                              _isWriting = false;
                            }
                          });
                        },
                        suffixIcon: IconButton(
                          onPressed: _isWriting
                              ? () => _handleSubmit(textInputController.text)
                              : null,
                          icon: Icon(
                            Icons.send_outlined,
                            color: isDarkModeActive.appTheme.isDarkMode
                                ? Colors.indigo[800]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    textInputController.clear();
    focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService!.usuario!.uid,
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketService!.emit('personal-message', {
      'de': authService!.usuario!.uid,
      'para': chatService!.userReceiving!.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService!.socket.off('personal-message');
    super.dispose();
  }
}
