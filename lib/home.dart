import 'package:auth_flutter/dto/user.dart';
import 'package:auth_flutter/edit_user.dart';
import 'package:auth_flutter/login.dart';
import 'package:auth_flutter/services/user_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();

  void signOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void goToEditUser(int? userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPage(userId: userId)),
    );
  }

  Future<List<User>> fetchUsers() async {
    try {
      return await _userService.getList();
    } catch (e) {
      signOut();
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => goToEditUser(null),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder(
      future: fetchUsers(),
      builder: (context, snapshot) {
        List<User> users = snapshot.data ?? [];
        return RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future.value();
          },
          child: _buildListView(users),
        );
      },
    );
  }

  ListView _buildListView(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final User user = users[index];
        return Dismissible(
          key: ValueKey(user.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text('DELETE'),
                ),
                Icon(Icons.delete),
              ],
            ),
          ),
          onDismissed: (direction) {
            _userService.delete(user.id).then((value) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Usuário deletado com sucesso!'),
              ));
            });
          },
          child: ListTile(
            title: Text(user.name),
            subtitle: Text(user.username),
            onTap: () {
              goToEditUser(user.id);
            },
          ),
        );
      },
    );
  }
}
