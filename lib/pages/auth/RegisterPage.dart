import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/config.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:riskfactor/widgets/AuthForm.dart';

class RegisterPageArguments {
  final int stepNumber;

  RegisterPageArguments([this.stepNumber]);
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _error;
  List<AuthFormStep> _steps;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _steps = [
      AuthFormStep(
        context,
        titleText: AppLocalizations.of(context).registerFormStep1Title,
        fields: [
          InputField(
            validator: InputValidationTechnique.name(context).build(),
            placeholderText: AppLocalizations.of(context).firstName,
            inputType: TextInputType.name,
            autofocus: true,
          ),
          InputField(
            validator: InputValidationTechnique.name(context).build(),
            placeholderText: AppLocalizations.of(context).lastName,
            inputType: TextInputType.name,
            textInputAction: TextInputAction.go,
          ),
        ],
      ),
      AuthFormStep(
        context,
        titleText: AppLocalizations.of(context).registerFormStep2Title,
        fields: [
          InputField(
            validator: InputValidationTechnique.email(context).build(),
            placeholderText: AppLocalizations.of(context).email,
            inputType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.go,
            autofocus: true,
          ),
          InputField(
            validator: InputValidationTechnique.password(context).build(),
            placeholderText: AppLocalizations.of(context).password,
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
        context,
        titleText: AppLocalizations.of(context).registerFormStep3Title,
        fields: [
          InputField(
            validator: InputValidationTechnique.number(context).build(),
            placeholderText: AppLocalizations.of(context).height,
            inputType: TextInputType.numberWithOptions(decimal: true),
            suffixText: "CM",
            autofocus: true,
            combine: true,
          ),
          InputField(
            validator: InputValidationTechnique.number(context).build(),
            placeholderText: AppLocalizations.of(context).weight,
            inputType: TextInputType.numberWithOptions(decimal: true),
            suffixText: "KG",
            combine: true,
          ),
          InputField(
            validator: InputValidationTechnique.integer(context).build(),
            placeholderText: AppLocalizations.of(context).age,
            inputType: TextInputType.number,
          ),
          InputField(
            validator: InputValidationTechnique.text(context).build(),
            placeholderText: AppLocalizations.of(context).gender,
            genderPicker: true,
          ),
        ],
      ),
      AuthFormStep(
        context,
        titleText: AppLocalizations.of(context).registerFormStep4Title,
        fields: [],
        submitButtonText: AppLocalizations.of(context).finish,
      )
    ];
  }

  Widget polygonBackgroundWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png'),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: Provider.of<ThemeNotifier>(context).darkTheme
                    ? [
                        Colors.grey.withOpacity(0.5),
                        Colors.grey.withOpacity(0.5),
                      ]
                    : [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.9),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RegisterPageArguments _args = ModalRoute.of(context).settings.arguments;
    int stepNumber = _args.stepNumber ?? 0;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              polygonBackgroundWidget(),
              Padding(
                padding: EdgeInsets.only(
                    top: 32.0,
                    bottom:
                        KeyboardVisibilityController().isVisible ? 8.0 : 32.0,
                    left: 16.0,
                    right: 16.0),
                child: Column(
                  children: [
                    if (_loading) CircularProgressIndicator(),
                    if (!_loading)
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context).register,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            _steps[stepNumber].titleText,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: _formKey,
                        child: AuthForm(
                          step: _steps[stepNumber],
                          stepNumber: stepNumber,
                          stepsLength: _steps.length,
                          onInputChanged: (val, fieldNumber) {
                            setState(() {
                              _steps[stepNumber].fields[fieldNumber].value =
                                  val;
                            });
                            debugPrint(
                                _steps[stepNumber].fields[fieldNumber].value);
                          },
                          advanceStep: () async {
                            var step1 = _steps[0].fields;
                            var step2 = _steps[1].fields;
                            var step3 = _steps[2].fields;

                            var firstName = step1[0].value,
                                lastName = step1[1].value;
                            var email = step2[0].value,
                                password = step2[1].value;
                            var height = step3[0].value,
                                weight = step3[1].value,
                                age = step3[2].value,
                                gender = step3[3].value;
                            debugPrint("gender" + step2[0].value.toString());

                            final devMode =
                                Provider.of<Config>(context, listen: false)
                                    .devMode;

                            if (devMode || _formKey.currentState.validate()) {
                              if (stepNumber == _steps.length - 1) {
                                if (!devMode) {
                                  final firebaseAuth =
                                      Provider.of<FirebaseAuth>(context,
                                          listen: false);
                                  final firebaseFirestore =
                                      Provider.of<FirebaseFirestore>(context,
                                          listen: false);
                                  setState(() {
                                    _loading = true;
                                  });
                                  try {
                                    UserCredential userCredential =
                                        await firebaseAuth
                                            .createUserWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                    DocumentReference ref = firebaseFirestore
                                        .collection('users')
                                        .doc(userCredential.user.uid);
                                    await ref.set({
                                      "name": firstName + " " + lastName,
                                      "email": email,
                                      "height": height,
                                      "weight": weight,
                                      "age": age,
                                      "gender": gender,
                                    });
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
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
                                    arguments:
                                        RegisterPageArguments(stepNumber + 1));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
