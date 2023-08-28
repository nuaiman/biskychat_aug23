import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

class VerifyPhoneSessionView extends ConsumerWidget {
  final String userId;
  final String phoneNumber;
  const VerifyPhoneSessionView({
    super.key,
    required this.userId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/otp.png'),
          ),
          const SizedBox(height: 20),
          const Text(
            'OTP Verification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text('Enter the OTP sent to the number you entered.'),
          Text(phoneNumber),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PinCodeFields(
              length: 6,
              onComplete: (output) {
                ref.read(authControllerProvider.notifier).verifyPhoneSession(
                      context: context,
                      userId: userId,
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
