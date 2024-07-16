import 'package:flutter/material.dart';
import 'package:mobile_flutter/pages/login_page.dart';
import 'package:mobile_flutter/pages/nav_page.dart';
import 'package:mobile_flutter/utils/check_connectivity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/snackbar.dart';
import '../utils/navigations.dart';

bool checkSession(BuildContext context) {
  final SupabaseClient supabase = Supabase.instance.client;

  try {
    final session = supabase.auth.currentSession;

    return session != null;
  } catch (e) {
    snackBar(context, 'Session recovery has failed, please login again.',
        isError: true);
    return false;
  }
}

void authLogin(BuildContext context, String email, String password) async {
  final SupabaseClient supabase = Supabase.instance.client;

  if (!await handleConnectivity()) {
    if (!context.mounted) return;
    snackBar(context,
        'No internet connection. Please check your WiFi or mobile data.',
        isError: true);
    return;
  }

  try {
    final AuthResponse response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final Session? session = response.session;
    final User? user = response.user;

    if (!context.mounted) return;

    if (session != null && user != null) {
      navigateTo(context, const NavPage(), AxisDirection.right);
    } else {
      snackBar(context,
          'Login has failed. Please check your credentials and try again.',
          isError: true);
    }
  } catch (error) {
    if (!context.mounted) return;
    if (error is AuthException) {
      snackBar(context, 'Login has failed: ${error.message}', isError: true);
    } else {
      snackBar(context, 'Unexpected error: $error', isError: true);
    }
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
