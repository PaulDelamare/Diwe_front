import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diwe_front/service/graphiqueService.dart';

class GlycemicChart extends StatefulWidget {
  @override
  _GlycemicChartState createState() => _GlycemicChartState();
}

class _GlycemicChartState extends State<GlycemicChart> {
  bool _showByDay = true;
  List<double> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    try {
      final chartData = await GraphiqueService.getGlycemicChartData(byDay: _showByDay);
      setState(() {
        _chartData = chartData;
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton<bool>(
                value: _showByDay,
                onChanged: (newValue) {
                  setState(() {
                    _showByDay = newValue!;
                    _fetchChartData(); // Actualiser les données du graphique lors du changement de sélection
                  });
                },
                underline: Container(),
                style: TextStyle(
                  color: _showByDay ? Colors.white : Colors.black,
                ),
                items: [
                  DropdownMenuItem(
                    value: true,
                    child: Container(
                      color: _showByDay ? Color(0xFF004396) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Par jour',
                          style: TextStyle(color: _showByDay ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Container(
                      color: !_showByDay ? Color(0xFF004396) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Par heure',
                          style: TextStyle(color: !_showByDay ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 0.5),
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
                _showByDay ? _getDayChartData() : _getHourChartData(),
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

  LineChartData _getDayChartData() {
    return LineChartData(
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

  LineChartData _getHourChartData() {
    return LineChartData(
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
