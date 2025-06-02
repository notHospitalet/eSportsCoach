import 'package:flutter/foundation.dart';

/*
  enumeraciones que representan los estados posibles de una reserva (booking)
*/
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

enum PaymentStatus {
  pending,
  paid,
  refunded,
}

/*
  modelo que representa una reserva:
  - id: identificador de la reserva (puede ser nulo al crear)
  - userId: id del usuario que hace la reserva
  - serviceId: id del servicio reservado
  - coachId: id del coach asignado
  - date: fecha y hora de la reserva
  - status: estado de la reserva (por defecto pending)
  - notes: notas opcionales de la reserva
  - paymentStatus: estado del pago (por defecto pending)
  - paymentId: id del pago externo (puede ser nulo)
  - amount: monto de la reserva
  - createdAt: fecha de creacion de la reserva (puede ser nulo)
*/
class Booking {
  final String? id;
  final String userId;
  final String serviceId;
  final String coachId;
  final DateTime date;
  final BookingStatus status;
  final String? notes;
  final PaymentStatus paymentStatus;
  final String? paymentId;
  final double amount;
  final DateTime? createdAt;

  /*
    constructor principal:
    - id y createdAt son opcionales (nullables)
    - status y paymentStatus tienen valores por defecto
  */
  Booking({
    this.id,
    required this.userId,
    required this.serviceId,
    required this.coachId,
    required this.date,
    this.status = BookingStatus.pending,
    this.notes,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentId,
    required this.amount,
    this.createdAt,
  });

  /*
    factory constructor que crea una instancia de Booking a partir de un JSON:
    - _id mapeado a id
    - user, service y coach de la respuesta JSON
    - parseo de date y createdAt usando DateTime.parse
    - parseo de status y paymentStatus usando métodos estáticos privados
    - amount convertido a double
  */
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      userId: json['user'],
      serviceId: json['service'],
      coachId: json['coach'],
      date: DateTime.parse(json['date']),
      status: _parseBookingStatus(json['status']),
      notes: json['notes'],
      paymentStatus: _parsePaymentStatus(json['paymentStatus']),
      paymentId: json['paymentId'],
      amount: json['amount'].toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  /*
    método que convierte la instancia a JSON:
    - incluye campos obligatorios: user, service, coach, date, status, paymentStatus y amount
    - solo incluye _id, notes y paymentId si no son nulos
    - usa describeEnum para obtener la representación en texto de las enumeraciones
  */
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user': userId,
      'service': serviceId,
      'coach': coachId,
      'date': date.toIso8601String(),
      'status': describeEnum(status),
      if (notes != null) 'notes': notes,
      'paymentStatus': describeEnum(paymentStatus),
      if (paymentId != null) 'paymentId': paymentId,
      'amount': amount,
    };
  }

  /*
    método privado que convierte un string a BookingStatus:
    - retorna pending por defecto si no coincide ninguno
  */
  static BookingStatus _parseBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }

  /*
    método privado que convierte un string a PaymentStatus:
    - retorna pending por defecto si no coincide ninguno
  */
  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}
