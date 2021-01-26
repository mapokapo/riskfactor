import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:riskfactor/widgets/AuthForm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _body;
  String _subject;

  void _saveForm(BuildContext context) {
    Form.of(context).save();
    if (Form.of(context).validate() && _body != null && _subject != null) {
      FocusScope.of(context).unfocus();
      final String userEmail =
          Provider.of<FirebaseAuth>(context, listen: false).currentUser.email;
      final Email email = Email(
        body: _body,
        subject: _subject,
        recipients: ['leopetrovic11@gmail.com'],
        isHTML: false,
      );
      final snackbar = SnackBar(
        content: Text(AppLocalizations.of(context).emailSent),
        action: SnackBarAction(
          label: "╳",
          textColor:
              Provider.of<ThemeNotifier>(context, listen: false).darkTheme
                  ? Colors.black
                  : Colors.white,
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      );

      FlutterEmailSender.send(email).then((value) {
        Scaffold.of(context).showSnackBar(snackbar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).help),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).sendMail,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          validator:
                              InputValidationTechnique.text(context).build(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context).subject,
                            filled: true,
                            fillColor:
                                Provider.of<ThemeNotifier>(context).darkTheme
                                    ? Colors.black.withOpacity(0.9)
                                    : Colors.white.withOpacity(0.9),
                            errorStyle:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Provider.of<ThemeNotifier>(context)
                                              .darkTheme
                                          ? Colors.red.shade100
                                          : Colors.red.shade900,
                                    ),
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.text,
                          keyboardAppearance: Theme.of(context).brightness,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          onSaved: (val) {
                            setState(() {
                              _subject = val;
                            });
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          maxLines: 10,
                          validator:
                              InputValidationTechnique.text(context).build(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context).body,
                            filled: true,
                            fillColor:
                                Provider.of<ThemeNotifier>(context).darkTheme
                                    ? Colors.black.withOpacity(0.9)
                                    : Colors.white.withOpacity(0.9),
                            errorStyle:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Provider.of<ThemeNotifier>(context)
                                              .darkTheme
                                          ? Colors.red.shade100
                                          : Colors.red.shade900,
                                    ),
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.text,
                          keyboardAppearance: Theme.of(context).brightness,
                          textInputAction: TextInputAction.go,
                          textCapitalization: TextCapitalization.none,
                          onSaved: (val) {
                            setState(() {
                              _body = val;
                            });
                          },
                          onEditingComplete: () {
                            _saveForm(context);
                          },
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) => ElevatedButton(
                          onPressed: () {
                            _saveForm(context);
                          },
                          child: Text(
                            AppLocalizations.of(context).finish,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
