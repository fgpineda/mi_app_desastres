import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'profile_page.dart';
import 'user_management_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdminUser = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  void checkAdmin() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool admin = await authService.isAdmin();
    setState(() {
      isAdminUser = admin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user?.email}'),
        actions: [
          TextButton(
            onPressed: () {
              authService.logout();
            },
            child: Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('UID: ${user?.uid}'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Editar mi perfil'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
            ),
            if (isAdminUser) ...[
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Gestionar Usuarios (Admin)'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UserManagementPage()));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
