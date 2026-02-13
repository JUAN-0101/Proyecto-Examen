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
  DateTime? _fechaSeleccionada;

  final List<String> _categorias = [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Otros',
  ];

  void _seleccionarFecha() async {
    final ahora = DateTime.now();

    final fecha = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) {
      return; // Si hay errores en los campos, no continúa
    }

    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar una fecha')),
      );
      return;
    }

    final nuevoGasto = Gasto(
      nombre: _nombreController.text.trim(),
      monto: double.parse(_montoController.text.trim()),
      categoria: _categoria,
      fecha: _fechaSeleccionada!,
    );

    widget.onGuardar(nuevoGasto);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nombre
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del gasto',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese un nombre';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Monto
                TextFormField(
                  controller: _montoController,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese un monto';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Ingrese un número válido';
                    }
                    if (double.parse(value.trim()) <= 0) {
                      return 'El monto debe ser mayor a 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Categoría
                DropdownButtonFormField(
                  value: _categoria,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: _categorias
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoria = value.toString();
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Fecha
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _fechaSeleccionada == null
                            ? 'No se ha seleccionado fecha'
                            : 'Fecha: ${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: _seleccionarFecha,
                      child: const Text('Seleccionar fecha'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Botones
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
      ),
    );
  }
}
