import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:riskfactor/widgets/AuthButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riskfactor/widgets/GenderSelector.dart';

class InputValidationTechnique {
  static ValidationBuilder email(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField)
      .email(AppLocalizations.of(context).validationInvalidEmail);
  static ValidationBuilder password(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField)
      .minLength(
          8, AppLocalizations.of(context).validationPasswordMin8Characters)
      .regExp(RegExp(r'[a-z]+'),
          AppLocalizations.of(context).validationPasswordLetter)
      .regExp(RegExp(r'[A-Z]+'),
          AppLocalizations.of(context).validationPasswordCapitalLetter)
      .regExp(RegExp(r'[0-9]+'),
          AppLocalizations.of(context).validationPasswordNumber);
  static ValidationBuilder name(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField)
      .minLength(2, AppLocalizations.of(context).validationNameMin2Characters)
      .maxLength(
          256, AppLocalizations.of(context).validationNameMax256Characters)
      .regExp(RegExp(r'[a-zA-Z]+'),
          AppLocalizations.of(context).validationNameSymbols);
  static ValidationBuilder number(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField)
      .regExp(RegExp(r'^\d+(\.\d+)?$'),
          AppLocalizations.of(context).validationNotANumber);
  static ValidationBuilder integer(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField)
      .regExp(RegExp(r'^\d+?$'),
          AppLocalizations.of(context).validationNotAnInteger);
  static ValidationBuilder text(BuildContext context) => ValidationBuilder()
      .required(AppLocalizations.of(context).validationRequiredField)
      .minLength(1, AppLocalizations.of(context).validationRequiredField);
}

class InputField {
  final String placeholderText;
  final String suffixText;
  final TextInputType inputType;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool autofocus;
  final FormFieldValidator<String> validator;
  final bool genderPicker;
  final bool combine;
  String value;

  InputField({
    this.placeholderText,
    this.inputType,
    this.suffixText = "",
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
    this.validator,
    this.genderPicker = false,
    this.combine = false,
    this.value,
  });
}

class AuthFormStep {
  final String titleText;
  final List<InputField> fields;
  String submitButtonText;

  AuthFormStep(BuildContext context,
      {this.titleText, this.fields, String submitButtonText}) {
    this.submitButtonText = submitButtonText != null
        ? submitButtonText
        : AppLocalizations.of(context).next;
  }
}

class AuthForm extends StatelessWidget {
  final AuthFormStep step;
  final int stepNumber;
  final int stepsLength;
  final Function advanceStep;
  final bool stepped;
  final void Function(String, int) onInputChanged;
  AuthForm({
    this.step,
    this.stepNumber,
    this.stepsLength,
    this.advanceStep,
    this.stepped = true,
    this.onInputChanged,
  });

  Widget getFormField(BuildContext context, InputField field, int verticalIndex,
      int horizontalIndex, int maxIndex) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalIndex == 0
              ? 0
              : KeyboardVisibilityController().isVisible
                  ? 4
                  : 8,
          right: horizontalIndex == maxIndex
              ? 0
              : KeyboardVisibilityController().isVisible
                  ? 4
                  : 8,
        ),
        child: field.genderPicker
            ? GenderSelector(
                onChanged: (gender) {
                  onInputChanged(
                      gender.codename, verticalIndex + horizontalIndex);
                },
              )
            : TextFormField(
                validator: field.validator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: field.placeholderText,
                  suffixText: field.suffixText,
                  filled: true,
                  fillColor: Provider.of<ThemeNotifier>(context).darkTheme
                      ? Colors.black.withOpacity(0.9)
                      : Colors.white.withOpacity(0.9),
                  errorStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Provider.of<ThemeNotifier>(context).darkTheme
                            ? Colors.red.shade100
                            : Colors.red.shade900,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyText2,
                keyboardType: field.inputType,
                obscureText: field.obscureText,
                enableSuggestions: field.enableSuggestions,
                autocorrect: field.autocorrect,
                autofocus: verticalIndex + horizontalIndex == 0 ? true : false,
                keyboardAppearance: Theme.of(context).brightness,
                textInputAction: field.textInputAction,
                textCapitalization: field.textCapitalization,
                onChanged: (val) =>
                    onInputChanged(val, verticalIndex + horizontalIndex),
                onEditingComplete: () {
                  if (verticalIndex + horizontalIndex ==
                      step.fields.length - 1) {
                    FocusScope.of(context).unfocus();
                    advanceStep();
                  } else {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
      ),
    );
  }

  List<List<InputField>> getCombinedFields(List<InputField> arr) {
    List<List<InputField>> resultArr = [];
    List<InputField> combineArr = [];
    bool flag = false;

    for (int i = 0; i < arr.length; i++) {
      if (arr[i].combine) {
        flag = true;
        combineArr.add(arr[i]);
      } else if (flag) {
        flag = false;
        resultArr.add(combineArr);
        combineArr = [];
        resultArr.add([arr[i]]);
      } else {
        resultArr.add([arr[i]]);
      }
    }

    if (combineArr.length != 0) resultArr.add(combineArr);

    return resultArr;
  }

  List<Widget> getFormWidget(BuildContext context, AuthFormStep _step) {
    final List<List<InputField>> combinedTextFields =
        getCombinedFields(_step.fields);
    return combinedTextFields.asMap().entries.map((entry) {
      int verticalIndex = entry.key;
      List<InputField> inputFields = entry.value;
      return Padding(
        padding: EdgeInsets.only(
          top: KeyboardVisibilityController().isVisible ? 4 : 8,
          bottom: verticalIndex == combinedTextFields.length - 1
              ? 8
              : KeyboardVisibilityController().isVisible
                  ? 4
                  : 8,
        ),
        child: Row(
          children: [
            ...inputFields.asMap().entries.map(
              (entry) {
                int horizontalIndex = entry.key;
                InputField field = entry.value;
                return getFormField(context, field, verticalIndex,
                    horizontalIndex, inputFields.length - 1);
              },
            ).toList(),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...getFormWidget(context, this.step),
        KeyboardVisibilityBuilder(
          builder: (context, keyboardOpen) {
            return Padding(
              padding: EdgeInsets.only(
                  top: keyboardOpen ? 0.0 : 16.0,
                  bottom: keyboardOpen ? 0.0 : 16.0,
                  left: 64.0,
                  right: 64.0),
              child: AuthButton(
                rounded: false,
                title: step.submitButtonText,
                onClick: () {
                  advanceStep();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
