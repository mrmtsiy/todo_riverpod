// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/repositories/auth_repository.dart';
import 'package:todo_app_riverpod/utils/authentication_error.dart';
import 'package:todo_app_riverpod/utils/custom_text_style.dart';
import 'package:todo_app_riverpod/utils/loading_page.dart';
import 'package:todo_app_riverpod/utils/page_route.dart';
import 'package:todo_app_riverpod/view/signin_page.dart';
import 'package:todo_app_riverpod/view/top_page.dart';
import 'package:todo_app_riverpod/view_model/controller/auth_controller.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = useTextEditingController();
    final TextEditingController mailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final notifier = ref.read(authControllerProvider.notifier);
    final loadingNotifier = ref.watch(loadingProvider.notifier);
    final authError = Authentication_error();
    String _infoText = "";
    String _registerPassword = '';
    // ignore: non_constant_identifier_names
    bool _pswd_OK = false;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
            ),
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Text(
                  "ToDoアプリへようこそ！\n アカウントを作成して\nあなただけのToDoを作成しよう！",
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 64,
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kWhiteColor,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      margin: EdgeInsets.only(right: 18),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'アカウント名',
                          hintStyle: whiteTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        style: whiteTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 64,
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kWhiteColor,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      margin: EdgeInsets.only(right: 18),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: mailController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'メールアドレス',
                          hintStyle: whiteTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        style: whiteTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(
                  top: 20,
                  left: 18,
                  bottom: 0,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kWhiteColor,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      margin: EdgeInsets.only(right: 18),
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        maxLength: 20,
                        controller: passwordController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'パスワード',
                          hintStyle: whiteTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        style: whiteTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                        onChanged: (text) {
                          if (text.length >= 8) {
                            _registerPassword = text;
                            _pswd_OK = true;
                          } else {
                            _pswd_OK = false;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 64,
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                child: TextButton(
                  onPressed: () async {
                    loadingNotifier.startLoading();
                    if (_pswd_OK) {
                      try {
                        await notifier.signUp(mailController.text,
                            passwordController.text, nameController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RoutePage()),
                        );
                        _infoText = 'Todoアプリへようこそ';
                        final snackBar = SnackBar(
                            backgroundColor: Colors.black12,
                            content: Text(
                              _infoText,
                              textAlign: TextAlign.center,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = SnackBar(
                            backgroundColor: Colors.black12,
                            content: Text(
                              authError.register_error_msg(e.toString()),
                              textAlign: TextAlign.center,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } finally {
                        loadingNotifier.endLoading();
                      }
                    } else {
                      _infoText = 'パスワードは8文字以上で入力して下さい。';
                      final snackBar = SnackBar(
                          backgroundColor: Colors.black12,
                          content: Text(
                            _infoText,
                            textAlign: TextAlign.center,
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xffeeeeee),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    '新規アカウントの作成',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 64,
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(authRepositoryProvider)
                          .signInAnonymously();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RoutePage()),
                      );
                      _infoText = 'ゲストログインしました';
                      final snackBar = SnackBar(
                          backgroundColor: Colors.black12,
                          content: Text(_infoText));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {}
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'ゲストでログインする',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                  bottom: 74,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        "ログイン",
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (loadingNotifier.isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
