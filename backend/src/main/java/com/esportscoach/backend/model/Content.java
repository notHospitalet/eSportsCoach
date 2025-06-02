package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

/*
    documento que representa el contenido publicado en la plataforma:
    puede ser articulo, video, guia o analisis, con atributos para control de publicacion y tipo
*/
@Document(collection = "content")
public class Content {
    /*
        identificador unico generado por mongodb
    */
    @Id
    private String id;

    /*
        titulo y descripcion del contenido (no pueden estar en blanco)
    */
    @NotBlank
    private String title;

    @NotBlank
    private String description;

    /*
        url de la imagen en miniatura y url del contenido (puede ser video o enlace externo)
    */
    private String thumbnailUrl;
    private String contentUrl;

    /*
        tipo de contenido (ARTICLE, VIDEO, GUIDE, ANALYSIS), no nulo
    */
    @NotNull
    private ContentType type;

    /*
        etiquetas asociadas para busqueda, indicador si es contenido premium,
        id del autor, fecha de publicacion y flag de publicado
    */
    private List<String> tags;
    private Boolean isPremium = false;
    private String authorId;
    private LocalDateTime publishedAt;
    private Boolean isPublished = false;

    /*
        texto completo del contenido (solo para contenidos que no sean video u otros)
    */
    private String content;
    
    /*
        marcas de tiempo para creacion y ultima actualizacion, se inicializan al instanciar
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        enumeracion que define los posibles tipos de contenido:
        ARTICLE: articulo
        VIDEO: video
        GUIDE: guia
        ANALYSIS: analisis de partida
    */
    public enum ContentType {
        ARTICLE, VIDEO, GUIDE, ANALYSIS
    }

    /*
        constructores:
        - vacio necesario para frameworks de deserializacion
        - con parametros basicos para crear contenido nuevo (titulo, descripcion, tipo)
    */
    public Content() {}

    public Content(String title, String description, ContentType type) {
        this.title = title;
        this.description = description;
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

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public String getContentUrl() { return contentUrl; }
    public void setContentUrl(String contentUrl) { this.contentUrl = contentUrl; }

    public ContentType getType() { return type; }
    public void setType(ContentType type) { this.type = type; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    public Boolean getIsPremium() { return isPremium; }
    public void setIsPremium(Boolean isPremium) { this.isPremium = isPremium; }

    public String getAuthorId() { return authorId; }
    public void setAuthorId(String authorId) { this.authorId = authorId; }

    public LocalDateTime getPublishedAt() { return publishedAt; }
    public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }

    public Boolean getIsPublished() { return isPublished; }
    public void setIsPublished(Boolean isPublished) { this.isPublished = isPublished; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
