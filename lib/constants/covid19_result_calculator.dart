import 'package:riskfactor/pages/home/Covid19TestPage.dart';

const questionMap = {
  "question_1": {
    "yes": "question_2-a",
    "no": "question_2-b",
  },
  "question_2-a": {
    "yes": "question_3",
    "no": "question_4",
  },
  "question_2-b": {
    "yes": "question_5",
    "no": 5,
  },
  "question_3": {
    "before": "question_5",
    "after": 1,
  },
  "question_4": {
    "before": 5,
    "after": 3,
  },
  "question_5": {
    "anyof_case1": 2,
    "anyof_case2": 4,
  }
};

String mapIndexToYesNo(int index) => (["yes", "no"])[index];

String mapDateToBeforeOrAfter14Days(DateTime dateTime) => DateTime.now()
            .difference(dateTime ?? DateTime.now().subtract(Duration(days: 15)))
            .compareTo(Duration(days: 14)) <
        0
    ? "after"
    : "before";

String mapSymptomDataToCases(List<TestQuestionCheckbox> data) {
  return data.any((element) =>
          element.checked &&
          [
            "had_fever_in_past_24h",
            "had_fever_in_past_4d",
            "chills",
            "lost_taste",
            "body_aches",
          ].contains(element.value))
      ? "anyof_case1"
      : "anyof_case2";
}

int calculateCovid19TestResults(List<TestQuestion> questions) {
  final answer1 = mapIndexToYesNo(questions[0].radioData.checkedIndex);
  final answer3 = mapDateToBeforeOrAfter14Days(questions[1].dateData);
  final answer2 = mapIndexToYesNo(questions[2].radioData.checkedIndex);
  final answer4 = mapDateToBeforeOrAfter14Days(questions[3].dateData);
  final answer5 = mapSymptomDataToCases(questions[4].checkboxData);

  final answers = [answer1, answer2, answer3, answer4, answer5];

  int caseNumber = 0;

  String nextQuestion;
  for (int i = 0; i < answers.length; i++) {
    final temp = questionMap[nextQuestion ?? "question_${i + 1}"][answers[i]];
    if (temp is int) {
      caseNumber = temp;
      break;
    } else {
      nextQuestion = temp;
      i = int.parse(nextQuestion.substring(9, 10)) - 2;
    }
  }

  return caseNumber;
}
