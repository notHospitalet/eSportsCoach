import 'package:flutter/material.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/contact_info_card.dart';

/// pantalla de contacto y reservas:
/// muestra un banner con opciones para cambiar entre formulario de contacto y de reserva,
/// muestra informacion de contacto o formulario de contacto, y si se activa, muestra formulario de reserva
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // clave para el formulario de contacto
  final _formKey = GlobalKey<FormState>();

  // controladores de texto para nombre, email y mensaje
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  // variables para gestionar seleccion de fecha, hora y servicio en el formulario de reserva
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedService;
  
  // estado de carga y flag para mostrar formulario de reserva
  bool _isLoading = false;
  bool _showBookingForm = false;
  
  // lista de horarios disponibles para reserva
  final List<String> _availableTimes = [
    '09:00', '10:00', '11:00', '12:00', '15:00', '16:00', '17:00', '18:00',
  ];
  
  // lista de servicios disponibles para reserva
  final List<String> _availableServices = [
    'Sesión individual',
    'Plan mensual básico',
    'Plan mensual premium',
    'Coaching para equipos',
  ];

  @override
  void dispose() {
    // liberar recursos de controladores de texto
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// alterna entre mostrar formulario de contacto y formulario de reserva
  void _toggleBookingForm() {
    setState(() {
      _showBookingForm = !_showBookingForm;
    });
  }

  /// guarda la fecha seleccionada en el estado
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  /// guarda la hora seleccionada en el estado
  void _selectTime(String time) {
    setState(() {
      _selectedTime = time;
    });
  }

  /// guarda el servicio seleccionado en el estado
  void _selectService(String service) {
    setState(() {
      _selectedService = service;
    });
  }

  /// simula envio del formulario de contacto
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // simulacion de delay de envio
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // muestra snackbar de exito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensaje enviado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // limpiar campos del formulario
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    }
  }

  /// simula envio del formulario de reserva
  Future<void> _submitBooking() async {
    // verificar que se hayan completado todos los campos requeridos
    if (_selectedDate != null && _selectedTime != null && _selectedService != null) {
      setState(() {
        _isLoading = true;
      });

      // simulacion de delay de reserva
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // muestra snackbar de exito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reserva realizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // limpiar seleccion y ocultar formulario de reserva
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _selectedService = null;
          _showBookingForm = false;
        });
      }
    } else {
      // si faltan campos, muestra snackbar de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 5, // indice del menu
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cabecera con titulo de la pantalla
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Contacto',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // banner superior con botones para cambiar entre secciones
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contacto y Reservas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ponte en contacto con nosotros o reserva una sesión de coaching',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // boton para mostrar formulario de contacto
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showBookingForm = false;
                            });
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Contacto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showBookingForm
                                ? Colors.white.withAlpha(51)
                                : Colors.white,
                            foregroundColor: _showBookingForm
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // boton para mostrar formulario de reserva
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleBookingForm,
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Reservar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showBookingForm
                                ? Colors.white
                                : Colors.white.withAlpha(51),
                            foregroundColor: _showBookingForm
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // seccion de informacion de contacto y formulario de mensaje
            if (!_showBookingForm) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información de contacto',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // tarjetas con datos de contacto (email, discord)
                    const Row(
                      children: [
                        Expanded(
                          child: ContactInfoCard(
                            icon: Icons.email,
                            title: 'Email',
                            content: 'adriannulero@gmail.com',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ContactInfoCard(
                            icon: Icons.discord,
                            title: 'Discord',
                            content: 'hospitalet',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // tarjetas con datos de contacto (twitter, horario)
                    const Row(
                      children: [
                        Expanded(
                          child: ContactInfoCard(
                            icon: Icons.person,
                            title: 'Twitter',
                            content: '@notHospitalet',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ContactInfoCard(
                            icon: Icons.schedule,
                            title: 'Horario',
                            content: 'Lun-Vie: 9am - 8pm',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    const Text(
                      'Envíanos un mensaje',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // formulario de contacto con validaciones
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: 'Nombre',
                            hint: 'Tu nombre',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Email',
                            hint: 'tu@email.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Por favor, ingresa un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Mensaje',
                            hint: 'Escribe tu mensaje aquí...',
                            controller: _messageController,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu mensaje';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Enviar Mensaje',
                            onPressed: _submitForm,
                            isLoading: _isLoading,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // seccion de formulario de reserva de sesion
            if (_showBookingForm) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reserva una sesión',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // formulario compacto de reserva
                    Form(
                      key: GlobalKey<FormState>(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // campo para nombre completo
                          CustomTextField(
                            label: 'Nombre completo',
                            hint: 'Tu nombre completo',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // campo para correo electronico
                          CustomTextField(
                            label: 'Correo electrónico',
                            hint: 'tu@email.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Por favor, ingresa un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          const Text(
                            'Servicio',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // dropdown para seleccionar servicio
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2C2C2E)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedService,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              hint: const Text('Selecciona un servicio'),
                              items: _availableServices.map((service) {
                                return DropdownMenuItem<String>(
                                  value: service,
                                  child: Text(service),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _selectService(value);
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          const Text(
                            'Fecha preferida',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // widget para seleccionar fecha con showDatePicker
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(const Duration(days: 1)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 90)),
                                selectableDayPredicate: (DateTime date) {
                                  // por defecto, deshabilita domingos
                                  return date.weekday != 7;
                                },
                              );
                              if (picked != null) {
                                _selectDate(picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2C2C2E)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedDate != null
                                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                        : 'Selecciona una fecha',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedDate != null
                                          ? Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // si hay fecha seleccionada, mostrar dropdown de horarios disponibles
                          if (_selectedDate != null) ...[
                            const Text(
                              'Horario preferido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2C2C2E)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedTime,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                hint: const Text('Selecciona un horario'),
                                items: _availableTimes.map((time) {
                                  return DropdownMenuItem<String>(
                                    value: time,
                                    child: Text(time),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    _selectTime(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // campo de texto para notas adicionales (opcional)
                          CustomTextField(
                            label: 'Notas adicionales (opcional)',
                            hint: 'Información adicional sobre tu solicitud...',
                            controller: _messageController,
                            maxLines: 3,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // muestra resumen de la solicitud si todos los datos estan seleccionados
                          if (_selectedDate != null && _selectedTime != null && _selectedService != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withAlpha(76),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Resumen de tu solicitud',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Servicio: $_selectedService'),
                                  Text('Fecha: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                                  Text('Hora: $_selectedTime'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // boton para enviar la solicitud de reserva
                          CustomButton(
                            text: 'Enviar Solicitud',
                            onPressed: _submitBooking,
                            isLoading: _isLoading,
                            isFullWidth: true,
                            type: ButtonType.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
