import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// widget que muestra un calendario interactivo para seleccionar fechas
class BookingCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const BookingCalendar({
    Key? key,
    this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  late DateTime _currentMonth;
  late List<DateTime> _daysInMonth;
  
  @override
  void initState() {
    super.initState();
    // inicializar el mes actual como el mes de hoy
    _currentMonth = DateTime.now();
    _generateDaysInMonth();
  }
  
  /// genera la lista de fechas para mostrar en el calendario, incluyendo dias del mes anterior y siguiente para completar las semanas
  void _generateDaysInMonth() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    
    // obtener el dia de la semana del primer dia del mes (lunes = 1, domingo = 7)
    int firstWeekday = firstDayOfMonth.weekday;
    
    // ajustar para que la semana comience en lunes (convertir 7 a 0)
    firstWeekday = firstWeekday == 7 ? 0 : firstWeekday;
    
    // generar lista inicial de dias, incluyendo dias de mes anterior para completar la primera semana
    _daysInMonth = List.generate(
      lastDayOfMonth.day + firstWeekday,
      (index) {
        if (index < firstWeekday) {
          // dias del mes anterior
          final prevMonth = DateTime(_currentMonth.year, _currentMonth.month, 0);
          return DateTime(prevMonth.year, prevMonth.month, prevMonth.day - (firstWeekday - index - 1));
        } else {
          // dias del mes actual
          return DateTime(_currentMonth.year, _currentMonth.month, index - firstWeekday + 1);
        }
      },
    );
    
    // agregar dias del mes siguiente para completar la ultima semana
    final remainingDays = 7 - (_daysInMonth.length % 7);
    if (remainingDays < 7) {
      final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      for (int i = 1; i <= remainingDays; i++) {
        _daysInMonth.add(DateTime(nextMonth.year, nextMonth.month, i));
      }
    }
  }
  
  /// avanza al mes anterior y regenera las fechas
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _generateDaysInMonth();
    });
  }
  
  /// avanza al mes siguiente y regenera las fechas
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _generateDaysInMonth();
    });
  }
  
  /// comprueba si la fecha corresponde a hoy
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  /// comprueba si la fecha pertenece al mes actualmente mostrado
  bool _isCurrentMonth(DateTime date) {
    return date.month == _currentMonth.month;
  }
  
  /// comprueba si la fecha es anterior a hoy
  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor principal con estilo de tarjeta segun tema claro u oscuro
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
      child: Column(
        children: [
          // encabezado con botones para navegar entre meses y mostrar mes y año actual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // fila con abreviaturas de dias de la semana (lunes a domingo)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('L', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('X', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('J', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('V', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('D', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          
          // grid de dias del mes, incluyendo dias anteriores y posteriores para completar semanas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: _daysInMonth.length,
            itemBuilder: (context, index) {
              final date = _daysInMonth[index];
              final isSelected = widget.selectedDate != null &&
                  date.year == widget.selectedDate!.year &&
                  date.month == widget.selectedDate!.month &&
                  date.day == widget.selectedDate!.day;
              
              final isCurrentMonth = _isCurrentMonth(date);
              final isToday = _isToday(date);
              final isPastDate = _isPastDate(date);
              
              return GestureDetector(
                // solo permite seleccionar fechas del mes actual que no sean pasadas
                onTap: isPastDate || !isCurrentMonth
                    ? null
                    : () => widget.onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    // colorea el dia seleccionado o el dia de hoy segun estado
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : isToday
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        // modifica el color y peso de fuente segun si es dia seleccionado, hoy, mes fuera de rango o pasado
                        color: isSelected
                            ? Colors.white
                            : isPastDate || !isCurrentMonth
                                ? Colors.grey
                                : isToday
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                        fontWeight: isToday || isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
