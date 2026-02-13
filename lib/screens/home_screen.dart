import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';
import 'package:proyecto/screens/formulario_gastos.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Gastos')),
      body: ListView.builder(
        itemCount: _gastos.length,
        itemBuilder: (context, index) {
          final gasto = _gastos[index];
          return ListTile(
            title: Text(gasto.nombre),
            subtitle: Text('${gasto.categoria} - \$${gasto.monto}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
