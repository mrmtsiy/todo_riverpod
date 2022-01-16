import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';

abstract class BaseAuthRepository {
// ログイン状態の確認用（ログイン状態の変更や初期化時にイベントする）
  Stream<User?> get authStateChanges;

  // サインイン（著名ユーザを作成）
  Future<void> signInAnonymously();
  // 現在サインインしているユーザを取得する。
  User? getCurrentUser();
  // ログアウト
  Future<void> signOut();
  Future<void> signUp(
      {required String mail, required String password, required String name});
  Future<void> signIn({required String mail, required String password});
}

// AuthRepositoryを提供し、ref.readを渡してアクセスできるようにする
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

// 認証リポジトリクラス
class AuthRepository implements BaseAuthRepository {
  // アプリ内の他のプロバイダーを読み取ることを許可
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } catch (e) {
      e.toString();
    }
  }

  @override
  Future<void> signInAnonymously() async {
    await _read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await _read(firebaseAuthProvider).signOut();
  }

  @override
  Future<void> signIn({required String mail, required String password}) async {
    if (mail.isEmpty) {
      throw 'メールアドレスを入力して下さい';
    }
    if (password.isEmpty) {
      throw 'パスワードを入力して下さい';
    }
    final userInfo = await _read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: mail, password: password);
    final uid = userInfo.user!.uid;
  }

  @override
  Future<void> signUp(
      {required String mail,
      required String password,
      required String name}) async {
    if (mail.isEmpty) {
      throw 'メールアドレスを入力して下さい';
    }
    if (password.isEmpty) {
      throw 'パスワードを入力して下さい';
    }
    final UserCredential result = await _read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: mail, password: password);
    final email = result.user!.email;

    await _read(firebaseFirestoreProvider).collection('users').add({
      'displayName': name,
      'email': email,
      'password': password,
      'createAt': Timestamp.now(),
    });
  }
}
