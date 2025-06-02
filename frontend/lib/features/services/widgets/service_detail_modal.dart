import 'package:flutter/material.dart';
import '../../../data/models/service_model.dart';
import '../../../shared/widgets/custom_button.dart';

class ServiceDetailModal extends StatelessWidget {
  final Service service;

  const ServiceDetailModal({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // establecemos la altura del modal al 85% de la pantalla
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        // usamos el color de fondo del scaffold para el modal
        color: Theme.of(context).scaffoldBackgroundColor,
        // esquinas superiores redondeadas
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // barra de arrastre para indicar que es un modal deslizable
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                // color gris semitransparente
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // contenido principal del modal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // encabezado con titulo, etiqueta popular y precio
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // si el servicio es popular, mostramos etiqueta
                            if (service.isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  // fondo con color secundario
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Popular',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            // titulo del servicio
                            Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // tipo de servicio (texto distintivo)
                            Text(
                              _getServiceTypeText(service.type),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // contenedor con el precio, alineado a la derecha
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // fondo con color primario
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '\$${service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // seccion de descripcion general
                  const Text(
                    'Descripcion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // seccion de duracion del servicio
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Duracion: ${_formatDuration(service.durationMinutes)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // seccion de caracteristicas incluidas en el servicio
                  const Text(
                    'Que incluye',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // recorremos la lista de features y los mostramos como filas con icono y texto
                  ...service.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // información adicional con fondo resaltado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800.withOpacity(0.3)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informacion adicional',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Las sesiones se realizan a traves de Discord. Recibiras un enlace despues de completar tu reserva.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Se requiere grabacion previa de una partida para las sesiones de analisis individual.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // boton fijo en la parte inferior para reservar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: CustomButton(
              // texto del boton
              text: 'Reservar Ahora',
              onPressed: () {
                // cerramos el modal y navegamos a la pantalla de contacto para reservar
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  // metodo para obtener texto segun el tipo de servicio
  String _getServiceTypeText(ServiceType type) {
    switch (type) {
      case ServiceType.individual:
        return 'Sesion individual';
      case ServiceType.monthly:
        return 'Plan mensual';
      case ServiceType.course:
        return 'Curso';
      case ServiceType.guide:
        return 'Guia';
      case ServiceType.team:
        return 'Coaching de equipo';
      default:
        return 'Servicio';
    }
  }

  // metodo para formatear minutos a horas y minutos legibles
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes minutos';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hora' : 'horas'}';
      } else {
        return '$hours ${hours == 1 ? 'hora' : 'horas'} y $remainingMinutes minutos';
      }
    }
  }
}
