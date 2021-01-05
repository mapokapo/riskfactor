import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    titleText: "Please choose an email address and password",
    fields: [
      InputField(
        validator: InputValidationTechnique.email.build(),
        placeholderText: "Email",
        inputType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.go,
        autofocus: true,
      ),
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
  bool _loading = false;
  String _error;

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
                if (_loading) CircularProgressIndicator(),
                if (!_loading)
                  Column(
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
                    ],
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 12.0, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Spacer(),
                Form(
                  key: _formKey,
                  child: AuthForm(
                    step: _steps[_stepNumber],
                    stepNumber: _stepNumber,
                    stepsLength: _steps.length,
                    onTextChanged: (val, fieldNumber) {
                      setState(() {
                        _steps[_stepNumber].fields[fieldNumber].value = val;
                      });
                    },
                    advanceStep: () async {
                      var step1 = _steps[0].fields;
                      var step2 = _steps[1].fields;
                      var step3 = _steps[2].fields;

                      var firstName = step1[0].value, lastName = step1[1].value;
                      var email = step2[0].value, password = step2[1].value;
                      var height = step3[0].value, weight = step3[0].value;

                      final devMode =
                          Provider.of<Config>(context, listen: false).devMode;

                      if (devMode || _formKey.currentState.validate()) {
                        if (_stepNumber == _steps.length - 1) {
                          if (!devMode) {
                            final firebaseAuth = Provider.of<FirebaseAuth>(
                                context,
                                listen: false);
                            final firebaseFirestore =
                                Provider.of<FirebaseFirestore>(context,
                                    listen: false);
                            setState(() {
                              _loading = true;
                            });
                            try {
                              UserCredential userCredential = await firebaseAuth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              DocumentReference ref = firebaseFirestore
                                  .collection('users')
                                  .doc(userCredential.user.uid);
                              await ref.set({
                                "name": firstName + " " + lastName,
                                "email": email,
                                "height": height,
                                "weight": weight,
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.home, (_) => false);
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _error = e.message;
                              });
                            } catch (e) {
                              setState(() {
                                _error = e.toString();
                              });
                            }
                            setState(() {
                              _loading = false;
                            });
                          }
                        } else {
                          Navigator.of(context).pushNamed(Routes.register,
                              arguments: _stepNumber + 1);
                        }
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
