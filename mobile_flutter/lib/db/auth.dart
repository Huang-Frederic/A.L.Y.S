import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/snackbar.dart';
import '../utils/navigations.dart';

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
    navigateToHome(context, AxisDirection.right);
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
    navigateToLogin(context, AxisDirection.left);
  } catch (e) {
    snackBar(context,
        'Logout has failed, please check your credentials or call the admin.',
        isError: true);
    return;
  }
}
