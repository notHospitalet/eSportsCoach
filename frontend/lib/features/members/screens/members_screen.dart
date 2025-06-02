import 'package:flutter/material.dart';
import '../widgets/membership_plan_card.dart';
import '../widgets/member_benefit_item.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar con el titulo de la pantalla de miembros
      appBar: AppBar(
        title: const Text('zona de miembros'),
      ),
      body: SingleChildScrollView(
        // contenido desplazable en caso de que exceda el alto de la pantalla
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // banner superior con fondo degradado para destacar la zona premium
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
                    'zona de miembros premium',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'accede a contenido exclusivo y beneficios especiales',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // seccion de beneficios para miembros con padding alrededor
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'beneficios de ser miembro',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // cada elemento de beneficio se representa con memberbenefititem
                  const MemberBenefitItem(
                    icon: Icons.video_library,
                    title: 'contenido exclusivo',
                    description:
                        'accede a guias, analisis y videos que solo estan disponibles para miembros',
                  ),
                  const SizedBox(height: 12),
                  const MemberBenefitItem(
                    icon: Icons.discount,
                    title: 'descuentos en servicios',
                    description:
                        'obten un 15% de descuento en todas las sesiones de coaching individuales',
                  ),
                  const SizedBox(height: 12),
                  const MemberBenefitItem(
                    icon: Icons.priority_high,
                    title: 'prioridad en reservas',
                    description:
                        'reserva sesiones con prioridad sobre usuarios no premium',
                  ),
                  const SizedBox(height: 12),
                  const MemberBenefitItem(
                    icon: Icons.groups,
                    title: 'comunidad exclusiva',
                    description:
                        'unete a nuestra comunidad de discord exclusiva para miembros',
                  ),
                  const SizedBox(height: 12),
                  const MemberBenefitItem(
                    icon: Icons.live_tv,
                    title: 'sesiones grupales en vivo',
                    description:
                        'participa en sesiones grupales semanales con nuestros coaches',
                  ),

                  const SizedBox(height: 32),

                  // seccion de planes de membresia con subtitulo
                  const Text(
                    'planes de membresia',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // tarjeta de plan mensual, no recomendado
                  MembershipPlanCard(
                    title: 'plan mensual',
                    price: 9.99,
                    period: 'mes',
                    features: const [
                      'acceso a todo el contenido premium',
                      'descuentos en servicios',
                      'comunidad exclusiva',
                    ],
                    isRecommended: false,
                    onSubscribe: () {
                      _showSubscriptionDialog(context, 'mensual', 9.99);
                    },
                  ),
                  const SizedBox(height: 16),

                  // tarjeta de plan trimestral, marcado como recomendado
                  MembershipPlanCard(
                    title: 'plan trimestral',
                    price: 24.99,
                    period: 'trimestre',
                    features: const [
                      'todo lo del plan mensual',
                      'sesion individual gratuita',
                      'prioridad en reservas',
                    ],
                    isRecommended: true,
                    onSubscribe: () {
                      _showSubscriptionDialog(context, 'trimestral', 24.99);
                    },
                  ),
                  const SizedBox(height: 16),

                  // tarjeta de plan anual, sin recomendacion
                  MembershipPlanCard(
                    title: 'plan anual',
                    price: 89.99,
                    period: 'año',
                    features: const [
                      'todo lo del plan trimestral',
                      'tres sesiones individuales gratuitas',
                      'acceso a sesiones grupales en vivo',
                    ],
                    isRecommended: false,
                    onSubscribe: () {
                      _showSubscriptionDialog(context, 'anual', 89.99);
                    },
                  ),

                  const SizedBox(height: 32),

                  // seccion de preguntas frecuentes (faq) con subtitulo
                  const Text(
                    'preguntas frecuentes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // cada item de faq se construye con el helper _buildFaqItem
                  _buildFaqItem(
                    context,
                    '¿puedo cancelar mi suscripcion en cualquier momento?',
                    'si, puedes cancelar tu suscripcion en cualquier momento. seguiras teniendo acceso a los beneficios hasta el final del periodo pagado',
                  ),
                  _buildFaqItem(
                    context,
                    '¿como accedo al contenido premium?',
                    'una vez que te suscribas, podras acceder a todo el contenido premium desde la seccion "contenido" de la aplicacion',
                  ),
                  _buildFaqItem(
                    context,
                    '¿las sesiones gratuitas caducan?',
                    'las sesiones gratuitas incluidas en los planes trimestral y anual deben utilizarse dentro del periodo de suscripcion',
                  ),
                  _buildFaqItem(
                    context,
                    '¿que metodos de pago aceptan?',
                    'aceptamos tarjetas de credito/debito (visa, mastercard, american express) y paypal',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// construye un item de faq con expansiontile para mostrar la respuesta al expandir
  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// muestra un dialogo de confirmacion al suscribirse a un plan
  void _showSubscriptionDialog(BuildContext context, String planType, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('suscripcion al plan $planType'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // ajusta el alto al contenido
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('estas a punto de suscribirte al plan $planType por \$${price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'esta es una simulacion. en una aplicacion real, aqui se procesaria el pago',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // cierra el dialogo
            },
            child: const Text('cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // cierra el dialogo
              // muestra un snackbar de exito al confirmar la suscripcion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡suscripcion realizada con exito!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('confirmar'),
          ),
        ],
      ),
    );
  }
}
