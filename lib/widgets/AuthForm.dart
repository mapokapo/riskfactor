import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:form_validator/form_validator.dart';
import 'package:riskfactor/widgets/AuthButton.dart';

class InputValidationTechnique {
  static final email = ValidationBuilder()
      .required("This field is required")
      .email("Not a valid email address");
  static final password = ValidationBuilder()
      .required("This field is required")
      .minLength(8, "Password must be at least 8 characters")
      .regExp(RegExp(r'[A-Z]+'), "Password must have a capital letter")
      .regExp(RegExp(r'[a-z]+'), "Password must have a letter")
      .regExp(RegExp(r'[0-9]+'), "Password must have a number");
  static final name = ValidationBuilder()
      .required("This field is required")
      .minLength(2, "Name must be at least 2 characters")
      .maxLength(256, "Name must be at most 256 characters")
      .regExp(RegExp(r'[a-zA-Z]+'), "Name mustn't contain symbols");
  static final number = ValidationBuilder()
      .required("This field is required")
      .regExp(RegExp(r'^\d+(\.\d+)?$'), "You must input a number");
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

  const InputField({
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
  });
}

class AuthFormStep {
  final String titleText;
  final List<InputField> fields;
  final String submitButtonText;

  const AuthFormStep(
      {this.titleText, this.fields, this.submitButtonText = "Next"});
}

class AuthForm extends StatelessWidget {
  final AuthFormStep step;
  final int stepNumber;
  final int stepsLength;
  final Function advanceStep;
  final bool stepped;
  AuthForm({
    this.step,
    this.stepNumber,
    this.stepsLength,
    this.advanceStep,
    this.stepped = true,
  });

  List<Widget> getFormWidget(BuildContext context, AuthFormStep _step) {
    return _step.fields.asMap().entries.map((entry) {
      int i = entry.key;
      InputField field = entry.value;
      return Padding(
        padding: EdgeInsets.only(
            top: 8,
            bottom: i == _step.fields.length - 1
                ? KeyboardVisibilityController().isVisible
                    ? 8
                    : 32
                : 8),
        child: TextFormField(
          validator: field.validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: field.placeholderText,
            suffixText: field.suffixText,
          ),
          keyboardType: field.inputType,
          obscureText: field.obscureText,
          enableSuggestions: field.enableSuggestions,
          autocorrect: field.autocorrect,
          autofocus: i == 0 ? true : false,
          keyboardAppearance: Theme.of(context).brightness,
          textInputAction: field.textInputAction,
          textCapitalization: field.textCapitalization,
          onEditingComplete: () {
            if (i == step.fields.length - 1) {
              FocusScope.of(context).unfocus();
              advanceStep();
            } else {
              FocusScope.of(context).nextFocus();
            }
          },
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
                  top: keyboardOpen ? 16.0 : 0.0,
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
