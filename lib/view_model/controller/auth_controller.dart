import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(
    ref.read,
    initialUser: ref.read(authRepositoryProvider).getCurrentUser(),
  )..appStarted(),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;
  final _auth = FirebaseAuth.instance;

  AuthController(this._read, {User? initialUser}) : super(initialUser) {
    // Userの変更を検知して状態を更新
    _auth.userChanges().listen((user) {
      state = user;
    });
  }

  //アプリ開始
  void appStarted() async {
    //Currentユーザを取得
    final user = _read(authRepositoryProvider).getCurrentUser();
    // ログインされていなければ、匿名でサインインしてログインさせる。
  }

  // サインアウト
  Future<void> signOut() async {
    // サインアウトメソッド
    await _read(authRepositoryProvider).signOut();
  }

  Future<void> signIn(String mail, String password) async {
    await _read(authRepositoryProvider).signIn(mail: mail, password: password);
  }

  Future<void> signUp(String mail, String password, String name) async {
    await _read(authRepositoryProvider)
        .signUp(mail: mail, password: password, name: name);
  }
}
