import 'package:attendence/screens/auth_ui.dart/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

// import 'package:attendence/screens/login.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/auth_controller/signup_controller.dart';
import '../../widgets/button.dart';
// import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              CustomTextField(
                labelText: 'Name',
                hintText: 'Enter your name',
                controller: signupController.name,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: signupController.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: signupController.password,
                prefixIcon: const Icon(Icons.password),
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              getx.Obx(() {
                return CustomButton(
                  text: signupController.isLoading.value
                      ? "Signing Up..."
                      : "Sign Up",
                  onPressed: signupController.isLoading.value
                      ? () {}
                      : () {
                          signupController.onSignUp();
                        },
                );
              }),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
