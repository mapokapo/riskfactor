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

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _stepNumber = 0;
  List<AuthFormStep> _steps;
  bool _loading = false;
  String _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _steps = [
      AuthFormStep(
        context,
        titleText: AppLocalizations.of(context).signInFormTitle,
        fields: [
          InputField(
            validator: InputValidationTechnique.email(context).build(),
            placeholderText: AppLocalizations.of(context).email,
            inputType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            value: "",
          ),
          InputField(
            validator: InputValidationTechnique.text(context).build(),
            placeholderText: AppLocalizations.of(context).password,
            inputType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            textInputAction: TextInputAction.go,
            value: "",
          ),
        ],
      ),
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
                            AppLocalizations.of(context).signIn,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            _steps[_stepNumber].titleText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: _formKey,
                        child: AuthForm(
                          step: _steps[_stepNumber],
                          stepNumber: _stepNumber,
                          stepsLength: _steps.length,
                          saveInput: (val, fieldNumber) {
                            setState(() {
                              _steps[_stepNumber].fields[fieldNumber].value =
                                  val;
                            });
                          },
                          advanceStep: () async {
                            var values = _steps[0].fields;
                            var email = values[0].value,
                                password = values[1].value;

                            final devMode =
                                Provider.of<Config>(context, listen: false)
                                    .devMode;

                            if (devMode || _formKey.currentState.validate()) {
                              if (!devMode) {
                                final firebaseAuth = Provider.of<FirebaseAuth>(
                                    context,
                                    listen: false);
                                setState(() {
                                  _loading = true;
                                });
                                try {
                                  await firebaseAuth.signInWithEmailAndPassword(
                                      email: email, password: password);
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
