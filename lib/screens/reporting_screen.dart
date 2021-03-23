import 'package:flutter/material.dart';
import 'package:tinda/widgets/charts/line_chart_widget.dart';

class ReportingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Reports Manager'), centerTitle: true),
        body: PageView(
          children: [
            LineChartPage(),
          ],
        ),
      );
}

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xff020227),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: LineChartWidget(),
        ),
      );
}
