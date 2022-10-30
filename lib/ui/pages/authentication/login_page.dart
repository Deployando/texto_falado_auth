import 'package:flutter/material.dart';
import 'package:texto_falado_auth/animation/animations.dart';
import 'package:texto_falado_auth/constant.dart';

import 'package:get/get.dart';
import '../../controllers/authentication_controller.dart';
import 'signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthenticationController controller = Get.find<AuthenticationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('loginScaffold'),
      backgroundColor: Color(0xfffdfdfdf),
      body: Center(
        child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Top Text
                        Container(
                          child: TopAnime(
                            1,
                            20,
                            curve: Curves.fastOutSlowIn,
                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    key: const Key('loginCreateUser'),
                                    onPressed: () {
                                      Get.to(() => const SignUpPage());
                                    },
                                    child: const Text("Cadastrar",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),)),
                                const SizedBox(
                                  height: 40,
                                ),
                                Text("Bem-vindo ao,",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300,
                                    )),
                                Text(
                                  "Texto Falado",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        key: const Key('loginEmail'),
                                        controller: _emailController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            color: Colors.black),
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
                                        key: const Key('loginPassord'),
                                        controller: _passwordController,
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.black,
                                        style:
                                        TextStyle(color: Colors.black),
                                        obscureText: true,
                                        decoration:
                                        kTextFiledInputDecoration
                                            .copyWith(
                                            labelText:
                                            "Senha"),
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
                                        height: 10,
                                      ),

                                      ElevatedButton(
                                        key: const Key('loginSubmit'),
                                        onPressed: () async {
                                          // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          final form = _formKey.currentState;
                                          form!.save();
                                          if (form.validate()) {
                                            var value = await controller.login(
                                                _emailController.text,
                                                _passwordController.text);
                                            if (value) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('User ok')));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                      content: Text('User problem')));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text('Validation nok'),
                                            ));
                                          }
                                        },
                                        child: const Text(
                                          'Entrar',
                                          style: TextStyle(fontSize: 16),
                                        ),
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
                ],
              ),
      ),
    );
  }

}