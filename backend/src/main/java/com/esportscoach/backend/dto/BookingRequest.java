package com.esportscoach.backend.dto;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

/*
    dto que representa los datos necesarios para crear una reserva:
    incluye id del servicio, fecha y notas opcionales
*/
public class BookingRequest {
    /*
        id del servicio que se desea reservar (no nulo)
    */
    @NotNull
    private String serviceId;

    /*
        fecha y hora de la reserva (no nulo)
    */
    @NotNull
    private LocalDateTime date;

    /*
        notas adicionales relacionadas con la reserva (opcional)
    */
    private String notes;

    /*
        constructor vacio requerido por frameworks de deserializacion
    */
    public BookingRequest() {}

    /*
        constructor que inicializa todos los campos del dto
    */
    public BookingRequest(String serviceId, LocalDateTime date, String notes) {
        this.serviceId = serviceId;
        this.date = date;
        this.notes = notes;
    }

    /*
        getters y setters para acceder y modificar los campos
    */
    public String getServiceId() { return serviceId; }
    public void setServiceId(String serviceId) { this.serviceId = serviceId; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
