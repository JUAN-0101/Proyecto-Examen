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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Gastos')),
      // 1. Usamos OrientationBuilder para detectar el giro
      body: OrientationBuilder(
        builder: (context, orientation) {
          // 2. Si es vertical, mantenemos la Column, si es horizontal, usamos Row
          if (orientation == Orientation.portrait) {
            return Column(
              children: [
                GraficaBarras(gastos: _gastos),
                _buildTituloHistorial(),
                Expanded(child: _buildListaGastos()),
              ],
            );
          } else {
            // 3. Diseño horizontal: Gráfica a la izquierda, Lista a la derecha
            return Row(
              children: [
                // Gráfica del lado izquierdo 
                Expanded(
                  flex: 2, 
                  child: SingleChildScrollView(
                    child: GraficaBarras(gastos: _gastos),
                  ),
                ),
                // Historial del lado derecho 
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildTituloHistorial(),
                      Expanded(child: _buildListaGastos()),
                    ],
                  ),
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


  Widget _buildTituloHistorial() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Historial",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper para no repetir el código de la lista
  Widget _buildListaGastos() {
    if (_gastos.isEmpty) {
      return const Center(child: Text('No hay gastos registrados'));
    }
    return ListView.builder(
      itemCount: _gastos.length,
      itemBuilder: (context, index) {
        final gasto = _gastos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(gasto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${gasto.categoria} - \$${gasto.monto}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _eliminarGasto(index),
            ),
          ),
        );
      },
    );
  }
}
        
