import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';
import 'package:proyecto/screens/formulario_gastos.dart';
import 'package:proyecto/screens/grafica.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Gasto> _gastos = [];

  final Map<String, IconData> _iconos = {
    'COMIDA': Icons.restaurant,
    'TRANSPORTE': Icons.directions_bus,
    'ENTRETENIMIENTO': Icons.movie,
    'VIAJE': Icons.flight,
    'OTROS': Icons.star,
  };

  void _abrirFormulario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioGasto(
          onGuardar: (gasto) {
            setState(() {
              _gastos.add(gasto);
            });
          },
        ),
      ),
    );
  }

  void _eliminarGasto(int index) {
    setState(() {
      _gastos.removeAt(index);
    });
  }

  // Widget separado para la lista, así no repetimos código en Portrait y Landscape
  Widget _buildListaGastos() {
    return ListView.builder(
      itemCount: _gastos.length,
      itemBuilder: (context, index) {
        final gasto = _gastos[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: ListTile(
            leading: Icon(
              _iconos[gasto.categoria.toUpperCase().trim()] ?? Icons.category,
              color: const Color.fromARGB(255, 37, 42, 106),
            ),
            title: Text(
              gasto.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${gasto.categoria} - \$${gasto.monto}\n'
              'Fecha: ${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _eliminarGasto(index),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Gastos')),
      body: _gastos.isEmpty
          ? const Center(
              child: Text(
                'No hay gastos registrados',
                style: TextStyle(fontSize: 18),
              ),
            )
          : OrientationBuilder(
              builder: (context, orientation) {
                // MODO VERTICAL (Portrait)
                if (orientation == Orientation.portrait) {
                  return Column(
                    children: [
                      GraficaBarras(gastos: _gastos),
                      const Divider(),
                      Expanded(
                        child: _buildListaGastos(),
                      ),
                    ],
                  );
                } 
                // MODO HORIZONTAL (Landscape)
                else {
                  return Row(
                    children: [
                      // Gráfica a la izquierda
                      Expanded(
                        flex: 2, // Toma 2 partes del espacio
                        child: SingleChildScrollView(
                          child: GraficaBarras(gastos: _gastos),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // Lista a la derecha
                      Expanded(
                        flex: 3, // Toma 3 partes del espacio (un poco más ancha)
                        child: _buildListaGastos(),
                      ),
                    ],
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}