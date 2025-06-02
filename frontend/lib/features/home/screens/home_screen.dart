import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../../../config/routes.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/animated_feature_card.dart';
import '../widgets/video_player_card.dart';
import 'package:provider/provider.dart';

/// Pantalla principal (Home) de la aplicación.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Controlador para el carrusel de imágenes
  final carousel.CarouselSliderController _carouselController = carousel.CarouselSliderController();

  // Índice actual del carrusel
  int _currentCarouselIndex = 0;

  // Lista de rutas de imágenes para el carrusel hero
  final List<String> _carouselImages = [
    'assets/images/imagen1.jpg',
    'assets/images/imagen2.jpg',
    'assets/images/imagen3.jpg',
    'assets/images/carousel4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador de animaciones para los elementos que entran con transición
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward(); // Iniciamos la animación
  }

  @override
  void dispose() {
    _animationController.dispose(); // Liberamos recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el proveedor de autenticación para saber si el usuario está logueado
    final authProvider = Provider.of<AuthProvider>(context);

    // Detectamos el tamaño de la pantalla para adaptar el diseño (responsive)
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return MainLayout(
      currentIndex: 0, // Índice activo en el menú inferior
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior con logo y acciones de usuario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Logo de la app
                  Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.sports_esports, size: 40), // Icono alternativo si falla la carga
                  ),
                  const Spacer(),
                  // Botón de notificaciones (aún sin implementar)
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  // Si el usuario está autenticado, mostramos icono de perfil; en caso contrario, botón de Iniciar Sesión
                  authProvider.isAuthenticated
                      ? IconButton(
                          icon: const Icon(Icons.person_outline),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.profile);
                          },
                        )
                      : TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: const Text('Iniciar Sesión'),
                        ),
                ],
              ),
            ),

            // Sección Hero con texto y carrusel de imágenes
            Container(
              padding: const EdgeInsets.all(24),
              child: isLargeScreen
                  // Si la pantalla es amplia, mostramos en fila: texto a la izquierda, carrusel a la derecha
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildHeroContent(), // Contenido de texto animado
                        ),
                        Expanded(
                          flex: 7,
                          child: _buildCarousel(), // Carrusel de imágenes
                        ),
                      ],
                    )
                  // Si la pantalla es pequeña, mostramos en columna: texto encima, carrusel debajo
                  : Column(
                      children: [
                        _buildHeroContent(),
                        const SizedBox(height: 24),
                        _buildCarousel(),
                      ],
                    ),
            ),

            // Sección de video de presentación (Conoce a tu coach)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conoce a tu coach',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tarjeta que muestra un reproductor de video (miniatura y botón de play)
                  const VideoPlayerCard(
                    videoUrl: 'https://example.com/intro-video.mp4',
                    thumbnailUrl: 'assets/images/imagen2.jpg',
                    height: 240,
                  ),
                  const SizedBox(height: 16),
                  // Descripción breve del coach
                  Text(
                    'Soy Carlos Martínez, coach profesional de League of Legends con más de 5 años de experiencia. He ayudado a cientos de jugadores a mejorar sus habilidades y alcanzar sus objetivos en el juego. Mi enfoque se basa en identificar tus fortalezas y debilidades para crear un plan de entrenamiento personalizado.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Sección de servicios destacados
            Container(
              padding: const EdgeInsets.all(24),
              // Diferente color de fondo según el tema
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFF2F2F7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Servicios destacados',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Grid de tarjetas animadas con las características principales
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isLargeScreen ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                    children: [
                      // Tarjeta animada para sesión individual
                      AnimatedFeatureCard(
                        title: 'Sesión individual',
                        description: 'Análisis personalizado de tus partidas',
                        icon: Icons.person,
                        delay: 0,
                        controller: _animationController,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                      ),
                      // Tarjeta animada para plan mensual
                      AnimatedFeatureCard(
                        title: 'Plan mensual',
                        description: 'Seguimiento continuo de tu progreso',
                        icon: Icons.calendar_month,
                        delay: 0.2,
                        controller: _animationController,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                      ),
                      // Tarjeta animada para coaching de equipos
                      AnimatedFeatureCard(
                        title: 'Coaching para equipos',
                        description: 'Mejora la sinergia y estrategia de tu equipo',
                        icon: Icons.groups,
                        delay: 0.4,
                        controller: _animationController,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Botón para ir a la lista completa de servicios
                  Center(
                    child: CustomButton(
                      text: 'Ver todos los servicios',
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
                      type: ButtonType.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Sección de llamada a la acción (CTA) con fondo degradado
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withAlpha(204),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '¿Listo para llevar tu juego al siguiente nivel?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reserva una sesión gratuita de 30 minutos para conocernos y discutir tus objetivos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón para reservar sesión gratuita
                      CustomButton(
                        text: 'Reservar sesión gratuita',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.contact),
                        type: ButtonType.secondary,
                      ),
                      const SizedBox(width: 16),
                      // Botón para ver servicios
                      CustomButton(
                        text: 'Ver servicios',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
                        type: ButtonType.outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sección de testimonios con carrusel
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lo que dicen mis alumnos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Enlace para ver todos los testimonios
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.testimonials),
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTestimonialCarousel(), // Carrusel de tarjetas de testimonios
                ],
              ),
            ),

            // Footer con enlaces rápidos
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFF2F2F7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Enlaces de footer (Iniciar sesión, Registrarse, Testimonios, Contacto)
                      _buildFooterLink(
                        context,
                        'Iniciar sesión',
                        Icons.login,
                        () => Navigator.pushNamed(context, AppRoutes.login),
                      ),
                      _buildFooterLink(
                        context,
                        'Registrarse',
                        Icons.person_add,
                        () => Navigator.pushNamed(context, AppRoutes.register),
                      ),
                      _buildFooterLink(
                        context,
                        'Testimonios',
                        Icons.star,
                        () => Navigator.pushNamed(context, AppRoutes.testimonials),
                      ),
                      _buildFooterLink(
                        context,
                        'Contacto',
                        Icons.email,
                        () => Navigator.pushNamed(context, AppRoutes.contact),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '© 2023 eSports Coach. Todos los derechos reservados.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el contenido del hero con texto y botones animados.
  Widget _buildHeroContent() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.5, 0), // Empieza desde la izquierda
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0, 0.8, curve: Curves.easeOut),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LLEVA TU JUEGO AL SIGUIENTE NIVEL',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Coaching personalizado para jugadores de League of Legends que quieren mejorar y alcanzar sus objetivos',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Botón principal para reservar sesión
                CustomButton(
                  text: 'Reservar sesión',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.contact),
                  type: ButtonType.primary,
                ),
                const SizedBox(width: 16),
                // Botón secundario para ver servicios
                CustomButton(
                  text: 'Ver servicios',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
                  type: ButtonType.outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el carrusel de imágenes principal en el hero.
  Widget _buildCarousel() {
    return Column(
      children: [
        carousel.CarouselSlider(
          carouselController: _carouselController,
          options: carousel.CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true, // Avanza automáticamente
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index; // Actualiza indicador
              });
            },
          ),
          items: _carouselImages.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      image, // Imagen local
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Indicadores (puntos) del carrusel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withAlpha(
                    _currentCarouselIndex == entry.key ? 255 : 102,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Construye el carrusel de testimonios con contenido de ejemplo.
  Widget _buildTestimonialCarousel() {
    return carousel.CarouselSlider(
      options: carousel.CarouselOptions(
        height: 200,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 2.0,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2C2C2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/imagen3.jpg'),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Usuario 1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            // Estrellas de calificación
                            Row(
                              children: List.generate(5, (index) {
                                return const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Las sesiones de coaching me ayudaron a subir de rango rápidamente. El coach identificó mis errores y me dio estrategias claras para mejorar.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis, // Texto recortado si es muy largo
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// Construye un enlace en el footer con icono y texto.
  Widget _buildFooterLink(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
