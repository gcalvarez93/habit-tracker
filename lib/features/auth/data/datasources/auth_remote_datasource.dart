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

  /// Actualiza el nombre visible, recarga el usuario y lo devuelve
  /// (`null` si no hay sesión).
  Future<UserModel?> updateDisplayName(String name);

  UserModel? getCurrentUser();
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasource({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(_requireUser(result, 'Login failed'));
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
    final user = _requireUser(result, 'Registration failed');
    await user.updateDisplayName(name);
    return _mapUser(user);
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
    return _mapUser(_requireUser(result, 'Google sign in failed'));
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<UserModel?> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    await user.updateDisplayName(name);
    await user.reload();
    final refreshed = _auth.currentUser;
    return refreshed == null ? null : _mapUser(refreshed);
  }

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  User _requireUser(UserCredential credential, String message) {
    final user = credential.user;
    if (user == null) throw StateError(message);
    return user;
  }

  UserModel _mapUser(User user) => UserModel(
    id: user.uid,
    email: user.email ?? '',
    name: user.displayName,
    photoUrl: user.photoURL,
  );
}