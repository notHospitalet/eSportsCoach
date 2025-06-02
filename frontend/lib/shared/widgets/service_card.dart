import 'package:flutter/material.dart';
import '../../data/models/service_model.dart';
import 'custom_button.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final VoidCallback? onBookNow;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
    this.onBookNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // se envuelve la tarjeta en un GestureDetector para detectar toques
      onTap: onTap, // cuando se toca la tarjeta, se ejecuta la funcion onTap
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        // tarjeta con espacio vertical para separar cada servicio
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // si el servicio es popular, se dibuja un borde de color
            border: service.isPopular
                ? Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // si el servicio esta marcado como popular, se muestra la etiqueta
              if (service.isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              // titulo del servicio
              Text(
                service.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // descripcion breve del servicio con maximo dos lineas
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // fila con precio y boton de reservacion si aplica
              Row(
                children: [
                  Text(
                    '\$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  // si se proporciona onBookNow, se muestra el boton 'book now'
                  if (onBookNow != null)
                    CustomButton(
                      text: 'book now',
                      onPressed: onBookNow!,
                      height: 40,
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
