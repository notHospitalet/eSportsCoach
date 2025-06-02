import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/providers/booking_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;      // Controla las pestañas: Próximas, Completadas, Canceladas
  bool _isLoading = false;                // Indica si se están cargando las reservas

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);  // Inicializamos TabController con 3 pestañas
    _fetchBookings();                                        // Al iniciar, obtenemos las reservas del usuario
  }

  @override
  void dispose() {
    _tabController.dispose();  // Liberamos el controlador de pestañas al cerrar la pantalla
    super.dispose();
  }

  /// Obtiene las reservas del proveedor y actualiza el estado de carga
  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;  // Mostramos indicador de carga mientras se obtienen datos
    });

    try {
      // Llamamos a fetchUserBookings() en BookingProvider (sin escuchar cambios aquí)
      await Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
    } catch (e) {
      if (mounted) {
        // En caso de error, mostramos un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las reservas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;  // Ocultamos indicador de carga al finalizar
        });
      }
    }
  }

  /// Cancela una reserva por su ID y actualiza estados de carga y UI
  Future<void> _cancelBooking(String id) async {
    setState(() {
      _isLoading = true;  // Mostramos indicador de carga durante la operación
    });

    try {
      // Intentamos cancelar la reserva mediante BookingProvider
      final success = await Provider.of<BookingProvider>(context, listen: false).cancelBooking(id);

      if (mounted) {
        if (success) {
          // Si la cancelación fue exitosa, mostramos mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reserva cancelada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Si hubo problema al cancelar, informamos al usuario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al cancelar la reserva'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Si ocurre excepción, mostramos mensaje de error conteniendo el detalle
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cancelar la reserva: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;  // Ocultamos indicador de carga al finalizar
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Próximas'),      // Pestaña de reservas futuras (pendientes/confirmadas)
            Tab(text: 'Completadas'),   // Pestaña de reservas finalizadas
            Tab(text: 'Canceladas'),    // Pestaña de reservas canceladas
          ],
        ),
      ),
      body: _isLoading
          // Si está cargando, mostramos un indicador en el centro
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchBookings,  // Permite arrastrar hacia abajo para refrescar la lista
              child: Consumer<BookingProvider>(
                builder: (context, bookingProvider, child) {
                  // Filtramos las reservas según su estado
                  final upcomingBookings = bookingProvider.bookings.where((booking) =>
                      booking.status == BookingStatus.pending ||
                      booking.status == BookingStatus.confirmed).toList();

                  final completedBookings = bookingProvider.bookings.where((booking) =>
                      booking.status == BookingStatus.completed).toList();

                  final cancelledBookings = bookingProvider.bookings.where((booking) =>
                      booking.status == BookingStatus.cancelled).toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Vista de reservas próximas
                      _buildBookingsList(
                        upcomingBookings,
                        'No tienes reservas próximas',
                        showCancelButton: true, // En próximas, permitimos cancelar
                      ),

                      // Vista de reservas completadas
                      _buildBookingsList(
                        completedBookings,
                        'No tienes reservas completadas',
                      ),

                      // Vista de reservas canceladas
                      _buildBookingsList(
                        cancelledBookings,
                        'No tienes reservas canceladas',
                      ),
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Botón flotante para crear una nueva reserva (redirige a ContactScreen)
          Navigator.pushNamed(context, '/contact');
        },
        tooltip: 'Nueva reserva',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Construye la lista de reservas con su respectivo mensaje vacio o botón
  Widget _buildBookingsList(List<Booking> bookings, String emptyMessage, {bool showCancelButton = false}) {
    if (bookings.isEmpty) {
      // Si no hay reservas en esta categoría, mostramos un mensaje y botón para reservar
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Reservar una sesión',
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
              },
              type: ButtonType.secondary,
            ),
          ],
        ),
      );
    }

    // Si hay reservas, construimos una ListView con BookingCard para cada una
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(
          booking: bookings[index],
          // Si showCancelButton es true, pasamos la función para cancelar palabra
          onCancel: showCancelButton ? () => _cancelBooking(bookings[index].id!) : null,
        );
      },
    );
  }
}
