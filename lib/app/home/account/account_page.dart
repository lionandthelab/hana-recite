import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/common_widgets/avatar.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:hanarecite/constants/keys.dart';
import 'package:hanarecite/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AccountPage extends ConsumerWidget {
  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.accountPage),
        actions: <Widget>[
          TextButton(
            key: const Key(Keys.logout),
            child: const Text(
              Strings.logout,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context, firebaseAuth),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: _buildUserInfo(user),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _buildStartDate(),
              // _buildEndDate(),
              // const SizedBox(height: 8.0),
              // _buildDuration(),
              // const SizedBox(height: 8.0),
              _buildSettings(),
              const SizedBox(height: 8.0),
              SfDateRangePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSettings() {
    return Column(
      children: [
        Icon(
          Icons.settings,
          color: Colors.grey,
          size: 54,
        ),
        const SizedBox(height: 8),
        Text(
          "설정1",
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Icon(
          Icons.settings,
          color: Colors.grey,
          size: 54,
        ),
        const SizedBox(height: 8),
        Text(
          "설정2",
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
