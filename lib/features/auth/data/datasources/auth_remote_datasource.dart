// Path: lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract interface class IAuthRemoteDatasource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel> loginWithGoogle();
  Future<void> logout();
  UserModel? getCurrentUser();
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(result.user!);
  }

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.updateDisplayName(name);
    return _mapUser(result.user!);
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign in cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return _mapUser(result.user!);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  UserModel _mapUser(User user) => UserModel(
    id: user.uid,
    email: user.email ?? '',
    name: user.displayName,
    photoUrl: user.photoURL,
  );
}