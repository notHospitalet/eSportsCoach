package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.Content;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

/*
    repositorio para gestionar operaciones CRUD sobre la coleccion "content"
    incluye metodos personalizados para obtener contenido publicado, filtrar por tipo, premium, autor y busquedas por etiquetas o texto
*/
@Repository
public interface ContentRepository extends MongoRepository<Content, String> {
    /*
        metodo para obtener todos los contenidos publicados, ordenados por fecha de publicacion descendente
    */
    List<Content> findByIsPublishedTrueOrderByPublishedAtDesc();

    /*
        metodo para obtener contenidos filtrados por su tipo (ARTICLE, VIDEO, GUIDE, ANALYSIS)
    */
    List<Content> findByType(Content.ContentType type);

    /*
        metodo para obtener contenidos segun si son premium o gratuitos
    */
    List<Content> findByIsPremium(Boolean isPremium);

    /*
        metodo para obtener todos los contenidos de un autor especifico
    */
    List<Content> findByAuthorId(String authorId);
    
    /*
        consulta personalizada para buscar contenido por etiquetas:
        - tags: lista de etiquetas que deben estar en el contenido
        - isPublished: solo buscar entre contenidos publicados
    */
    @Query("{'tags': {$in: ?0}, 'isPublished': true}")
    List<Content> findByTagsInAndIsPublishedTrue(List<String> tags);
    
    /*
        consulta personalizada para buscar texto en titulo o descripcion:
        - utiliza expresiones regulares para coincidencia case-insensitive
        - solo retorna resultados publicados
    */
    @Query("{'$or': [{'title': {$regex: ?0, $options: 'i'}}, {'description': {$regex: ?0, $options: 'i'}}], 'isPublished': true}")
    List<Content> findByTitleOrDescriptionContainingIgnoreCaseAndIsPublishedTrue(String query);
}
