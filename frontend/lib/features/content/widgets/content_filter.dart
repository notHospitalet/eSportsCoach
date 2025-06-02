import 'package:flutter/material.dart';

/// Widget que muestra una fila de chips para filtrar el contenido por tipo.
/// El chip seleccionado se resalta y al cambiar el filtro, se notifica al padre.
class ContentFilter extends StatelessWidget {
  /// Filtro actualmente seleccionado ('all', 'article', 'video', 'guide' o 'analysis').
  final String selectedFilter;

  /// Callback que se invoca cuando se selecciona un nuevo filtro.
  final Function(String) onFilterChanged;

  const ContentFilter({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Altura fija para la barra de filtros
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        // Lista horizontal de chips
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(context, 'all', 'Todos'),
          _buildFilterChip(context, 'article', 'Artículos'),
          _buildFilterChip(context, 'video', 'Videos'),
          _buildFilterChip(context, 'guide', 'Guías'),
          _buildFilterChip(context, 'analysis', 'Análisis'),
        ],
      ),
    );
  }

  /// Crea un FilterChip con el [value] y [label] indicados.
  /// Si [value] coincide con [selectedFilter], se mostrará como seleccionado.
  Widget _buildFilterChip(BuildContext context, String value, String label) {
    final isSelected = selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8), // Separación entre chips
      child: FilterChip(
        label: Text(label),
        selected: isSelected, // Destaca el chip si está seleccionado
        onSelected: (selected) {
          // Cuando el usuario toca el chip, notificamos el nuevo filtro
          onFilterChanged(value);
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)   // Color de fondo en modo oscuro
            : Colors.grey.shade200,     // Color de fondo en modo claro
        selectedColor: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(0.2),         // Color de fondo cuando está seleccionado
        checkmarkColor: Theme.of(context).colorScheme.primary, // Color de la marca
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary // Texto resaltado si está seleccionado
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white                    // Texto en modo oscuro si no está seleccionado
                  : Colors.black,                   // Texto en modo claro si no está seleccionado
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
