import 'package:flutter/material.dart';

class ServiceFilter extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ServiceFilter({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor de altura fija que contiene los chips de filtro
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        // lista horizontal desplazable para mostrar los filtros
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // chip para filtrar todos los servicios
          _buildFilterChip(context, 'all', 'todos'),
          // chip para filtrar servicios individuales
          _buildFilterChip(context, 'individual', 'individual'),
          // chip para filtrar planes mensuales
          _buildFilterChip(context, 'monthly', 'mensual'),
          // chip para filtrar cursos grabados
          _buildFilterChip(context, 'course', 'cursos'),
          // chip para filtrar guias
          _buildFilterChip(context, 'guide', 'guías'),
          // chip para filtrar coaching para equipos
          _buildFilterChip(context, 'team', 'equipos'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String value, String label) {
    // determinamos si este chip esta seleccionado comparando con el filtro actual
    final isSelected = selectedFilter == value;
    
    return Padding(
      // margen derecho para separar chips
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        // cuando el usuario selecciona este chip, llamamos al callback con el valor correspondiente
        onSelected: (selected) {
          onFilterChanged(value);
        },
        // color de fondo cuando no esta seleccionado
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.grey.shade200,
        // color de fondo cuando esta seleccionado
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        // color de la marca de verificacion
        checkmarkColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          // color del texto segun si esta seleccionado o no
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
          // negrita si esta seleccionado
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
