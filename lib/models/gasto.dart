class Gasto {
  final String categoria;
  final String descripcion;
  final double monto;
  final DateTime fecha;

  Gasto({
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.monto,
  });
}
