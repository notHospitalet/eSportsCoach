import 'package:flutter/material.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/coach_profile.dart';
import '../widgets/achievement_card.dart';
import '../widgets/collaboration_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// pantalla "sobre mi" que muestra informacion del coach, historia, alianzas y filosofia
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  /// funcion para abrir URL externas (email, instagram, twitch, twitter)
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 4, // indice del menu para resaltar "sobre mi"
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // encabezado con titulo de la seccion
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'sobre mi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // banner de perfil con gradiente de fondo y datos del coach
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
              child: Column(
                children: [
                  // widget personalizado que muestra foto, nombre y detalles
                  const CoachProfile(
                    name: 'adrian "hospitalet"',
                    title: 'fundador | visionario de esports | constructor de sueños colectivos',
                    imageUrl: 'https://via.placeholder.com/150',
                    rank: 'fundador',
                    experience: 'creador de equipos',
                  ),
                  const SizedBox(height: 16),
                  // botones sociales debajo del perfil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.email, 'email', () => _launchURL('mailto:adriannulero@gmail.com')),
                      _buildSocialButton(Icons.camera_alt, 'instagram', () => _launchURL('https://www.instagram.com/adry06')),
                      _buildSocialButton(Icons.sports_esports, 'twitch', () => _launchURL('https://www.twitch.tv/nothospitalet')),
                      _buildSocialButton(Icons.person, 'twitter', () => _launchURL('https://twitter.com/nothospitalet')),
                    ],
                  ),
                ],
              ),
            ),
            
            // seccion de historia y experiencia con bloques de texto
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // titulo de la historia
                  const Text(
                    'mi historia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // parrafo narrativo sobre el origen y vision del coach
                  const Text(
                    'en un mundo donde los equipos amateur sueñan en grande pero tropiezan con límites invisibles, hospitalet no ve barreras: ve puentes por construir. creador de su sección de league of legends y arquitecto del team, adrián no dirige un equipo; encabeza una revolución silenciosa en el circuito tormenta español. su arma secreta no es un mouse ni un teclado, sino una convicción férrea: el talento no se mide por los recursos, sino por las oportunidades que se crean.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // segundo parrafo describiendo el proyecto de coaching
                  const Text(
                    '¿su nuevo proyecto? una plataforma/app de coaching diseñada para romper el ciclo de estancamiento amateur. pero esto no es un proyecto en solitario. es un ecosistema colaborativo, donde adrián une fuerzas con coaches profesionales —héroes anónimos del mundo amateur— para convertir su conocimiento en herramientas accesibles. ellos aportan la sabiduría de las trincheras; él, la infraestructura para que esa sabiduría llegue más lejos.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // titulo de alianzas estrategicas
                  const Text(
                    'alianzas estratégicas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'aquí no hay jerarquías, hay aliados:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // tarjetas de logros convertidas en puntos clave
                  const AchievementCard(
                    title: 'hospitalet forja el camino',
                    description: 'diseña la plataforma, teje alianzas y asegura que cada recurso tenga un propósito.',
                    icon: Icons.architecture,
                  ),
                  const SizedBox(height: 12),
                  const AchievementCard(
                    title: 'los coaches iluminan la ruta',
                    description: 'sus análisis, estrategias y mentorías son el alma del contenido.',
                    icon: Icons.lightbulb,
                  ),
                  const SizedBox(height: 12),
                  const AchievementCard(
                    title: 'juntos, transforman "podría ser" en "es posible"',
                    description: 'una colaboración que redefine los límites del circuito amateur.',
                    icon: Icons.handshake,
                  ),
                  
                  const SizedBox(height: 32),
                  // seccion de taller de sueños competitivos
                  const Text(
                    'taller de sueños competitivos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'esta no es una app cualquiera. es un taller de sueños competitivos, donde:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // tarjetas que representan colaboraciones en el taller
                  const CollaborationCard(
                    name: 'análisis de replays',
                    role: 'semillas de mejora',
                    imageUrl: 'https://via.placeholder.com/100',
                    description: 'cada replay analizado es una oportunidad para crecer y evolucionar como jugador.',
                  ),
                  const SizedBox(height: 12),
                  const CollaborationCard(
                    name: 'guías estratégicas',
                    role: 'mapas hacia la excelencia',
                    imageUrl: 'https://via.placeholder.com/100',
                    description: 'contenido creado por coaches que ilumina el camino hacia el siguiente nivel.',
                  ),
                  const SizedBox(height: 12),
                  const CollaborationCard(
                    name: 'redefinición del potencial',
                    role: 'más allá del elo',
                    imageUrl: 'https://via.placeholder.com/100',
                    description: 'cada jugador que usa la plataforma no solo sube de rango, redefine lo que creía capaz de lograr.',
                  ),
                  
                  const SizedBox(height: 24),
                  // cita destacada sobre filosofía de competición
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '"no nos conformamos con ganar partidas. queremos demostrar que, incluso en el circuito amateur, se puede competir con la precisión de un reloj suizo y el corazón de un titán."',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // seccion de filosofia radical con pilares de coaching
                  const Text(
                    'filosofía radical',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // cada pilar de coaching con icono, titulo y descripcion
                  _buildCoachingPillar(
                    context,
                    'construye tus herramientas',
                    '"si el sistema no te da herramientas, constrúyelas. si el camino no existe, abre brecha."',
                    Icons.build,
                  ),
                  const SizedBox(height: 16),
                  _buildCoachingPillar(
                    context,
                    'potencia humana',
                    'la tecnología no reemplaza al humano: potencia su voz, multiplica su impacto.',
                    Icons.people,
                  ),
                  const SizedBox(height: 16),
                  _buildCoachingPillar(
                    context,
                    'éxito colectivo',
                    'nadie triunfa solo: aquí, cada coach, jugador y línea de código suma.',
                    Icons.group_work,
                  ),
                  
                  const SizedBox(height: 24),
                  // bloque final con manifiesto del proyecto
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'el #proyectohospitalet no es una página web ni una app. es un manifiesto en acción, un recordatorio de que los esports no son solo para gigantes con patrocinios millonarios. es para los que creen que una idea, un equipo y un propósito claro pueden cambiar las reglas del juego.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'la huella que quiero dejar no es la de un genio solitario, sino la de alguien que supo escuchar, aprender y poner en pie sistemas que perduren cuando yo ya no esté. el amateur merece herramientas serias… y mi misión es que nadie vuelva a ver la cumbre como un privilegio, sino como un destino al que todos pueden llegar, armados con lo que construimos juntos.',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '— adrián "hospitalet"',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // botones de llamada a la accion: contacto y servicios
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'sé parte del cambio',
                          onPressed: () {
                            Navigator.pushNamed(context, '/contact');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'conecta con los coaches',
                          onPressed: () {
                            Navigator.pushNamed(context, '/services');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// construye un boton social con icono, texto y accion onTap
  Widget _buildSocialButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// construye un contenedor tipo tarjeta para cada pilar de coaching
  /// - icono grande a la izquierda
  /// - titulo en negrita y descripcion debajo
  Widget _buildCoachingPillar(BuildContext context, String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
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
