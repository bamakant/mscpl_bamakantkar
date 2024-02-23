import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mscpl_bamakantkar/screens/login/login_notifier.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = LoginNotifier(context);
    _notifier.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _notifier,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16, 32, 32),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/back.svg',
                  height: 24,
                  width: 24,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Enter your mobile number",
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff101828),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "We need to verify your number",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Color(0xff667085),
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: const TextSpan(
                      text: 'Mobile number',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff101828),
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                      ]),
                ),
                const SizedBox(height: 16),
                Consumer<LoginNotifier>(builder: (context, value, child) {
                  return TextFormField(
                    autofocus: false,
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    onChanged: _notifier.onMobileNumberChange,
                    controller: _notifier.mobileNumberController,
                    focusNode: _notifier.mobileNumberFocusNode,
                    style: const TextStyle(
                      color: Color(0xff000000),
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffD0D5DD), width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      hintText: 'Enter mobile no',
                      hintStyle: TextStyle(
                        color: Color(0xff667085),
                        fontSize: 14,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 64),
                Consumer<LoginNotifier>(
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: _notifier.onClickGetOtp,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _notifier.enableGetOtpButton
                              ? const Color(0xff111827)
                              : const Color(0xFFB3B9C4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: 56,
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: const Text(
                          'Get OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Consumer<LoginNotifier>(
                builder: (context, value, child) {
                  return InkWell(
                    onTap: _notifier.onClickDeclaration,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              color: _notifier.isDeclarationChecked
                                  ? Colors.blueAccent
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Allow fydaa to send financial knowledge and critical alerts on your WhatsApp.',
                  style: TextStyle(
                    color: Color(0xff667085),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
