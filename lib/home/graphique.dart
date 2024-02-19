import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GlycemicChart extends StatefulWidget {
  @override
  _GlycemicChartState createState() => _GlycemicChartState();
}

class _GlycemicChartState extends State<GlycemicChart> {
  bool _showByDay = true; // Afficher par jour par défaut

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Ajout du padding horizontal
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Alignement vers la droite
            children: [
              DropdownButton<bool>(
                value: _showByDay,
                onChanged: (newValue) {
                  setState(() {
                    _showByDay = newValue!;
                  });
                },
                underline: Container(), // Suppression du soulignement
                style: TextStyle(
                  color: _showByDay ? Colors.white : Colors.black, // Couleur du texte en fonction de la sélection
                ),
                items: [
                  DropdownMenuItem(
                    value: true,
                    child: Container(
                      color: _showByDay ? Color(0xFF004396) : Colors.white, // Fond du choix "Par jour"
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Par jour',
                          style: TextStyle(color: _showByDay ? Colors.white : Colors.black), // Couleur du texte en fonction de la sélection
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Container(
                      color: !_showByDay ? Color(0xFF004396) : Colors.white, // Fond du choix "Par heure"
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Par heure',
                          style: TextStyle(color: !_showByDay ? Colors.white : Colors.black), // Couleur du texte en fonction de la sélection
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
          aspectRatio: 1.8, // Réduction de la hauteur du graphique
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20), // Ajout de marges horizontales
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white, // Fond du graphique en blanc
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                _showByDay ? _getDayChartData() : _getHourChartData(),
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
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 4),
            FlSpot(2, 3.5),
            FlSpot(3, 5),
            FlSpot(4, 4.5),
            FlSpot(5, 6),
          ],
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
          spots: [
            FlSpot(0, 6),
            FlSpot(1, 5),
            FlSpot(2, 7),
            FlSpot(3, 4),
            FlSpot(4, 6),
            FlSpot(5, 5),
          ],
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
