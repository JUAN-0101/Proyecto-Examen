import 'package:flutter/material.dart';

class ListaGastos extends StatelessWidget {

  final List<dynamic> items; 

  const ListaGastos(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) => ListTile(
        title: Text("Gasto provisional #$i"),
        subtitle: const Text("Configurando diseño..."),
      ),
    );
  }
}

