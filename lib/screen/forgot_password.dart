import 'package:flutter/material.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeUtils.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  focusNode: _emailFocus,
                  controller: _email,
                  validator: (_) => _?.isEmpty == true
                      ? 'Email is required'
                      : _!.isEmail
                          ? null
                          : 'Invalid email',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onEditingComplete: () => _emailFocus.unfocus(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 10),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_globalKey.currentState?.validate() == true) {
                              _emailFocus.unfocus();
                              try {
                                firebaseAuth
                                    .sendPasswordResetEmail(email: _email.text)
                                    .then((value) {
                                  _email.clear();
                                  _globalKey.currentState?.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Success , check your email'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                });
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(
                                              'Something wrong , Please try again! $e'),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK')),
                                          ],
                                        ));
                              }
                            }
                          },
                          child: const Text(
                            'Search',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
