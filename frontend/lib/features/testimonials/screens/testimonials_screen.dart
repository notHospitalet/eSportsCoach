import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/testimonial_provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../widgets/add_testimonial_modal.dart';
import '../../../data/providers/auth_provider.dart';
import '../widgets/testimonial_stats_card.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({Key? key}) : super(key: key);

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  // correo de administrador para mostrar controles extra
  final String adminEmail = 'adriannulero@gmail.com';

  @override
  void initState() {
    super.initState();
    // una vez que el widget se ha montado, cargamos testimonios y estadisticas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestimonialProvider>(context, listen: false).loadTestimonials();
      Provider.of<TestimonialProvider>(context, listen: false).loadTestimonialStats();
    });
  }

  // metodo para mostrar modal para agregar un testimonio
  void _showAddTestimonialModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          // ajusta el padding inferior segun teclado para que no tape el formulario
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const AddTestimonialModal(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // obtenemos el provider de testimonios y autenticacion
    final testimonialProvider = Provider.of<TestimonialProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    // determinamos si el usuario actual es administrador
    final isAdmin = authProvider.user?.email == adminEmail;

    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          // titulo de la pantalla sin fondo para integrarse al layout
          title: const Text('testimonios'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // tarjeta con estadisticas generales de testimonios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TestimonialStatsCard(
                totalTestimonials: testimonialProvider.totalApprovedTestimonials,
                averageRating: testimonialProvider.averageRating,
                isLoading: testimonialProvider.isLoading,
              ),
            ),
            // seccion principal con lista de testimonios o mensajes de error/loading
            Expanded(
              child: testimonialProvider.isLoading
                  // mostrar loader mientras carga
                  ? const Center(child: CircularProgressIndicator())
                  // si hay error, mostrar texto con detalle
                  : testimonialProvider.error != null
                      ? Center(
                          child: Text('error: ${testimonialProvider.error}'),
                        )
                      // si no hay testimonios aprobados, mostrar mensaje informativo
                      : testimonialProvider.testimonials.isEmpty
                          ? const Center(
                              child: Text(
                                'no hay testimonios aprobados disponibles en este momento o estan pendientes de aprobacion.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          // lista de testimonios aprobados
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: testimonialProvider.testimonials.length,
                              itemBuilder: (context, index) {
                                final testimonial = testimonialProvider.testimonials[index];
                                // debug: print de id y estado
                                print('testimonial id: ${testimonial.id}, isapproved: ${testimonial.isApproved}');
                                // si por alguna razon no esta aprobado (por seguridad), no mostrar
                                if (!testimonial.isApproved) return const SizedBox.shrink();

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // fila con avatar y nombre del usuario
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: testimonial.avatarUrl != null
                                                  ? NetworkImage(testimonial.avatarUrl!)
                                                  : null,
                                              backgroundColor: Colors.grey.shade300,
                                              child: testimonial.avatarUrl == null
                                                  ? Text(
                                                      testimonial.name.substring(0, 1).toUpperCase(),
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // nombre del autor
                                                Text(
                                                  testimonial.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                // fila de estrellas segun calificacion
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (starIndex) => Icon(
                                                      starIndex < testimonial.rating ? Icons.star : Icons.star_border,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // comentario del testimonio
                                        Text(
                                          testimonial.comment,
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                        // si hay informacion de rango antes y despues, mostrarla
                                        if (testimonial.initialRank != null && testimonial.currentRank != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${testimonial.initialRank} ➡️ ${testimonial.currentRank}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        // si es admin, mostrar boton para eliminar testimonio
                                        if (isAdmin)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  // llama a metodo para eliminar y muestra snackbar segun resultado
                                                  final success = await testimonialProvider.deleteTestimonial(testimonial.id);
                                                  if (success) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('testimonio eliminado')),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('error al eliminar: ${testimonialProvider.adminError}')),
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'eliminar',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
        // boton flotante para agregar nuevo testimonio
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTestimonialModal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
