package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

/*
    documento que representa una reserva (booking) en la base de datos:
    incluye datos del usuario, servicio, fechas, estado y detalles de pago
*/
@Document(collection = "bookings")
public class Booking {
    /*
        identificador unico generado por mongodb
    */
    @Id
    private String id;

    /*
        id del usuario que realiza la reserva (no nulo)
        id del servicio que se reserva (no nulo)
        id opcional del coach asignado a la reserva
    */
    @NotNull
    private String userId;

    @NotNull
    private String serviceId;

    private String coachId;

    /*
        fecha y hora programada para la reserva (no nulo)
        estado actual de la reserva, inicializado como PENDING
    */
    @NotNull
    private LocalDateTime date;

    @NotNull
    private BookingStatus status = BookingStatus.PENDING;

    /*
        notas opcionales proporcionadas por el usuario
        estado de pago inicializado como PENDING
        id del pago externo si se procesa
        monto asociado a la reserva
    */
    private String notes;
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;
    private String paymentId;
    private Double amount;
    
    /*
        marcas de tiempo para creacion y ultima actualizacion, se inicializan al momento de instanciar
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        enumeracion que define los posibles estados de una reserva:
        PENDING: pendiente de confirmacion
        CONFIRMED: confirmada
        CANCELLED: cancelada
        COMPLETED: completada
    */
    public enum BookingStatus {
        PENDING, CONFIRMED, CANCELLED, COMPLETED
    }

    /*
        enumeracion que define los posibles estados de pago:
        PENDING: pendiente de pago
        PAID: pagado
        FAILED: pago fallido
        REFUNDED: reembolsado
    */
    public enum PaymentStatus {
        PENDING, PAID, FAILED, REFUNDED
    }

    /*
        constructores: vacio para frameworks y con parametros basicos para instanciar reserva inicial
    */
    public Booking() {}

    public Booking(String userId, String serviceId, LocalDateTime date) {
        this.userId = userId;
        this.serviceId = serviceId;
        this.date = date;
    }

    /*
        getters y setters para acceder y modificar los campos del modelo
    */
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getServiceId() { return serviceId; }
    public void setServiceId(String serviceId) { this.serviceId = serviceId; }

    public String getCoachId() { return coachId; }
    public void setCoachId(String coachId) { this.coachId = coachId; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public BookingStatus getStatus() { return status; }
    public void setStatus(BookingStatus status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
