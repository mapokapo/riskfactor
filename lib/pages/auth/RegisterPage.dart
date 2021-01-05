import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/config.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/widgets/AuthForm.dart';

final List<AuthFormStep> _steps = [
  AuthFormStep(
    titleText: "Welcome to RiskFactor!\nPlease input your full name below",
    fields: [
      InputField(
        validator: InputValidationTechnique.name.build(),
        placeholderText: "First Name",
        inputType: TextInputType.name,
        autofocus: true,
      ),
      InputField(
        validator: InputValidationTechnique.name.build(),
        placeholderText: "Last Name",
        inputType: TextInputType.name,
        textInputAction: TextInputAction.go,
      ),
    ],
  ),
  AuthFormStep(
    titleText: "Please input your email address below",
    fields: [
      InputField(
        validator: InputValidationTechnique.email.build(),
        placeholderText: "Email",
        inputType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.go,
        autofocus: true,
      ),
    ],
  ),
  AuthFormStep(
    titleText: "Pick a strong password",
    fields: [
      InputField(
        validator: InputValidationTechnique.password.build(),
        placeholderText: "Password",
        inputType: TextInputType.text,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        textCapitalization: TextCapitalization.none,
        autofocus: true,
      ),
      InputField(
        validator: InputValidationTechnique.password.build(),
        placeholderText: "Repeat Password",
        inputType: TextInputType.text,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.go,
      ),
    ],
  ),
  AuthFormStep(
    titleText: "We need some basic information about you",
    fields: [
      InputField(
        validator: InputValidationTechnique.number.build(),
        placeholderText: "Height",
        inputType: TextInputType.numberWithOptions(decimal: true),
        suffixText: "CM",
        autofocus: true,
      ),
      InputField(
        validator: InputValidationTechnique.number.build(),
        placeholderText: "Weight",
        inputType: TextInputType.numberWithOptions(decimal: true),
        suffixText: "KG",
        textInputAction: TextInputAction.go,
      ),
    ],
  ),
  AuthFormStep(
    titleText: "Finished!\nYou can now proceed to RiskFactor",
    fields: [],
    submitButtonText: "Finish",
  )
];

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int _stepNumber = ModalRoute.of(context).settings.arguments ?? 0;
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
                  "Register",
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
                        if (_stepNumber == _steps.length - 1)
                          Navigator.of(context).pushNamed(Routes.home);
                        else
                          Navigator.of(context).pushNamed(Routes.register,
                              arguments: _stepNumber + 1);
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
