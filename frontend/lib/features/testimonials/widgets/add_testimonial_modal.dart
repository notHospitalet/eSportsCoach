import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/testimonial_model.dart';
import '../../../data/providers/testimonial_provider.dart';
import '../../../core/constants/ranks.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

class AddTestimonialModal extends StatefulWidget {
  const AddTestimonialModal({Key? key}) : super(key: key);

  @override
  State<AddTestimonialModal> createState() => _AddTestimonialModalState();
}

class _AddTestimonialModalState extends State<AddTestimonialModal> {
  // clave para validar el formulario
  final _formKey = GlobalKey<FormState>();
  // controladores para campos de texto
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  
  // valor inicial de calificacion
  double _rating = 5.0;
  // rangos opcionales
  String? _initialRank;
  String? _currentRank;
  // indicador de estado de envio
  bool _isSubmitting = false;

  @override
  void dispose() {
    // liberar recursos de controladores al destruir el widget
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitTestimonial() {
    // validar formulario antes de continuar
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      // indicar que se esta enviando
      _isSubmitting = true;
    });

    // crear objeto Testimonial con id temporal (backend lo reemplazara)
    final testimonial = Testimonial(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      comment: _commentController.text.trim(),
      rating: _rating,
      initialRank: _initialRank,
      currentRank: _currentRank,
      date: DateTime.now(),
    );

    // usar provider para agregar el testimonio
    context.read<TestimonialProvider>().addTestimonial(testimonial).then((success) {
      if (mounted) {
        // cerrar el modal
        Navigator.of(context).pop();
        // mostrar mensaje segun exito o error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
              ? '¡testimonio enviado! sera revisado antes de publicarse.' 
              : 'error al enviar testimonio. intenta de nuevo.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }).catchError((e) {
      if (mounted) {
        // mostrar snackbar si ocurre error inesperado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error al enviar testimonio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          // reestablecer estado de envio
          _isSubmitting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // borde redondeado para el dialogo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        // limitar ancho maximo para dispositivos grandes
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              // ajustar tamanio segun contenido
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // encabezado con titulo y boton de cerrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'añadir testimonio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // campo para nombre del usuario
                CustomTextField(
                  controller: _nameController,
                  label: 'tu nombre',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // campo para comentario o experiencia del usuario
                CustomTextField(
                  controller: _commentController,
                  label: 'tu experiencia',
                  maxLines: 4,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'por favor comparte tu experiencia';
                    }
                    if (value!.length < 20) {
                      return 'el comentario debe tener al menos 20 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // seccion para calificacion con slider
                const Text(
                  'calificacion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 8, // permitir medias estrellas
                        label: _rating.toString(),
                        onChanged: (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                    ),
                    // contenedor que muestra valor numerico de la calificacion
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // seleccion de rank inicial y actual (opcional)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'rank inicial (opcional)',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _initialRank,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'seleccionar',
                            ),
                            // cargar lista de rangos desde constante
                            items: RankConstants.allRanks.map((rank) {
                              return DropdownMenuItem(
                                value: rank,
                                child: Text(rank),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _initialRank = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'rank actual (opcional)',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _currentRank,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'seleccionar',
                            ),
                            items: RankConstants.allRanks.map((rank) {
                              return DropdownMenuItem(
                                value: rank,
                                child: Text(rank),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _currentRank = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // nota informativa sobre el proceso de revison
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withAlpha(76)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'tu testimonio sera revisado antes de publicarse publicamente.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // fila con botones de cancelar y enviar
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('cancelar'),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: _isSubmitting ? 'enviando...' : 'enviar testimonio',
                      onPressed: () => _submitTestimonial(),
                      isLoading: _isSubmitting,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
