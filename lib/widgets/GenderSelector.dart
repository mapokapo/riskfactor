import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Gender {
  String name;
  String codename;
  IconData icon;
  bool selected;

  Gender(this.name, this.codename, this.icon, this.selected);
}

class GenderSelector extends StatefulWidget {
  final Function(Gender) onChanged;

  GenderSelector({this.onChanged});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  final List<Gender> genders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    genders.add(Gender(
        AppLocalizations.of(context).male, "male", MdiIcons.genderMale, false));
    genders.add(Gender(AppLocalizations.of(context).female, "female",
        MdiIcons.genderFemale, false));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: gender.selected ? Colors.red : Colors.white,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey.shade200,
                    onTap: () {
                      setState(() {
                        genders.forEach((gender) {
                          gender.selected = false;
                        });
                        gender.selected = true;
                      });
                      widget.onChanged(gender);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            gender.name,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: gender.selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                          Icon(
                            gender.icon,
                            color:
                                gender.selected ? Colors.white : Colors.black,
                            size: 32 * MediaQuery.of(context).textScaleFactor,
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
    );
  }
}
