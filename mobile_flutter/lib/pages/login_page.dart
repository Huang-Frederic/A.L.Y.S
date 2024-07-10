import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_flutter/database/auth.dart';
import '../utils/colors.dart';
import '../widgets/snackbar.dart';

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
        padding: EdgeInsets.all(40.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200.h),
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 150.w,
                  height: 150.h,
                  colorFilter: const ColorFilter.mode(
                      AlysColors.alysBlue, BlendMode.srcIn),
                ),
                SizedBox(height: 50.h),
                TextField(
                  controller: _emailController,
                  cursorColor: AlysColors.kingYellow,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: AlysColors.alysBlue, fontSize: 16.sp),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AlysColors.kingYellow),
                      borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AlysColors.kingYellow),
                      borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                    ),
                  ),
                  style: TextStyle(color: AlysColors.alysBlue, fontSize: 16.sp),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: _passwordController,
                  cursorColor: AlysColors.kingYellow,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: AlysColors.alysBlue, fontSize: 16.sp),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AlysColors.kingYellow),
                      borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AlysColors.kingYellow),
                      borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: AlysColors.alysBlue, fontSize: 16.sp),
                ),
                SizedBox(height: 32.h),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 50.0.w, vertical: 15.0.h),
                    backgroundColor: AlysColors.kingYellow,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text(
                    'Open the Gates',
                    style: const TextStyle(
                        color: AlysColors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0.h),
              child: Text(
                'This app is private, ask the owner for access.',
                style: TextStyle(
                  fontSize: 11.sp,
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
