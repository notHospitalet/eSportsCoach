import 'package:flutter/material.dart';
import '../../../core/constants/champions.dart';

class ChampionSelector extends StatefulWidget {
  final List<String> selectedChampions;
  final Function(List<String>) onChanged;
  final int maxSelection;

  const ChampionSelector({
    Key? key,
    required this.selectedChampions,
    required this.onChanged,
    this.maxSelection = 5,
  }) : super(key: key);

  @override
  State<ChampionSelector> createState() => _ChampionSelectorState();
}

class _ChampionSelectorState extends State<ChampionSelector> {
  // controlador del campo de busqueda
  final TextEditingController _searchController = TextEditingController();
  // lista filtrada de campeones segun busqueda
  List<String> _filteredChampions = Champions.all;

  @override
  void initState() {
    super.initState();
    // agregar listener para actualizar filtro cuando cambia el texto
    _searchController.addListener(_filterChampions);
  }

  @override
  void dispose() {
    // liberar recursos del controlador al desmontar
    _searchController.dispose();
    super.dispose();
  }

  // filtra la lista de campeones segun el texto ingresado
  void _filterChampions() {
    setState(() {
      // usar metodo de Champions para buscar coincidencias
      _filteredChampions = Champions.search(_searchController.text);
    });
  }

  // agrega o quita un campeon de la lista seleccionada
  void _toggleChampion(String champion) {
    // crear copia de la lista actual para modificar
    List<String> newSelection = List.from(widget.selectedChampions);

    if (newSelection.contains(champion)) {
      // si ya esta seleccionado, eliminarlo
      newSelection.remove(champion);
    } else {
      // si no esta seleccionado, verificar si no supera el maximo permitido
      if (newSelection.length < widget.maxSelection) {
        newSelection.add(champion);
      } else {
        // mostrar mensaje si intenta seleccionar mas campeones de los permitidos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'puedes seleccionar un maximo de ${widget.maxSelection} campeones'
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // notificar el cambio a traves del callback onChanged
    widget.onChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // contenedor que envuelve el campo de busqueda
        Container(
          decoration: BoxDecoration(
            // fondo diferente segun tema claro u oscuro
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2E)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'buscar campeon...', // texto guia sin acentos ni mayusculas
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none, // sin borde predeterminado
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              // si hay texto, mostrar icono para limpiar busqueda
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // texto que muestra cuantos campeones estan seleccionados
        Text(
          'seleccionados: ${widget.selectedChampions.length}/${widget.maxSelection}',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),

        const SizedBox(height: 12),

        // contenedor para la lista de campeones en forma de grilla
        Container(
          height: 300,
          decoration: BoxDecoration(
            // borde para delimitar el area
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white24
                  : Colors.black12,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          // si no hay resultados, mostrar mensaje
          child: _filteredChampions.isEmpty
              ? const Center(
                  child: Text('no se encontraron campeones'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 columnas
                    childAspectRatio: 2.5, // relacion ancho/alto de cada celda
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredChampions.length,
                  itemBuilder: (context, index) {
                    final champion = _filteredChampions[index];
                    // determinar si el campeon esta actualmente seleccionado
                    final isSelected = widget.selectedChampions.contains(champion);

                    return GestureDetector(
                      onTap: () => _toggleChampion(champion),
                      child: Container(
                        decoration: BoxDecoration(
                          // fondo diferente si esta seleccionado o no
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                              : Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF3C3C3E)
                                  : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          // borde si esta seleccionado para resaltarlo
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            champion,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // texto recortado si es muy largo
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
