import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PhGraphScreen extends StatelessWidget {
  final List<dynamic> dataPoints;

  const PhGraphScreen({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    // 1. Procesamiento de datos (lo que ya tenías)
    List<FlSpot> phValues = [];
    DateTime? firstTimestamp;

    if (dataPoints.isNotEmpty) {
      firstTimestamp = DateTime.parse(dataPoints[0]['created_at']);

      for (int i = 0; i < dataPoints.length; i++) {
        final point = dataPoints[i];
        final dynamic rawPh =
            point['ph_level'] ??
            point['ph']; // Usamos ph_level o ph como fallback
        if (rawPh == null || rawPh is! num) continue;

        final currentTimestamp = DateTime.parse(point['created_at']);
        final secondsDiff =
            currentTimestamp.difference(firstTimestamp).inSeconds.toDouble();

        phValues.add(FlSpot(secondsDiff, (rawPh as num).toDouble()));
      }
    }

    // 2. Configuración del gráfico - ESTO ES LO NUEVO QUE DEBES AÑADIR
    final lineChartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: phValues,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          belowBarData: BarAreaData(show: false),
          dotData: FlDotData(show: false),
        ),
      ],
      minY: 0, // pH mínimo
      maxY: 14, // pH máximo
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final duration = Duration(seconds: value.toInt());
              return Text('${duration.inMinutes}m');
            },
            interval: 300, // Mostrar cada 5 minutos (300 segundos)
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(value.toStringAsFixed(1));
            },
            reservedSize: 40,
            interval: 2, // Mostrar cada 2 unidades de pH
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: 300,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
    );

    // 3. Widget del gráfico
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de pH')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            phValues.isNotEmpty
                ? SizedBox(
                  height: 400,
                  child: LineChart(
                    lineChartData,
                  ), // AQUÍ SE APLICA LA CONFIGURACIÓN
                )
                : const Center(child: Text('No hay datos disponibles')),
      ),
    );
  }
}
