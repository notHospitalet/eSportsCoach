import 'package:flutter/material.dart';
import '../../../data/models/service_model.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/service_card.dart';
import '../widgets/service_filter.dart';
import '../widgets/service_detail_modal.dart';
import '../widgets/service_category_header.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // variable para almacenar el filtro seleccionado (por defecto 'all')
  String _selectedFilter = 'all';
  
  // datos de ejemplo para los servicios
  final List<Service> _services = [
    // sesiones individuales
    Service(
      id: '1',
      title: 'análisis de partidas (vod review)',
      description: 'revisión detallada de tus partidas para identificar errores y areas de mejora.',
      price: 29.99,
      type: ServiceType.individual,
      features: ['60 minutos', 'análisis detallado', 'feedback personalizado', 'notas de la sesión'],
      durationMinutes: 60,
      isPopular: true,
    ),
    Service(
      id: '2',
      title: 'juego en dúo + feedback',
      description: 'juega conmigo y recibe feedback en tiempo real mientras jugamos juntos.',
      price: 39.99,
      type: ServiceType.individual,
      features: ['90 minutos', 'feedback en tiempo real', 'análisis post-partida', 'consejos personalizados'],
      durationMinutes: 90,
    ),
    Service(
      id: '3',
      title: 'mejora de rol específico',
      description: 'sesión enfocada en mejorar tu desempeño en un rol específico (top, jungle, mid, adc, support).',
      price: 34.99,
      type: ServiceType.individual,
      features: ['75 minutos', 'enfoque en un rol', 'estrategias específicas', 'recomendacion de campeones'],
      durationMinutes: 75,
    ),
    
    // planes mensuales
    Service(
      id: '4',
      title: 'plan mensual básico',
      description: 'seguimiento semanal de tu progreso con objetivos personalizados.',
      price: 79.99,
      type: ServiceType.monthly,
      features: ['4 sesiones al mes', 'acceso a comunidad', 'estadisticas de progreso', 'ejercicios semanales'],
      durationMinutes: 240,
    ),
    Service(
      id: '5',
      title: 'plan mensual intermedio',
      description: 'coaching intensivo con sesiones semanales y seguimiento personalizado.',
      price: 129.99,
      type: ServiceType.monthly,
      features: ['6 sesiones al mes', 'acceso a comunidad vip', 'estadisticas detalladas', 'plan de mejora personalizado'],
      durationMinutes: 360,
      isPopular: true,
    ),
    Service(
      id: '6',
      title: 'plan mensual avanzado',
      description: 'coaching premium con sesiones frecuentes y atencion prioritaria.',
      price: 199.99,
      type: ServiceType.monthly,
      features: ['8 sesiones al mes', 'acceso a comunidad vip', 'análisis detallado', 'contacto directo 24/7'],
      durationMinutes: 480,
    ),
    
    // cursos grabados
    Service(
      id: '7',
      title: 'curso: domina el top lane',
      description: 'aprende todas las estrategias y campeones para dominar el carril superior.',
      price: 49.99,
      type: ServiceType.course,
      features: ['10 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'comunidad de estudiantes'],
      durationMinutes: 300,
    ),
    Service(
      id: '8',
      title: 'curso: domina el jungle',
      description: 'aprende a controlar la jungla y tener impacto en todas las lineas.',
      price: 49.99,
      type: ServiceType.course,
      features: ['10 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'comunidad de estudiantes'],
      durationMinutes: 300,
    ),
    Service(
      id: '9',
      title: 'curso: domina el mid lane',
      description: 'aprende todas las estrategias y campeones para dominar el carril central.',
      price: 49.99,
      type: ServiceType.course,
      features: ['10 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'comunidad de estudiantes'],
      durationMinutes: 300,
    ),
    Service(
      id: '10',
      title: 'curso: domina el adc',
      description: 'aprende a posicionarte correctamente y maximizar tu daño como adc.',
      price: 49.99,
      type: ServiceType.course,
      features: ['10 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'comunidad de estudiantes'],
      durationMinutes: 300,
    ),
    Service(
      id: '11',
      title: 'curso: domina el support',
      description: 'aprende a proteger a tu adc y tener impacto en todo el mapa.',
      price: 49.99,
      type: ServiceType.course,
      features: ['10 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'comunidad de estudiantes'],
      durationMinutes: 300,
    ),
    
    // guías
    Service(
      id: '12',
      title: 'guía: control de oleadas',
      description: 'aprende a controlar las oleadas de minions para obtener ventaja en la linea.',
      price: 19.99,
      type: ServiceType.guide,
      features: ['5 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'ejemplos detallados'],
      durationMinutes: 120,
    ),
    Service(
      id: '13',
      title: 'guía: visión y control de mapa',
      description: 'aprende a utilizar la visión para controlar objetivos y evitar emboscadas.',
      price: 19.99,
      type: ServiceType.guide,
      features: ['5 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'ejemplos detallados'],
      durationMinutes: 120,
    ),
    Service(
      id: '14',
      title: 'guía: toma de decisiones',
      description: 'mejora tu toma de decisiones en momentos críticos de la partida.',
      price: 19.99,
      type: ServiceType.guide,
      features: ['5 lecciones', 'acceso de por vida', 'ejercicios prácticos', 'ejemplos detallados'],
      durationMinutes: 120,
    ),
    
    // coaching para equipos
    Service(
      id: '15',
      title: 'coaching para equipos',
      description: 'mejora la sinergia y estrategia de tu equipo con sesiones grupales.',
      price: 99.99,
      type: ServiceType.team,
      features: ['90 minutos', 'para 5 jugadores', 'estrategias de equipo', 'análisis de scrims'],
      durationMinutes: 90,
      isPopular: true,
    ),
    Service(
      id: '16',
      title: 'análisis de partidas para equipos',
      description: 'revisión detallada de las partidas de tu equipo para identificar errores y mejorar la coordinación.',
      price: 79.99,
      type: ServiceType.team,
      features: ['60 minutos', 'para 5 jugadores', 'análisis detallado', 'feedback personalizado'],
      durationMinutes: 60,
    ),
  ];

  // getter que devuelve la lista de servicios filtrada
  List<Service> get _filteredServices {
    if (_selectedFilter == 'all') {
      return _services;
    } else {
      return _services.where((service) {
        // comparar el tipo del servicio con el filtro (se extrae la parte despues del punto)
        return service.type.toString().split('.').last == _selectedFilter;
      }).toList();
    }
  }

  // funcion para mostrar el modal con los detalles del servicio
  void _showServiceDetails(Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailModal(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    // agrupar servicios por tipo para listar en secciones
    final individualServices = _services.where((s) => s.type == ServiceType.individual).toList();
    final monthlyServices = _services.where((s) => s.type == ServiceType.monthly).toList();
    final courseServices = _services.where((s) => s.type == ServiceType.course).toList();
    final guideServices = _services.where((s) => s.type == ServiceType.guide).toList();
    final teamServices = _services.where((s) => s.type == ServiceType.team).toList();

    return MainLayout(
      currentIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // barra superior con el titulo de la pantalla
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'servicios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // banner informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'servicios de coaching',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'encuentra el servicio perfecto para mejorar tu juego y alcanzar tus objetivos',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // widget de filtros
          ServiceFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          
          // lista de servicios filtrados o agrupados
          Expanded(
            child: _selectedFilter != 'all'
                ? _buildFilteredServicesList()
                : _buildCategorizedServicesList(
                    individualServices,
                    monthlyServices,
                    courseServices,
                    guideServices,
                    teamServices,
                  ),
          ),
        ],
      ),
    );
  }

  // construye la lista si hay un filtro activo (no 'all')
  Widget _buildFilteredServicesList() {
    return _filteredServices.isEmpty
        // si no hay resultados, mostrar mensaje
        ? const Center(
            child: Text(
              'no hay servicios disponibles en esta categoría',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: _filteredServices[index],
                onTap: () => _showServiceDetails(_filteredServices[index]),
                onBookNow: () {
                  // navegar a la pantalla de contacto para reservar
                  Navigator.pushNamed(context, '/contact');
                },
              );
            },
          );
  }

  // construye la lista de servicios agrupados por categorias
  Widget _buildCategorizedServicesList(
    List<Service> individualServices,
    List<Service> monthlyServices,
    List<Service> courseServices,
    List<Service> guideServices,
    List<Service> teamServices,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // sesion individual
        const ServiceCategoryHeader(
          title: 'sesiones individuales',
          icon: Icons.person,
          description: 'sesiones personalizadas para mejorar aspectos específicos de tu juego',
        ),
        const SizedBox(height: 16),
        // mapear cada servicio individual a un ServiceCard
        ...individualServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            service: service,
            onTap: () => _showServiceDetails(service),
            onBookNow: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        )),
        
        const SizedBox(height: 24),
        
        // planes mensuales
        const ServiceCategoryHeader(
          title: 'planes mensuales',
          icon: Icons.calendar_month,
          description: 'seguimiento continuo para un progreso constante y sostenido',
        ),
        const SizedBox(height: 16),
        ...monthlyServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            service: service,
            onTap: () => _showServiceDetails(service),
            onBookNow: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        )),
        
        const SizedBox(height: 24),
        
        // cursos grabados
        const ServiceCategoryHeader(
          title: 'cursos grabados',
          icon: Icons.video_library,
          description: 'aprende a tu propio ritmo con nuestros cursos completos por rol',
        ),
        const SizedBox(height: 16),
        ...courseServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            service: service,
            onTap: () => _showServiceDetails(service),
            onBookNow: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        )),
        
        const SizedBox(height: 24),
        
        // guias
        const ServiceCategoryHeader(
          title: 'guias de conceptos',
          icon: Icons.menu_book,
          description: 'guias detalladas sobre conceptos fundamentales del juego',
        ),
        const SizedBox(height: 16),
        ...guideServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            service: service,
            onTap: () => _showServiceDetails(service),
            onBookNow: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        )),
        
        const SizedBox(height: 24),
        
        // coaching para equipos
        const ServiceCategoryHeader(
          title: 'coaching para equipos',
          icon: Icons.groups,
          description: 'mejora la sinergia y estrategia de tu equipo',
        ),
        const SizedBox(height: 16),
        ...teamServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            service: service,
            onTap: () => _showServiceDetails(service),
            onBookNow: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        )),
      ],
    );
  }
}
