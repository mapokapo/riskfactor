import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/config.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/widgets/AuthForm.dart';

final List<AuthFormStep> _steps = [
  AuthFormStep(
    titleText: "Please input your email address and password below",
    fields: [
      InputField(
        validator: InputValidationTechnique.email.build(),
        placeholderText: "Email",
        inputType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
      ),
      InputField(
        validator: InputValidationTechnique.password.build(),
        placeholderText: "Password",
        inputType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        obscureText: true,
        enableSuggestions: false,
        textInputAction: TextInputAction.go,
      ),
    ],
  ),
];

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _stepNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Text(
                  "Sign In",
                  style: GoogleFonts.sourceSansPro(fontSize: 64),
                ),
                Text(
                  _steps[_stepNumber].titleText,
                  style: GoogleFonts.sourceSansPro(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Form(
                  key: _formKey,
                  child: AuthForm(
                    step: _steps[_stepNumber],
                    stepNumber: _stepNumber,
                    stepsLength: _steps.length,
                    advanceStep: () {
                      final devMode =
                          Provider.of<Config>(context, listen: false).devMode;
                      if (devMode || _formKey.currentState.validate()) {
                        Navigator.of(context).pushNamed(Routes.home);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
