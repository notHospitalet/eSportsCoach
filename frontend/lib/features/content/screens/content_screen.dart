import 'package:flutter/material.dart';
import '../../../data/models/content_model.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/content_card.dart';
import '../widgets/content_filter.dart';
import '../widgets/content_detail_screen.dart';

/// pantalla principal para mostrar y filtrar contenido gratuito
class ContentScreen extends StatefulWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String _selectedFilter = 'all';            // filtro actualmente seleccionado ('all', 'article', etc.)
  String _searchQuery = '';                   // texto de búsqueda ingresado
  final TextEditingController _searchController = TextEditingController();
  
  // datos de ejemplo que simulan contenido cargado desde backend
  final List<Content> _contentList = [
    // guías de campeones
    Content(
      id: '1',
      title: 'Guía completa de Yasuo',
      description: 'Aprende a dominar a Yasuo con esta guía detallada sobre runas, builds y combos.',
      thumbnailUrl: 'assets/images/champions/yasuo.png',
      type: ContentType.guide,
      tags: ['Yasuo', 'Mid', 'Guía de Campeón'],
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Content(
      id: '2',
      title: 'Guía completa de Lee Sin',
      description: 'Domina la jungla con Lee Sin: runas, builds, pathing y mecánicas avanzadas.',
      thumbnailUrl: 'assets/images/champions/lee_sin.png',
      type: ContentType.guide,
      tags: ['Lee Sin', 'Jungle', 'Guía de Campeón'],
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    // análisis de partidas profesionales
    Content(
      id: '3',
      title: 'Análisis: T1 vs JDG - Worlds 2023',
      description: 'Desglose detallado de las estrategias y decisiones clave en la semifinal de Worlds.',
      thumbnailUrl: 'https://example.com/images/t1-vs-jdg.png',
      type: ContentType.analysis,
      tags: ['Pro Play', 'Worlds', 'Análisis'],
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    // guía para low elo
    Content(
      id: '4',
      title: 'Cómo salir de Iron/Bronze',
      description: 'Guía paso a paso para mejorar y escalar en los rangos más bajos del juego.',
      thumbnailUrl: 'assets/images/guides/low_elo.png',
      type: ContentType.guide,
      tags: ['Low Elo', 'Mejora', 'Guía'],
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    // contenido de mentalidad
    Content(
      id: '5',
      title: 'Manejo del tilt y la frustración',
      description: 'Aprende a mantener la calma y mejorar tu mentalidad durante las partidas.',
      thumbnailUrl: 'assets/images/mentality/tilt.png',
      type: ContentType.article,
      tags: ['Mentalidad', 'Tilt', 'Psicología'],
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    // tutorial en video
    Content(
      id: '6',
      title: 'Tutorial: Wave Management Básico',
      description: 'Aprende los conceptos fundamentales del control de oleadas.',
      thumbnailUrl: 'https://example.com/images/wave-management.png',
      type: ContentType.video,
      tags: ['Wave Management', 'Laning', 'Tutorial'],
      publishedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    // guía de runas
    Content(
      id: '7',
      title: 'Guía completa de runas 2024',
      description: 'Todo lo que necesitas saber sobre el sistema de runas actualizado.',
      thumbnailUrl: 'assets/images/guides/runes.png',
      type: ContentType.guide,
      tags: ['Runas', 'Builds', 'Guía'],
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    // comparación macro vs micro
    Content(
      id: '8',
      title: 'Macro vs Micro: ¿Qué es más importante?',
      description: 'Análisis detallado de la importancia de la macro y micro en el juego.',
      thumbnailUrl: 'assets/images/guides/macro_micro.png',
      type: ContentType.article,
      tags: ['Macro', 'Micro', 'Análisis'],
      publishedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  /// lista filtrada según el filtro y la búsqueda actual
  List<Content> get _filteredContent {
    return _contentList.where((content) {
      // filtrar por tipo: si 'all', conservar todo; sino, comparar string del tipo del contenido
      final typeFilter = _selectedFilter == 'all' ||
                         content.type.toString().split('.').last == _selectedFilter;
      // filtrar por búsqueda en título, descripción o tags
      final searchFilter = _searchQuery.isEmpty ||
                            content.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            content.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            content.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return typeFilter && searchFilter;
    }).toList();
  }

  @override
  void dispose() {
    // liberar controlador al destruir widget
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // agrupar contenido en categorías para sección sin filtro (opcional)
    final championGuides = _contentList.where((c) => c.tags.contains('Guía de Campeón')).toList();
    final proAnalysis = _contentList.where((c) => c.tags.contains('Pro Play')).toList();
    final lowEloGuides = _contentList.where((c) => c.tags.contains('Low Elo')).toList();
    final mentalityContent = _contentList.where((c) => c.tags.contains('Mentalidad') || c.tags.contains('Tilt')).toList();
    final videoTutorials = _contentList.where((c) => c.type == ContentType.video && c.tags.contains('Tutorial')).toList();
    final runeGuides = _contentList.where((c) => c.tags.contains('Runas')).toList();
    final macroMicroGuides = _contentList.where((c) => c.tags.contains('Macro') || c.tags.contains('Micro')).toList();

    return MainLayout(
      currentIndex: 2,   // índice del menú de navegación inferior
      child: Column(
        children: [
          // encabezado con título de sección
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Contenido Gratuito',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // campo de búsqueda con ícono y botón para limpiar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar contenido...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // widget que muestra opciones de filtro (por tipo de contenido)
          ContentFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          
          // sección principal donde se muestra la lista filtrada o la cuadrícula completa
          Expanded(
            child: _searchQuery.isNotEmpty || _selectedFilter != 'all'
                ? _buildFilteredList()
                : _buildGridAll(),
          ),
        ],
      ),
    );
  }

  /// construye la vista de lista cuando hay búsqueda o filtro aplicado
  Widget _buildFilteredList() {
    if (_filteredContent.isEmpty) {
      // mostrar mensaje cuando no hay resultados
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron resultados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otra búsqueda o filtro',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // lista de tarjetas de contenido filtrado
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredContent.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final content = _filteredContent[i];
        return ContentCard(
          content: content,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ContentDetailScreen(content: content)),
          ),
        );
      },
    );
  }

  /// construye una cuadrícula que muestra todo el contenido sin filtrar
  Widget _buildGridAll() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 280 / 120,
        ),
        itemCount: _contentList.length,
        itemBuilder: (_, i) {
          final content = _contentList[i];
          return ContentCard(
            content: content,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContentDetailScreen(content: content)),
            ),
          );
        },
      ),
    );
  }
}
