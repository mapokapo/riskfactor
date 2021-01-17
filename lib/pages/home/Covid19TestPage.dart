import 'package:flutter/material.dart';

class Covid19TestPage extends StatefulWidget {
  @override
  _Covid19TestPageState createState() => _Covid19TestPageState();
}

class _Covid19TestPageState extends State<Covid19TestPage> {
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
                  title: Text("COVID-19 test"),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Placeholder(),
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
