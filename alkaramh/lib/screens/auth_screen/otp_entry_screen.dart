import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose controllers and focus nodes to avoid memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleInputChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _controllers.length - 1) {
        // Move to the next field
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // Unfocus the last field
        _focusNodes[index].unfocus();
      }
    } else if (index > 0) {
      // Move back to the previous field if the value is cleared
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green
                      .withOpacity(0.1), // Light green background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.green, // Green arrow color
                    ),
                    onPressed: () {
                      // Handle back navigation
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Please check your Email or Phone",
                style: MyTextTheme.headline
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "We have sent the code to +91XXXXXX3344",
                style: MyTextTheme.body
                    .copyWith(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: MyTextTheme.body.copyWith(fontSize: 20),
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "", // Hides the character counter
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                            const  BorderSide(color: Colors.orange, width: 2),
                        ),
                      ),
                      onChanged: (value) => _handleInputChange(value, index),
                    ),
                  );
                }),
              ),
             const SizedBox(height: 20),
              Center(
                child: Text(
                  textAlign: TextAlign.end,
                  "Send code again  00:58",
                  style: MyTextTheme.headline.copyWith(color: Colors.grey),
                ),
              ),
            const  SizedBox(height: 35),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect the OTP from all fields
                    String otp =
                        _controllers.map((controller) => controller.text).join();
                    print("Entered OTP: $otp");
                    // Add your verify logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize:const  Size(385, 50),
                  ),
                  child: Text(
                    "Verify",
                    style: MyTextTheme.body.copyWith(fontSize: 20 , color: Colors.white , fontWeight: FontWeight.w500),
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
