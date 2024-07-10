import 'package:flutter/material.dart';
import 'package:mobile_flutter/pages/home_page.dart';
import 'package:mobile_flutter/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/snackbar.dart';
import '../utils/navigations.dart';

bool checkSession(BuildContext context) {
  final SupabaseClient supabase = Supabase.instance.client;

  try {
    final session = supabase.auth.currentSession;

    if (session != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    snackBar(context, 'Session recovery has failed, please login again.',
        isError: true);
    return false;
  }
}

void authLogin(BuildContext context, String email, String password) async {
  final SupabaseClient supabase = Supabase.instance.client;
  try {
    final AuthResponse response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // ignore: unused_local_variable
    final Session? session = response.session;
    // ignore: unused_local_variable
    final User? user = response.user;

    if (!context.mounted) return;
    navigateTo(context, const HomePage(), AxisDirection.right);
  } catch (e) {
    snackBar(context,
        'Login has failed, please check your credentials or call the admin.',
        isError: true);
    return;
  }
}

Future<void> authLogout(BuildContext context) async {
  final SupabaseClient supabase = Supabase.instance.client;
  try {
    await supabase.auth.signOut();
    if (!context.mounted) return;
    navigateTo(context, const LoginPage(), AxisDirection.left);
  } catch (e) {
    snackBar(context,
        'Logout has failed, please check your credentials or call the admin.',
        isError: true);
    return;
  }
}
