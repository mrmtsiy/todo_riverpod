// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/utils/authentication_error.dart';
import 'package:todo_app_riverpod/utils/custom_text_style.dart';
import 'package:todo_app_riverpod/utils/loading_page.dart';
import 'package:todo_app_riverpod/utils/page_route.dart';
import 'package:todo_app_riverpod/view/signup_page.dart';
import 'package:todo_app_riverpod/view_model/controller/auth_controller.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _infoText = '';
    final authError = Authentication_error();
    final TextEditingController mailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final loadingNotifier = ref.watch(loadingProvider.notifier);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 250,
                width: 500,
                child: Image.asset(
                  'assets/unlock-6471930_1280.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  children: [
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
                              cursorColor: Colors.white,
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
                              cursorColor: Colors.white,
                              obscureText: true,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ForgotPassPage()),
                          // );
                        },
                        child: Text(
                          "パスワードをお忘れの方はこちら",
                          style: whiteTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 64,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 50),
                      child: TextButton(
                        onPressed: () async {
                          loadingNotifier.startLoading();
                          final notifier =
                              ref.read(authControllerProvider.notifier);
                          try {
                            await notifier.signIn(
                                mailController.text, passwordController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoutePage()),
                            );
                            _infoText = 'ログインしました';
                            final snackBar = SnackBar(
                                content: Text(
                              _infoText,
                              textAlign: TextAlign.center,
                            ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            final snackBar = SnackBar(
                                backgroundColor: Colors.black12,
                                content: Text(
                                  authError.login_error_msg(e.toString()),
                                  textAlign: TextAlign.center,
                                ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            loadingNotifier.endLoading();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffeeeeee),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'ログイン',
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 30,
                        bottom: 74,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              "新規登録",
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
