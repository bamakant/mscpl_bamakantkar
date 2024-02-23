import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mscpl_bamakantkar/screens/otp/otp_notifier.dart';
import 'package:provider/provider.dart';

class OTP extends StatefulWidget {
  final String mobileNumber;

  const OTP(this.mobileNumber, {super.key});

  @override
  State<OTP> createState() => _OtpState();
}

class _OtpState extends State<OTP> {
  late OtpNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = OtpNotifier(context, widget.mobileNumber);
    _notifier.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _notifier,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: InkWell(
                  onTap: _notifier.onWillPop,
                  child: SvgPicture.asset(
                    'assets/images/back.svg',
                    height: 24,
                    width: 24,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
              _headerLayout(),
              const SizedBox(height: 8),
              _layoutOtp(widget.mobileNumber.length),
            ],
          ),
        ),
        bottomSheet: _bottomSheet(),
      ),
    );
  }

  Widget _layoutOtp(int length) {
    return Consumer<OtpNotifier>(builder: (context, notifier, child) {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _notifier.invalidOTP == null
              ? Colors.white
              : _notifier.invalidOTP!
                  ? Colors.red
                  : Colors.green,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _otpFields(_notifier.otpLength),
            const SizedBox(height: 24),
            Consumer<OtpNotifier>(
              builder: (context, notifier, child) =>
                  _notifier.invalidOTP == null &&
                          !_notifier.isResendButtonEnabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verification code expires in ${_notifier.formattedTime(_notifier.startTime)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff69788C),
                              ),
                            ),
                          ],
                        )
                      : _notifier.invalidOTP != null && _notifier.invalidOTP!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/cross.svg',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.scaleDown,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Invalid OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/tick.svg',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.scaleDown,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    });
  }

  Widget _otpTextField(
    bool autoFocus,
    FocusNode focusNode,
    TextEditingController controller,
    int index,
  ) {
    return Container(
      width: 45.0,
      height: 56.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      alignment: Alignment.center,
      child: TextFormField(
        expands: false,
        maxLines: 1,
        minLines: 1,
        showCursor: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) => _notifier.onTextChange(value, index),
        controller: controller,
        style: const TextStyle(fontSize: 24, color: Color(0xff0D1D33)),
        focusNode: focusNode,
        autofocus: autoFocus,
        decoration: const InputDecoration(
          border: InputBorder.none,
          fillColor: null,
          filled: false,
          counterText: '',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Consumer<OtpNotifier>(
      builder: (context, value, child) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customButton(
                _notifier.onClickResend,
                'Resend Code',
                enabled: _notifier.isResendButtonEnabled,
              ),
              customButton(_notifier.onClickChangeNumber, 'Change Number'),
            ],
          ),
        );
      },
    );
  }

  Widget customButton(VoidCallback onClick, String title, {bool? enabled}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            color: enabled == null
                ? const Color(0xFFFFFFFF)
                : enabled
                    ? const Color(0xff111827)
                    : const Color(0xFFB3B9C4),
            borderRadius: BorderRadius.circular(16),
          ),
          height: 56,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: enabled == null ? const Color(0xff0D1D33) : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerLayout() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify your phone",
            style: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Color(0xff101828),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Enter the verification code sent to",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              color: Color(0xff667085),
            ),
          ),
          Text(
            _notifier.getMaskedMobileNumber(widget.mobileNumber),
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Color(0xff101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpFields(int otpLength) {
    return Consumer<OtpNotifier>(
      builder: (context, value, child) {
        return SizedBox(
          height: 60,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _notifier.otpLength,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _otpTextField(true, _notifier.otpFieldFocusNode[index],
                  _notifier.otpFieldController[index], index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 10);
            },
          ),
        );
      },
    );
  }
}
