import 'package:flutter/material.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/custom_button.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;

  const BookingCard({
    Key? key,
    required this.booking,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // margen inferior para separar tarjetas
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        // padding interno para dar espacio al contenido
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // encabezado con estado y fecha de la reserva
            Row(
              children: [
                // contenedor que muestra el estado de la reserva
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // color de fondo segun el estado
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    // texto que muestra el estado legible
                    _getStatusText(booking.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // texto que muestra la fecha formateada de la reserva
                Text(
                  DateFormatter.formatShortDate(booking.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // fila con icono representativo y detalles de la reserva
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // contenedor con icono de estilo 'esports'
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.sports_esports,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                // columna con informaciones de la sesion
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // titulo fijo de la sesion
                      const Text(
                        'sesion de coaching',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // nombre del coach (dato fijo o dinamico segun implementacion)
                      Text(
                        'coach: carlos martinez',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // fila con icono y texto para hora y duracion
                      Row(
                        children: [
                          // icono de reloj para representar hora
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black45,
                          ),
                          const SizedBox(width: 4),
                          // texto que muestra la hora formateada
                          Text(
                            DateFormatter.formatTime(booking.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // icono de temporizador para duracion fija
                          Icon(
                            Icons.timer,
                            size: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black45,
                          ),
                          const SizedBox(width: 4),
                          // texto que indica duracion por defecto
                          Text(
                            '60 minutos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // si existen notas, se muestra un contenedor extra
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                // estilo de fondo ligero para el area de notas
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800.withAlpha(76)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // etiqueta que precede al texto de notas
                    const Text(
                      'notas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // texto con las notas proporcionadas
                    Text(booking.notes!),
                  ],
                ),
              ),
            ],

            // si se proporciona callback onCancel, mostrar boton de cancelar
            if (onCancel != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'cancelar reserva',
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      }
                    },
                    type: ButtonType.outline,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // metodo auxiliar para obtener color segun estado
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // metodo auxiliar que retorna texto legible segun estado
  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pendiente';
      case BookingStatus.confirmed:
        return 'confirmada';
      case BookingStatus.cancelled:
        return 'cancelada';
      case BookingStatus.completed:
        return 'completada';
      default:
        return 'desconocido';
    }
  }
}
