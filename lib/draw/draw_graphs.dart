import 'dart:ui';
import 'package:drift_dynamics/providers/data_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../database/session.dart';
import '../domain/data.dart';

class DrawGraphs {
  mainData(context) {
    Data data = Provider.of<DataPageProvider>(context).data;
    if (data.currentSessions == null) return Container();
    if (data.maxTime == null) data.maxTime = 0;
    List<VerticalLine> vertical = [];
    for (double i=0; i<60000; i+=2000){
      vertical.add(VerticalLine(x: i, color: Colors.grey, strokeWidth: 0.2));
    }
    return LineChart(LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 10000,
            getTextStyles: (context, value) =>
                const TextStyle(color: Colors.black, fontSize: 16,),
            getTitles: (value) {
              return (value / 1000).toInt().toString();
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: 100,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            getTitles: (value) {
              return value.toString();
            },
            reservedSize: 32,
            margin: 12,
          ),
        ),
        lineBarsData: drawGraphs(context),
        minX: 0,
        maxX: data.maxTime,
        minY: -100,
        maxY: 200,
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              tooltipBgColor: Colors.blue.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                List<dynamic> result = [];
                for (int i = 0; i < data.currentIndexesSession.length; i++) {
                  try {
                    result.add(LineTooltipItem(
                        "Speed: " +
                            data.currentSessions[i]
                                .session[lineBarsSpot[i].spotIndex][4]
                                .toString(),
                        TextStyle(fontSize: 15, color: data.colors[i])));
                    result.add(LineTooltipItem(
                        "Angle: " +
                            data.currentSessions[i]
                                .session[lineBarsSpot[i].spotIndex][5]
                                .toString() +
                            "\n Sector: " +
                            data.currentSessions[i]
                                .session[lineBarsSpot[i].spotIndex][6]
                                .toString(),
                        TextStyle(fontSize: 15, color: data.colors[i])));
                  } catch (e) {
                    result.add(LineTooltipItem(
                        "Данных нет...",
                        TextStyle(fontSize: 15, color: data.colors[i])));
                    result.add(LineTooltipItem(
                        "Данных нет...",
                        TextStyle(fontSize: 15, color: data.colors[i])));
                  }
                }
                return new List<LineTooltipItem>.from(result);
              }),
        ),
      extraLinesData: ExtraLinesData(
          horizontalLines: [HorizontalLine(y: 0.0, color: Colors.black38),
            HorizontalLine(y: 50.0, color: Colors.grey, strokeWidth: 0.2),
            HorizontalLine(y: 100.0, color: Colors.grey, strokeWidth: 0.2),
            HorizontalLine(y: 150.0, color: Colors.grey, strokeWidth: 0.2),
            HorizontalLine(y: -50.0, color: Colors.grey, strokeWidth: 0.2),
          ],verticalLines: vertical)));
  }

  drawGraphs(context) {
    DataPageProvider dataPageProvider = Provider.of<DataPageProvider>(context);
    List<LineChartBarData> result = [];
    int index = 0;
    for (Session session in dataPageProvider.data.currentSessions) {
      if (dataPageProvider.data.colors.length <= index ) {
        return result;
      }
      List<FlSpot> arraySpeed = [];
      List<FlSpot> arrayAngle = [];
      for (List item in session.session) {
        if (item[1].toDouble() > dataPageProvider.data.maxTime) {
          dataPageProvider.data.maxTime = item[1].toDouble();
        }
        arraySpeed.add(FlSpot(item[1].toDouble(), item[4].toDouble()));
        arrayAngle.add(FlSpot(item[1].toDouble(), item[5].toDouble()));
      }
      result.add(LineChartBarData(
        spots: arraySpeed,
        isCurved: false,
        barWidth: 3,
        dotData: FlDotData(show: false),
        colors: [dataPageProvider.data.colors[index]],
      ));
      result.add(LineChartBarData(
        spots: arrayAngle,
        isCurved: false,
        barWidth: 3,
        dotData: FlDotData(show: false),
        colors: [dataPageProvider.data.colors[index]],
      ));
      index += 1;
    }
    dataPageProvider.setMaxTime(dataPageProvider.data.maxTime);
    return result;
  }
}
