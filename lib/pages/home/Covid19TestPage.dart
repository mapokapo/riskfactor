import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/covid19_result_calculator.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/pages/home/Covid19TestResultsPage.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';
import 'package:riskfactor/widgets/AuthButton.dart';

enum TestQuestionType { RADIO, CHECKBOX, DATE }

class TestQuestionCheckbox {
  bool checked;
  final String label;
  final String value;

  TestQuestionCheckbox({
    this.checked = false,
    this.label,
    this.value,
  });
}

class TestQuestionRadio {
  int checkedIndex;
  final List<String> values;

  TestQuestionRadio({
    this.checkedIndex,
    this.values,
  });
}

class TestQuestion {
  final String title;
  final TestQuestionType type;
  final List<TestQuestionCheckbox> checkboxData;
  final TestQuestionRadio radioData;
  DateTime dateData;

  TestQuestion({
    this.title,
    this.type,
    this.checkboxData,
    this.radioData,
    this.dateData,
  });
}

class Covid19TestPage extends StatefulWidget {
  @override
  _Covid19TestPageState createState() => _Covid19TestPageState();
}

class _Covid19TestPageState extends State<Covid19TestPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TestQuestion> questions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    questions = [
      TestQuestion(
        title: AppLocalizations.of(context).covid19TestQuestion1Title,
        type: TestQuestionType.RADIO,
        radioData: TestQuestionRadio(values: [
          AppLocalizations.of(context).yes,
          AppLocalizations.of(context).no
        ]),
      ),
      TestQuestion(
        title: AppLocalizations.of(context).covid19TestQuestion2Title,
        type: TestQuestionType.DATE,
      ),
      TestQuestion(
        title: AppLocalizations.of(context).covid19TestQuestion3Title,
        type: TestQuestionType.RADIO,
        radioData: TestQuestionRadio(values: [
          AppLocalizations.of(context).yes,
          AppLocalizations.of(context).no
        ]),
      ),
      TestQuestion(
        title: AppLocalizations.of(context).covid19TestQuestion4Title,
        type: TestQuestionType.DATE,
      ),
      TestQuestion(
          title: AppLocalizations.of(context).covid19TestQuestion5Title,
          type: TestQuestionType.CHECKBOX,
          checkboxData: [
            TestQuestionCheckbox(
              label: AppLocalizations.of(context).had_fever_in_past_24h,
              value: "had_fever_in_past_24h",
            ),
            TestQuestionCheckbox(
              label: AppLocalizations.of(context).had_fever_in_past_4d,
              value: "had_fever_in_past_4d",
            ),
            TestQuestionCheckbox(
              label: AppLocalizations.of(context).chills,
              value: "chills",
            ),
            TestQuestionCheckbox(
              label: AppLocalizations.of(context).lost_taste,
              value: "lost_taste",
            ),
            TestQuestionCheckbox(
              label: AppLocalizations.of(context).body_aches,
              value: "body_aches",
            ),
          ]),
    ];
  }

  Widget _covid19RadioWidget(BuildContext context, TestQuestion question) {
    final TestQuestionRadio data = question.radioData;
    final int checkedIndex = data.checkedIndex;
    final List<String> values = data.values;
    return Row(
      children: [
        ...values.asMap().entries.map((e) {
          var index = e.key;
          var value = e.value;
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  groupValue:
                      checkedIndex != null ? values[checkedIndex] : null,
                  value: value,
                  onChanged: (String newVal) {
                    setState(() {
                      data.checkedIndex = index;
                    });
                  },
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _covid19CheckboxWidget(BuildContext context, TestQuestion question) {
    final List<TestQuestionCheckbox> data = question.checkboxData;
    return Column(
      children: [
        ...data.map((e) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      e.label,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Checkbox(
                    value: e.checked,
                    onChanged: (bool value) {
                      setState(() {
                        e.checked = !e.checked;
                      });
                    },
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _covid19DateWidget(BuildContext context, TestQuestion question) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: InkWell(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 30)),
            lastDate: DateTime.now(),
          ).then((value) {
            setState(() {
              question.dateData = value;
            });
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            question.dateData != null
                ? DateFormat("dd.MM.yyyy.").format(question.dateData)
                : AppLocalizations.of(context).chooseDate,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }

  Widget _getCovid19TestQuestionType(
      BuildContext context, TestQuestion question) {
    if (question.type == TestQuestionType.RADIO) {
      return _covid19RadioWidget(context, question);
    } else if (question.type == TestQuestionType.CHECKBOX) {
      return _covid19CheckboxWidget(context, question);
    } else if (question.type == TestQuestionType.DATE) {
      return _covid19DateWidget(context, question);
    } else {
      return Text("Error");
    }
  }

  Widget _covid19TestQuestion(
      BuildContext context, TestQuestion question, bool darken) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Provider.of<ThemeNotifier>(context).darkTheme
            ? (darken ? Colors.grey.shade900 : Colors.grey.shade700)
            : (darken ? Colors.grey.shade200 : Colors.white),
        elevation: 4.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                question.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getCovid19TestQuestionType(context, question),
            ),
          ],
        ),
      ),
    );
  }

  bool _answersValid() {
    final answer1 = (questions[0].radioData.checkedIndex);
    final answer2 = (questions[1].dateData);
    final answer3 = (questions[2].radioData.checkedIndex);
    final answer4 = (questions[3].dateData);
    var valid = true;

    if (answer1 == null || answer3 == null) return false;

    if (mapIndexToYesNo(answer1) == "yes") {
      if (answer2 == null) valid = false;
    }
    if (mapIndexToYesNo(answer3) == "yes") {
      if (answer4 == null) valid = false;
    }

    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsetsDirectional.only(bottom: 13.0, start: 72.0),
                  title: Text(
                    AppLocalizations.of(context).covid19Test,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _covid19TestQuestion(
                        context, questions[index], index % 2 == 0),
                    childCount: questions.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                  child: Material(
                    elevation: 4.0,
                    child: Builder(
                      builder: (context) {
                        return AuthButton(
                          onClick: () {
                            if (_answersValid()) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.covid19testResults,
                                  (route) => route.isFirst,
                                  arguments: Covid19TestResultsPageArguments(
                                      questions: questions));
                            } else {
                              final snackbar = SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .allFieldsRequired),
                                action: SnackBarAction(
                                  label: "╳",
                                  textColor: Provider.of<ThemeNotifier>(context,
                                              listen: false)
                                          .darkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  onPressed: () {
                                    Scaffold.of(context).hideCurrentSnackBar();
                                  },
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackbar);
                            }
                          },
                          title: AppLocalizations.of(context).finish,
                          rounded: false,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
