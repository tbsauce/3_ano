import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AutenticateNumber extends StatefulWidget {
  const AutenticateNumber({super.key});

  @override
  State<AutenticateNumber> createState() => _AutenticateNumber();
}

class _AutenticateNumber extends State<AutenticateNumber> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              activeFillColor: Colors.blue,
              selectedFillColor: Colors.blue,
              inactiveFillColor: Colors.grey,
              fieldHeight: 50,
              fieldWidth: 40,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Handle OTP value changes
            },
            controller: otpController,
          ),
        ),
      ),
    );
  }
}
