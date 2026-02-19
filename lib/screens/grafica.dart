import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';

class GraficaBarras extends StatelessWidget {
  final List<Gasto> gastos;

  // Categorías fijas para que siempre aparezcan
  final List<String> categoriasFijas = [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Otros'
  ];

  GraficaBarras({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    // Inicializamos el mapa con 0.0 para todas las categorías fijas
    final Map<String, double> totales = {
      for (var cat in categoriasFijas) cat: 0.0
    };

    // Sumamos los gastos existentes
    for (var gasto in gastos) {
      if (totales.containsKey(gasto.categoria)) {
        totales[gasto.categoria] = totales[gasto.categoria]! + gasto.monto;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      height: 220, // Aumentamos un poco el alto para los iconos
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _obtenerMaximo(totales) * 1.2,
            barGroups: _generarGrupos(totales, categoriasFijas),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Espacio para los iconos
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < categoriasFijas.length) {
                      String cat = categoriasFijas[index];
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Icon(
                          _obtenerIcono(cat),
                          color: _obtenerColor(cat),
                          size: 22,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generarGrupos(Map<String, double> totales, List<String> lista) {
    return List.generate(lista.length, (index) {
      final categoria = lista[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totales[categoria]!,
            color: _obtenerColor(categoria),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _obtenerMaximo(totales) * 1.2,
              color: Colors.grey[50],
            ),
          ),
        ],
      );
    });
  }

  double _obtenerMaximo(Map<String, double> totales) {
    if (totales.values.every((v) => v == 0)) return 100;
    return totales.values.reduce((a, b) => a > b ? a : b);
  }

  IconData _obtenerIcono(String cat) {
    switch (cat) {
      case 'Comida': return Icons.restaurant_rounded;
      case 'Transporte': return Icons.directions_bus_rounded;
      case 'Entretenimiento': return Icons.movie_creation_rounded;
      default: return Icons.category_rounded;
    }
  }

  Color _obtenerColor(String cat) {
    switch (cat) {
      case 'Comida': return Colors.orange;
      case 'Transporte': return Colors.blue;
      case 'Entretenimiento': return Colors.purple;
      default: return Colors.teal;
    }
  }
}