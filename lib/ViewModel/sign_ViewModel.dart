import 'package:supabase_flutter/supabase_flutter.dart';

class SignViewmodel {
  final supabase = Supabase.instance.client;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return true;
      }
    } on AuthException catch (e) {
      print(
        "=================================================Error while logging in with Email & Password: $e=================================================",
      );
    }
    return false;
  }

  Future<bool> signUpWithEmailAndPassword(
    String email,
    String password,
    String Name,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': Name},
      );

      if (response.user != null) {
        return true;
      }
    } on AuthException catch (e) {
      print(
        "=================================================Error while logging in with Email & Password: $e=================================================",
      );
    }
    return false;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
