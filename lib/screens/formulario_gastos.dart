import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';

class FormularioGasto extends StatefulWidget {
  final Function(Gasto) onGuardar;

  const FormularioGasto({super.key, required this.onGuardar});

  @override
  State<FormularioGasto> createState() => _FormularioGastoState();
}

class _FormularioGastoState extends State<FormularioGasto> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _montoController = TextEditingController();

  String _categoria = 'Comida';

  final List<String> _categorias = [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Otros',
  ];

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevoGasto = Gasto(
        nombre: _nombreController.text,
        monto: double.parse(_montoController.text),
        categoria: _categoria,
        fecha: DateTime.now(),
      );

      widget.onGuardar(nuevoGasto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Monto inválido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categorias
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _categoria = value.toString()),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('Guardar'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
