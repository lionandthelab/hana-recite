import 'dart:math';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/app/sign_in/sign_in_view_model.dart';
import 'package:hanarecite/app/sign_in/sign_in_button.dart';
import 'package:hanarecite/constants/keys.dart';
import 'package:hanarecite/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanarecite/routing/app_router.dart';

final signInModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(firebaseAuthProvider)),
);

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInModel = ref.watch(signInModelProvider);
    ref.listen<SignInViewModel>(signInModelProvider, (_, model) async {
      if (model.error != null) {
        await showExceptionAlertDialog(
          context: context,
          title: Strings.signInFailed,
          exception: model.error,
        );
      }
    });
    return SignInPageContents(
      viewModel: signInModel,
      title: '',
    );
  }
}

class SignInPageContents extends StatelessWidget {
  const SignInPageContents({Key? key, required this.viewModel, this.title = ''})
      : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      AppRoutes.emailPasswordSignInPage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 200,
                child: SvgPicture.asset('assets/bible.svg',
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 64.0),
              SignInButton(
                key: emailPasswordButtonKey,
                text: Strings.signInWithEmailPassword,
                onPressed: viewModel.isLoading
                    ? null
                    : () => _showEmailPasswordSignInPage(context),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              const Text(
                Strings.or,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SignInButton(
                key: anonymousButtonKey,
                text: Strings.goAnonymous,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed:
                    viewModel.isLoading ? null : viewModel.signInAnonymously,
              ),
            ],
          ),
        );
      }),
    );
  }
}
