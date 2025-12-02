import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/forecast.dart';
import 'package:intl/intl.dart';


class ForecastChart extends StatelessWidget {
  final List<Forecast> forecasts;

  const ForecastChart({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Theme.of(context).primaryColor),
                const SizedBox(width: 0),
                Text(
                  'Temperature Trend',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                _buildLegend(Colors.red.shade400, 'Max'),
                const SizedBox(width: 10),
                _buildLegend(Colors.blue.shade600, 'Min'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < forecasts.length) {
                            final date = forecasts[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                DateFormat('MMM\ndd').format(date),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}°',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  minX: 0,
                  maxX: (forecasts.length - 1).toDouble(),
                  minY: _getMinTemp() - 5,
                  maxY: _getMaxTemp() + 5,
                  lineBarsData: [
                    // Max temperature line
                    LineChartBarData(
                      spots: forecasts.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.tempMax,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.red.shade400,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.red.shade400,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Min temperature line
                    LineChartBarData(
                      spots: forecasts.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.tempMin,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue.shade600,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.blue.shade600,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.shade100.withOpacity(0.3),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final date = forecasts[touchedSpot.x.toInt()].date;
                          final isMaxTemp = touchedSpot.barIndex == 0;
                          return LineTooltipItem(
                            '${DateFormat('MMM dd').format(date)}\n${isMaxTemp ? 'Max' : 'Min'}: ${touchedSpot.y.toStringAsFixed(1)}°C',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMinTemp() {
    if (forecasts.isEmpty) return 0;
    final allTemps = forecasts.expand((f) => [f.tempMin, f.tempMax]).toList();
    return allTemps.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxTemp() {
    if (forecasts.isEmpty) return 30;
    final allTemps = forecasts.expand((f) => [f.tempMin, f.tempMax]).toList();
    return allTemps.reduce((a, b) => a > b ? a : b);
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
