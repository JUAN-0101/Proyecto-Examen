import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';

class ListaGastos extends StatelessWidget {

  final List<Gasto> items; 

  const ListaGastos(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final gasto = items[i];
        return ListTile(
          title: Text(gasto.nombre),
        subtitle: Text(gasto.categoria),
        trailing: Text('${gasto.monto}'),
        );
      },
    );
  }
}

