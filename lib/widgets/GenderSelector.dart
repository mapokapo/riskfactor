import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';

class Gender {
  String name;
  String codename;
  IconData icon;

  Gender(this.name, this.codename, this.icon);
}

class GenderSelector extends FormField<int> {
  GenderSelector({
    FormFieldSetter<int> onSaved,
    FormFieldValidator<int> validator,
    int initialValue,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<int> state) {
              final List<Gender> genders = [
                Gender(AppLocalizations.of(state.context).male, "male",
                    MdiIcons.genderMale),
                Gender(AppLocalizations.of(state.context).female, "female",
                    MdiIcons.genderFemale)
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...genders.asMap().entries.map(
                        (entry) {
                          int index = entry.key;
                          Gender gender = entry.value;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == genders.length - 1
                                    ? 0
                                    : KeyboardVisibilityController().isVisible
                                        ? 4
                                        : 8,
                                left: index == 0
                                    ? 0
                                    : KeyboardVisibilityController().isVisible
                                        ? 4
                                        : 8,
                              ),
                              child: Material(
                                elevation: 4.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                color: state.hasError
                                    ? Colors.red.shade700
                                    : genders.indexOf(gender) == state.value
                                        ? Colors.red
                                        : Provider.of<ThemeNotifier>(
                                                    state.context)
                                                .darkTheme
                                            ? Colors.black.withOpacity(0.9)
                                            : Colors.white.withOpacity(0.9),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.grey.shade200,
                                  onTap: () {
                                    state.didChange(
                                        gender.codename == "male" ? 0 : 1);
                                    state.validate();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          gender.name,
                                          style: Theme.of(state.context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: genders
                                                            .indexOf(gender) ==
                                                        state.value
                                                    ? Colors.white
                                                    : Provider.of<ThemeNotifier>(
                                                                state.context)
                                                            .darkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                        ),
                                        Icon(
                                          gender.icon,
                                          color: genders.indexOf(gender) ==
                                                  state.value
                                              ? Colors.white
                                              : Provider.of<ThemeNotifier>(
                                                          state.context)
                                                      .darkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                          size: 32 *
                                              MediaQuery.of(state.context)
                                                  .textScaleFactor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
}
