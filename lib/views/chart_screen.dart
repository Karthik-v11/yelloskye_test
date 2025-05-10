import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatelessWidget {
  final List<FlSpot> lineSpots = [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 4),
    FlSpot(3, 2),
    FlSpot(4, 5),
    FlSpot(5, 4),
    FlSpot(6, 5),
  ];

  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(toY: 6, fromY: 0, color: Colors.tealAccent, width: 14),
      ],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(toY: 4, fromY: 0, color: Colors.tealAccent, width: 14),
      ],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(toY: 5, fromY: 0, color: Colors.tealAccent, width: 14),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Project Analytics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              title: 'Project Activity (Weekly)',
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.black,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine:
                        (_) => FlLine(color: Colors.white10),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: lineSpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.blueAccent],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.3),
                            Colors.blue.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              title: 'Projects per Category',
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false,
                    getDrawingVerticalLine:
                        (_) => FlLine(color: Colors.white10),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: _barTitles()),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _metricTile("Total", "24", Icons.all_inbox),
          _metricTile("Active", "12", Icons.work_outline),
          _metricTile("Completed", "10", Icons.check_circle_outline),
          _metricTile("Pending", "2", Icons.hourglass_bottom),
        ],
      ),
    );
  }

  Widget _metricTile(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 28),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
    ],
  );

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return Text(
          titles[value.toInt()],
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        );
      },
    );
  }

  SideTitles _barTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        const titles = ['AI', 'Drone', 'IoT'];
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            titles[value.toInt()],
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        );
      },
    );
  }
}
