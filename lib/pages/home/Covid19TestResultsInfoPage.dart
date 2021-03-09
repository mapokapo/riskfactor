import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/state/ThemeNotifier.dart';

class CaseInfo {
  String title;
  String body;
  Color backgroundColor;
  Color lightColor;
  Color foregroundColor;

  CaseInfo({
    this.title,
    this.body,
    this.backgroundColor,
    this.lightColor,
    this.foregroundColor,
  });
}

class Covid19TestResultsInfoPage extends StatelessWidget {
  Widget tileCard(BuildContext context, CaseInfo e, int index) {
    String case1Name = AppLocalizations.of(context).case1Name;
    String case2Name = AppLocalizations.of(context).case2Name;
    String case3Name = AppLocalizations.of(context).case3Name;
    String case4Name = AppLocalizations.of(context).case4Name;
    String case5Name = AppLocalizations.of(context).case5Name;
    List<String> caseNames = [
      case1Name,
      case2Name,
      case3Name,
      case4Name,
      case5Name,
    ];

    String case1Info = AppLocalizations.of(context).case1Info;
    String case3Info = AppLocalizations.of(context).case3Info;
    String case2Info = AppLocalizations.of(context).case2Info;
    String case4Info = AppLocalizations.of(context).case4Info;
    String case5Info = AppLocalizations.of(context).case5Info;
    List<String> caseInfos = [
      case1Info,
      case2Info,
      case3Info,
      case4Info,
      case5Info,
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: e.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: e.lightColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: e.foregroundColor,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${index + 1}",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: e.foregroundColor,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      caseNames[index],
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: e.foregroundColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  caseInfos[index],
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<CaseInfo> casesInfo = [
      CaseInfo(
          title: AppLocalizations.of(context).case1Name,
          body: AppLocalizations.of(context).case1Info,
          backgroundColor: Color(0xFFFFDADD),
          lightColor: Colors.red.shade200,
          foregroundColor: Colors.red.shade600),
      CaseInfo(
        title: AppLocalizations.of(context).case2Name,
        body: AppLocalizations.of(context).case2Info,
        backgroundColor: Colors.orange.shade50,
        lightColor: Colors.orange.shade100,
        foregroundColor: Colors.orange,
      ),
      CaseInfo(
        title: AppLocalizations.of(context).case3Name,
        body: AppLocalizations.of(context).case3Info,
        backgroundColor: Colors.orange.shade50,
        lightColor: Colors.orange.shade100,
        foregroundColor: Colors.orange,
      ),
      CaseInfo(
        title: AppLocalizations.of(context).case4Name,
        body: AppLocalizations.of(context).case4Info,
        backgroundColor: Colors.yellow.shade50,
        lightColor: Colors.yellow.shade100,
        foregroundColor: Colors.yellow.shade700,
      ),
      CaseInfo(
        title: AppLocalizations.of(context).case5Name,
        body: AppLocalizations.of(context).case5Info,
        backgroundColor: Colors.green.shade50,
        lightColor: Colors.green.shade100,
        foregroundColor: Colors.green,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).covid19TestResults,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).caseMeanings,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Provider.of<ThemeNotifier>(context).darkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              ...casesInfo.asMap().entries.map((e) {
                int index = e.key;
                CaseInfo value = e.value;
                return tileCard(context, value, index);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
