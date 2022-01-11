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
    await signInAnonymously();
  }
}
