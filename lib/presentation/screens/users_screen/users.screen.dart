import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:animate_do/animate_do.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/presentation/models/models.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final usersService = UsersListService();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];

  // final users = [
  //   User(uid: '1', nombre: 'Claire', email: 'test1@test.com', online: true),
  //   User(uid: '2', nombre: 'Yocelin', email: 'test2@test.com', online: false),
  //   User(uid: '3', nombre: 'Paola', email: 'test3@test.com', online: true),
  // ];

  @override
  void initState() {
    super.initState();

    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ** Llamada a los providers
    final authService = Provider.of<AuthService>(context);
    final user = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    // **

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user!.nombre,
          style: TextStyle(
            fontFamily: AppTheme.poppinsMedium,
            fontSize: size.width * .045,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // * Desconectar del socket server
            socketService.disconnect();
            // *

            // * Regresar al login
            context.go('/login');
            // *

            // * Eliminar el token
            AuthService.deleteToken();
            // *
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: size.width * .04),
            child: socketService.serverStatus == ServerStatus.Online
                ? FadeIn(
                    child: Icon(Icons.check_circle, color: Colors.blue[400]))
                : FadeIn(
                    child: Icon(Icons.offline_bolt, color: Colors.red[800])),
          ),
          IconButton(
            onPressed: () {
              context.push('/theme-changer');
            },
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: const WaterDropMaterialHeader(),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile(users[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }

  _loadUsers() async {
    const CircularProgressIndicator();

    users = await usersService.getUsers();

    setState(() {});

    refreshController.refreshCompleted();
  }
}

// ** UserListTile
class _UserListTile extends StatelessWidget {
  final User user;

  const _UserListTile(this.user);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userReceiving = user;
        context.push('/chat');
      },
      title: Text(
        user.nombre,
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .04,
        ),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .025,
        ),
      ),
      leading: CircleAvatar(
        child: Text(user.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: size.width * .03,
        height: size.width * .03,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: user.online ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
// **
