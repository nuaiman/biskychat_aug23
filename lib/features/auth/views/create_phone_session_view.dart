import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_input/phone_input_package.dart';

import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';

class CreatePhoneSessionView extends ConsumerStatefulWidget {
  const CreatePhoneSessionView({super.key});

  @override
  ConsumerState<CreatePhoneSessionView> createState() =>
      _CreatePhoneSessionViewState();
}

class _CreatePhoneSessionViewState
    extends ConsumerState<CreatePhoneSessionView> {
  final PhoneController _phoneController = PhoneController(
    const PhoneNumber(isoCode: IsoCode.BD, nsn: ''),
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Phone Verification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text('An OTP will be sent to the number you enter.'),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PhoneInput(
              controller: _phoneController,
              showArrow: true,
              shouldFormat: true,
              showFlagInInput: true,
              flagShape: BoxShape.circle,
              validator: PhoneValidator.compose([
                PhoneValidator.required(),
                PhoneValidator.valid(),
              ]),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(),
              ),
              countrySelectorNavigator:
                  const CountrySelectorNavigator.draggableBottomSheet(),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size.fromHeight(45),
              ),
              onPressed: () {
                if (!_phoneController.value!.isValid()) {
                  showSnackbar(context,
                      'Please enter a valid phone number to continue.');
                  return;
                }
                ref.read(authControllerProvider.notifier).createPhoneSession(
                    context: context,
                    phoneNumber: _phoneController.value!.international);
              },
              child: const Text(
                'Send',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
