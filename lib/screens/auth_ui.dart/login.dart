import 'package:attendence/controller/auth_controller/login_controller.dart';
import 'package:attendence/screens/auth_ui.dart/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../user_dashboard/user_panel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final LoginController signinController = Get.put(LoginController());
  final LoginController loginController = Get.put(LoginController());

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    loginController.email.clear();
    loginController.password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            controller: signinController.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email),
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: 'Password',
            hintText: 'Enter your password',
            controller: signinController.password,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock),
            obscureText: _obscureText,
            suffixIcon: IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            return CustomButton(
              text: loginController.isLoading.value ? " Login..." : "Login",
              onPressed: loginController.isLoading.value
                  ? () {}
                  : () {
                      loginController.onLogin(loginController.email.text,
                          loginController.password.text);
                      if (signinController.auth.currentUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserPanel()));
                      }
                    },
            );
          }),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an acoount?"),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text(
                  " Register",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
