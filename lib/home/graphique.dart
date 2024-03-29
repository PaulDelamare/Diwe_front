import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diwe_front/service/graphiqueService.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GlycemicChart extends StatefulWidget {
  @override
  _GlycemicChartState createState() => _GlycemicChartState();
}

class _GlycemicChartState extends State<GlycemicChart> {
  List<double> _chartData = [];

@override
void initState() {
  super.initState();

  // Récupérer la première donnée et mettre à jour le graphique
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    _fetchChartData();
  });

  // Mettre à jour le graphique toutes les 15 secondes
  Timer.periodic(Duration(seconds: 15), (Timer t) {
    if (mounted) {
      _fetchChartData();
    } else {
      t.cancel();
    }
  });
}

@override
void dispose() {
  super.dispose();
}

// Function for get last data
  Future<void> _fetchChartData() async {
    try {
      // get last data
      final chartData = await GraphiqueService.getGlycemicChartData();
      // Have only 7 data
      if (_chartData.length >= 8) {
        // remove the last data
        _chartData.removeAt(0);
      }
      // Push the last data in list
      setState(() {
        _chartData.add(chartData);
      });
    } catch (e) {
      // Gérer les erreurs de récupération des données
      print('Error fetching chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.8,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _chartData.isNotEmpty
                  ? LineChart(
                _getPulse(),
              )
                  : Center(
                child: CircularProgressIndicator(), // Afficher un indicateur de chargement pendant la récupération des données
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _getPulse() {
    return LineChartData(
      // Defined the minimum and maximum values
      minY: 40,
      maxY: 200,
      // Define the grid data to hidden
      gridData: FlGridData(
        show: false,
      ),
      // Display the bottom data
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
        ),
        // Hide the left title
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      // Define graph
      lineBarsData: [
        LineChartBarData(
          spots: _chartData
              .asMap()
              .map((index, value) => MapEntry(index.toDouble(), FlSpot(index.toDouble(), value)))
              .values
              .toList(),
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}

