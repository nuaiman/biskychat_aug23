import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_input/phone_input_package.dart';

class PhoneInputView extends ConsumerStatefulWidget {
  const PhoneInputView({super.key});

  @override
  ConsumerState<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends ConsumerState<PhoneInputView> {
  final PhoneController _phoneController = PhoneController(
    const PhoneNumber(isoCode: IsoCode.BD, nsn: ''),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhoneInput(
            controller: _phoneController,
            onChanged: (value) {
              setState(() {
                _phoneController.value = value;
              });
            },
            showArrow: false,
            shouldFormat: true,
            flagSize: 30,
            validator: PhoneValidator.compose(
              [
                PhoneValidator.required(),
                PhoneValidator.valid(),
              ],
            ),
            flagShape: BoxShape.circle,
            showFlagInInput: true,
            decoration: const InputDecoration(
              labelText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(4),
            ),
            countrySelectorNavigator:
                const CountrySelectorNavigator.bottomSheet(),
          ),
          // -------------------------------------------------------------------
          ElevatedButton(
            onPressed: _phoneController.value!.isValid()
                ? () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => PhoneOtpView(
                    //       phoneNumber: _phoneController.value!.international,
                    //     ),
                    //   ),
                    // );

                    ref.read(authControllerProvider.notifier).createSession(
                          context: context,
                          phoneNumber: _phoneController.value!.international,
                        );
                  }
                : () {
                    showSnackbar(context, 'Enter a valid phone number');
                  },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
