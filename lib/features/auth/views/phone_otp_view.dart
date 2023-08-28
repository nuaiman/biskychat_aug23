import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

class PhoneOtpView extends ConsumerWidget {
  final String phoneNumber;
  const PhoneOtpView({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PinCodeFields(
              length: 6,
              onComplete: (output) {
                ref.read(authControllerProvider.notifier).verifySession(
                      context: context,
                      userId: phoneNumber.substring(1),
                      otp: output,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
