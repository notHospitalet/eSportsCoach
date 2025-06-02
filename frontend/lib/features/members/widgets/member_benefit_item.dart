import 'package:flutter/material.dart';

class MemberBenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const MemberBenefitItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor principal que envuelve cada elemento de beneficio
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // asigna color segun el tema: oscuro usa tono oscuro, claro usa blanco
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white,
        // bordes redondeados para darle forma de tarjeta
        borderRadius: BorderRadius.circular(12),
        // sombra sutil para elevar visualmente el contenedor
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        // ordena icono y texto horizontalmente
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // contenedor para el icono con padding interno
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // fondo semi-transparente usando color primario del tema
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              // muestra el icono pasado como parametro
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // expande el texto para ocupar el espacio restante
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // titulo del beneficio con estilo negrita
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // descripcion del beneficio con color segun tema
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
