import 'package:custom_buttons/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanarecite/app/onboarding/onboarding_view_model.dart';

class OnboardingPage extends ConsumerWidget {
  Future<void> onGetStarted(BuildContext context, WidgetRef ref) async {
    final onboardingViewModel = ref.read(onboardingViewModelProvider.notifier);
    await onboardingViewModel.completeOnboarding();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '하나암송',
              style: Theme.of(context).textTheme.titleLarge,
              textScaleFactor: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 200,
              child: SvgPicture.asset('assets/bible.svg',
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 12.0),
            Text(
              '하나님의 말씀을 선포하세요!',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64.0),
            CustomRaisedButton(
              onPressed: () => onGetStarted(context, ref),
              color: Colors.blue,
              borderRadius: 30,
              child: Text(
                '시작하기',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
