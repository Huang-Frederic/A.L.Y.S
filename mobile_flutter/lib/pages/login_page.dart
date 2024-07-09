import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_flutter/db/auth.dart';
import '../utils/colors.dart';
import '../utils/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      snackBar(context, 'Please fill in all fields.', isError: true);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      snackBar(context, 'Please enter a valid email address.', isError: true);
      return;
    }

    authLogin(context, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlysColors.black,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 150,
                  height: 150,
                  colorFilter: const ColorFilter.mode(
                      AlysColors.alysBlue, BlendMode.srcIn),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: _emailController,
                  cursorColor: AlysColors.kingYellow,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AlysColors.alysBlue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                  ),
                  style: const TextStyle(color: AlysColors.alysBlue),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  cursorColor: AlysColors.kingYellow,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AlysColors.alysBlue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AlysColors.kingYellow),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: AlysColors.alysBlue),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    backgroundColor: AlysColors.kingYellow,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Open the Gates',
                    style: TextStyle(
                        color: AlysColors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'This app is private, ask the owner for access.',
                style: TextStyle(
                  fontSize: 11,
                  color: AlysColors.alysBlue.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
