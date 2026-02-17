import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';

class GraficaBarras extends StatelessWidget {
  final List<Gasto> gastos;

  const GraficaBarras({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    // 1. Agrupar totales por categoría
    final Map<String, double> totales = {};
    for (var gasto in gastos) {
      totales.update(
        gasto.categoria,
        (valor) => valor + gasto.monto,
        ifAbsent: () => gasto.monto,
      );
    }

    // 2. Convertir el mapa a una lista de categorías para manejar índices
    final categoriasLista = totales.keys.toList();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _obtenerMaximo(totales) * 1.2, // Espacio extra arriba
          barGroups: _generarGrupos(totales, categoriasLista),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Mostrar el nombre de la categoría abajo
                  if (value.toInt() >= 0 && value.toInt() < categoriasLista.length) {
                    return Text(
                      categoriasLista[value.toInt()].substring(0, 3), // Solo 3 letras
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
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
    );
  }

  // Genera las barras visuales
  List<BarChartGroupData> _generarGrupos(Map<String, double> totales, List<String> lista) {
    return List.generate(lista.length, (index) {
      final categoria = lista[index];
      final monto = totales[categoria]!;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monto,
            color: _obtenerColor(categoria),
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  double _obtenerMaximo(Map<String, double> totales) {
    if (totales.isEmpty) return 100;
    return totales.values.reduce((a, b) => a > b ? a : b);
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