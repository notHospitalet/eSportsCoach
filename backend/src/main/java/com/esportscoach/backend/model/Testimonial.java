package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonProperty;

/*
    documento que representa un testimonio enviado por un usuario:
    incluye nombre, comentario, puntuacion, rangos y estado de aprobacion
*/
@Document(collection = "testimonials")
public class Testimonial {
    /*
        id unico generado por mongodb
    */
    @Id
    private String id;

    /*
        nombre del autor del testimonio (no puede estar en blanco)
        url del avatar del autor (opcional)
        comentario del testimonio (no puede estar en blanco)
        puntuacion entre 1 y 5
    */
    @NotBlank
    private String name;

    private String avatarUrl;

    @NotBlank
    private String comment;

    @Min(1)
    @Max(5)
    private Integer rating;

    /*
        rangos de invocador antes y despues del coaching (opcional)
        fecha de creacion del testimonio (inicializado a la fecha actual)
        id del usuario que escribio el testimonio (opcional)
        indicador de si el testimonio ha sido aprobado para mostrarse
    */
    private String initialRank;
    private String currentRank;
    private LocalDateTime date = LocalDateTime.now();
    private String userId;
    private Boolean isApproved = false;
    
    /*
        marcas de tiempo para control de creacion y actualizacion del documento
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        constructores:
        - vacio para frameworks de deserializacion
        - con parametros basicos (nombre, comentario, puntuacion) para crear testimonio nuevo
    */
    public Testimonial() {}

    public Testimonial(String name, String comment, Integer rating) {
        this.name = name;
        this.comment = comment;
        this.rating = rating;
    }

    /*
        getters y setters para acceder y modificar los campos del modelo
        se anota getId con @JsonProperty("_id") para mapear adecuadamente el campo id en las respuestas JSON
    */
    @JsonProperty("_id")
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public String getInitialRank() { return initialRank; }
    public void setInitialRank(String initialRank) { this.initialRank = initialRank; }

    public String getCurrentRank() { return currentRank; }
    public void setCurrentRank(String currentRank) { this.currentRank = currentRank; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Boolean getIsApproved() { return isApproved; }
    public void setIsApproved(Boolean isApproved) { this.isApproved = isApproved; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
