package com.esportscoach.backend.service;

import com.esportscoach.backend.model.Content;
import com.esportscoach.backend.repository.ContentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/*
    servicio que gestiona la logica de negocio relacionada con los contenidos:
    incluye obtener contenido publicado, buscar por tipo o texto, crear, actualizar, publicar y eliminar
*/
@Service
public class ContentService {

    /*
        inyeccion del repositorio de contenido para realizar operaciones sobre la coleccion "content"
    */
    @Autowired
    private ContentRepository contentRepository;

    /*
        metodo para obtener todos los contenidos que estan publicados,
        ordenados por fecha de publicacion descendente
    */
    public List<Content> getAllPublishedContent() {
        return contentRepository.findByIsPublishedTrueOrderByPublishedAtDesc();
    }

    /*
        metodo para obtener los ultimos contenidos publicados con un limite especificado
        - crea un objeto pageable con orden descendente por campo publishedAt
        - retorna la lista de contenidos publicados limitada por el pageable
    */
    public List<Content> getLatestContent(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("publishedAt").descending());
        return contentRepository.findByIsPublishedTrue(pageable);
    }

    /*
        metodo para obtener todos los contenidos filtrados por un tipo especifico
        - recibe un enum ContentType (ARTICLE, VIDEO, GUIDE, ANALYSIS)
    */
    public List<Content> getContentByType(Content.ContentType type) {
        return contentRepository.findByType(type);
    }

    /*
        metodo para obtener todos los contenidos marcados como premium
    */
    public List<Content> getPremiumContent() {
        return contentRepository.findByIsPremium(true);
    }

    /*
        metodo para obtener todos los contenidos que no son premium (gratuitos)
    */
    public List<Content> getFreeContent() {
        return contentRepository.findByIsPremium(false);
    }

    /*
        metodo para buscar contenido por texto en titulo o descripcion,
        solo devuelve resultados publicados y hace una busqueda case-insensitive
    */
    public List<Content> searchContent(String query) {
        return contentRepository.findByTitleOrDescriptionContainingIgnoreCaseAndIsPublishedTrue(query);
    }

    /*
        metodo para obtener un contenido por su identificador,
        retorna un Optional<Content> para manejar ausencia de resultado
    */
    public Optional<Content> getContentById(String id) {
        return contentRepository.findById(id);
    }

    /*
        metodo para crear un nuevo contenido:
        - asigna fecha de creacion y actualizacion actuales
        - guarda el objeto en la base de datos
    */
    public Content createContent(Content content) {
        content.setCreatedAt(LocalDateTime.now());
        content.setUpdatedAt(LocalDateTime.now());
        return contentRepository.save(content);
    }

    /*
        metodo para actualizar un contenido existente:
        - busca el contenido por id, lanza excepcion si no existe
        - actualiza campos de titulo, descripcion, urls, tipo, etiquetas, flag premium y texto
        - actualiza la fecha de actualizacion
        - guarda y retorna el contenido modificado
    */
    public Content updateContent(String id, Content contentDetails) {
        Content content = contentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("content not found with id: " + id));

        content.setTitle(contentDetails.getTitle());
        content.setDescription(contentDetails.getDescription());
        content.setThumbnailUrl(contentDetails.getThumbnailUrl());
        content.setContentUrl(contentDetails.getContentUrl());
        content.setType(contentDetails.getType());
        content.setTags(contentDetails.getTags());
        content.setIsPremium(contentDetails.getIsPremium());
        content.setContent(contentDetails.getContent());
        content.setUpdatedAt(LocalDateTime.now());

        return contentRepository.save(content);
    }

    /*
        metodo para eliminar un contenido por su id,
        delega en el repositorio para borrar el registro
    */
    public void deleteContent(String id) {
        contentRepository.deleteById(id);
    }

    /*
        metodo para publicar un contenido:
        - busca el contenido por id, lanza excepcion si no existe
        - marca isPublished como true
        - asigna fecha de publicacion y actualizacion a la fecha actual
        - guarda y retorna el contenido publicado
    */
    public Content publishContent(String id) {
        Content content = contentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("content not found with id: " + id));

        content.setIsPublished(true);
        content.setPublishedAt(LocalDateTime.now());
        content.setUpdatedAt(LocalDateTime.now());

        return contentRepository.save(content);
    }
}
