import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texto_falado_auth/animation/animations.dart';
import 'package:texto_falado_auth/constant.dart';

import '../../controllers/authentication_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    AuthenticationController controller = Get.find();
    return Scaffold(
      key: const Key('signUpScaffold'),
      backgroundColor: Color(0xfffdfdfdf),
      body: Center(
        child: Column(

          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              margin: EdgeInsets.fromLTRB(0, 50, 0, 30),
              width: width,
              child: TopAnime(
                1,
                20,
                curve: Curves.fastOutSlowIn,
                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Meu ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: "Cadastro",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 14,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            key: const Key('signUpEmail'),
                            controller: _emailController,
                            cursorColor: Colors.black,
                            style:
                            TextStyle(color: Colors.black),
                            decoration:
                            kTextFiledInputDecoration
                                .copyWith(
                                labelText:
                                "E-mail"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter email";
                              } else if (!value.contains('@')) {
                                return "Enter valid email address";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: const Key('signUpPassord'),
                            controller: _passwordController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            style:
                            TextStyle(color: Colors.black),
                            decoration:
                            kTextFiledInputDecoration
                                .copyWith(
                                labelText:
                                "Senha"),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter password";
                              } else if (value.length < 6) {
                                return "Password should have at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              key: const Key('signUpSubmit'),
                              onPressed: () {
                                // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
                                FocusScope.of(context).requestFocus(FocusNode());
                                final form = _formKey.currentState;
                                form!.save();
                                if (form.validate()) {
                                  controller
                                      .signup(_emailController.text,
                                      _passwordController.text)
                                      .then((value) {
                                    if (value) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('User ok')));
                                      Get.back();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('User problem')));
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Validation nok'),
                                  ));
                                }
                              },
                              child: const Text("Salvar"),
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000000),
                              fixedSize: const Size(80, 80),
                              shape: const CircleBorder(),
                               ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
