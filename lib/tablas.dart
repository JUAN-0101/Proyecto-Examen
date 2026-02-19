import 'package:flutter/material.dart';
import 'package:proyecto/models/gasto.dart';

class ListaGastos extends StatelessWidget {

  final List<Gasto> items; 

  const ListaGastos(this.items, {super.key});

  IconData _getIcono(String cat){
    String categoria =cat.toLowerCase();
    if(cat == 'Comida') return Icons.restaurant;
    if(cat == 'Trasnporte') return Icons.directions_bus;
    if(cat == 'Entretenimiento') return Icons.movie;
    if(cat == 'Otros') return Icons.star;
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final gasto = items[i];
        return ListTile(
          leading: Icon(_getIcono(gasto.categoria), color:const Color.fromARGB(255, 37, 42, 106),),
          title: Text(gasto.nombre),
        subtitle: Text(gasto.categoria),
        trailing: Text('${gasto.monto}'),
        );
      },
    );
  }
}

