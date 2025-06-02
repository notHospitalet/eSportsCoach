package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.PositiveOrZero;
import java.time.LocalDateTime;
import java.util.List;

/*
    documento que representa un servicio ofrecido en la plataforma:
    incluye titulo, descripcion, precio, tipo y detalles adicionales como duracion, caracteristicas y estado
*/
@Document(collection = "services")
public class Service {
    /*
        atributos principales y de validacion:
        - id generado por mongodb
        - title: nombre del servicio (no puede estar en blanco)
        - description: descripcion detallada (no puede estar en blanco)
        - price: precio del servicio (no nulo y debe ser cero o mayor)
        - type: tipo de servicio (no nulo)
    */
    @Id
    private String id;

    @NotBlank
    private String title;

    @NotBlank
    private String description;

    @NotNull
    @PositiveOrZero
    private Double price;

    @NotNull
    private ServiceType type;

    /*
        detalles adicionales del servicio:
        - imageUrl: url de la imagen asociada
        - features: lista de caracteristicas o beneficios incluidos
        - durationMinutes: duracion del servicio en minutos
        - isPopular: flag que indica si es un servicio popular
        - isActive: flag que indica si el servicio esta activo o inactivo
        - coachId: id del coach que ofrece este servicio
    */
    private String imageUrl;
    private List<String> features;
    private Integer durationMinutes;
    private Boolean isPopular = false;
    private Boolean isActive = true;
    private String coachId;
    
    /*
        marcas de tiempo para control de creacion y actualizacion:
        se inicializan al momento de instanciar el objeto
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        enumeracion que define los posibles tipos de servicio:
        - INDIVIDUAL: sesion 1 a 1
        - MONTHLY: plan mensual
        - COURSE: curso estructurado
        - GUIDE: guia o paquete de material
        - TEAM: coaching de equipo
    */
    public enum ServiceType {
        INDIVIDUAL, MONTHLY, COURSE, GUIDE, TEAM
    }

    /*
        constructores:
        - vacio para frameworks de deserializacion
        - con parametros basicos (title, description, price, type) para crear servicio nuevo
    */
    public Service() {}

    public Service(String title, String description, Double price, ServiceType type) {
        this.title = title;
        this.description = description;
        this.price = price;
        this.type = type;
    }

    /*
        getters y setters para acceder y modificar los campos del modelo
    */
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public ServiceType getType() { return type; }
    public void setType(ServiceType type) { this.type = type; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public List<String> getFeatures() { return features; }
    public void setFeatures(List<String> features) { this.features = features; }

    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }

    public Boolean getIsPopular() { return isPopular; }
    public void setIsPopular(Boolean isPopular) { this.isPopular = isPopular; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public String getCoachId() { return coachId; }
    public void setCoachId(String coachId) { this.coachId = coachId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
