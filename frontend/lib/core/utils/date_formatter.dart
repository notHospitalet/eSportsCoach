import 'package:intl/intl.dart';

/*
  clase que proporciona metodos para formatear fechas y horas:
  incluye formatos corto, largo, con hora, relativo y obtencion de nombres de dia y mes
*/
class DateFormatter {
  /*
    formatea una fecha en formato corto: dd/MM/yyyy
    ejemplo: 01/06/2025
  */
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /*
    formatea una fecha en formato largo: dd de MMMM, yyyy
    ejemplo: 01 junio, 2025
  */
  static String formatLongDate(DateTime date) {
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  /*
    formatea una fecha incluyendo hora: dd/MM/yyyy HH:mm
    ejemplo: 01/06/2025 14:30
  */
  static String formatDateWithTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /*
    formatea solo la parte de hora de una fecha: HH:mm
    ejemplo: 14:30
  */
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /*
    formatea una fecha de manera relativa:
    - si la fecha es hoy, retorna 'hoy'
    - si la fecha es ayer, retorna 'ayer'
    - si la diferencia en dias es menor a 7, retorna 'hace X dias'
    - de lo contrario, retorna el formato corto de la fecha
  */
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'hoy';
    } else if (dateOnly == yesterday) {
      return 'ayer';
    } else {
      final difference = today.difference(dateOnly).inDays;
      if (difference < 7) {
        return 'hace $difference dias';
      } else {
        return formatShortDate(date);
      }
    }
  }

  /*
    obtiene el nombre del dia de la semana para una fecha dada:
    - lista de dias en espanol comenzando desde lunes
    - weekday en Dart va de 1 (lunes) a 7 (domingo)
  */
  static String getDayName(DateTime date) {
    final dayNames = [
      'lunes',
      'martes',
      'miercoles',
      'jueves',
      'viernes',
      'sabado',
      'domingo'
    ];
    final dayIndex = date.weekday - 1;
    return dayNames[dayIndex];
  }

  /*
    obtiene el nombre del mes para una fecha dada:
    - lista de meses en espanol del 1 al 12
  */
  static String getMonthName(DateTime date) {
    final monthNames = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    return monthNames[date.month - 1];
  }
}
