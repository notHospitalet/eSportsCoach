package com.esportscoach.backend.controller;

import com.esportscoach.backend.model.Content;
import com.esportscoach.backend.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/*
    controlador que gestiona las operaciones sobre contenidos:
    obtiene, busca, filtra, crea, actualiza, publica y elimina contenidos
*/
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/content")
public class ContentController {

    /*
        inyeccion del servicio de contenido que contiene la logica de negocio
    */
    @Autowired
    private ContentService contentService;

    /*
        endpoint GET /api/content
        permite obtener todos los contenidos publicados o filtrar por tipo, premium o criterio de busqueda
        - si se recibe parametro 'search', busca por texto
        - si se recibe parametro 'type', filtra por tipo de contenido
        - si se recibe parametro 'isPremium', retorna contenidos premium o gratuitos
        - de lo contrario, retorna todos los contenidos publicados
    */
    @GetMapping
    public ResponseEntity<List<Content>> getAllContent(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Boolean isPremium,
            @RequestParam(required = false) String search) {
        
        List<Content> content;
        
        if (search != null && !search.trim().isEmpty()) {
            content = contentService.searchContent(search);
        } else if (type != null) {
            try {
                Content.ContentType contentType = Content.ContentType.valueOf(type.toUpperCase());
                content = contentService.getContentByType(contentType);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().build();
            }
        } else if (isPremium != null) {
            if (isPremium) {
                content = contentService.getPremiumContent();
            } else {
                content = contentService.getFreeContent();
            }
        } else {
            content = contentService.getAllPublishedContent();
        }
        
        return ResponseEntity.ok(content);
    }

    /*
        endpoint GET /api/content/latest
        obtiene los ultimos contenidos publicados, limitado por parametro 'limit' (por defecto 5)
    */
    @GetMapping("/latest")
    public ResponseEntity<List<Content>> getLatestContent(@RequestParam(defaultValue = "5") int limit) {
        List<Content> content = contentService.getLatestContent(limit);
        return ResponseEntity.ok(content);
    }

    /*
        endpoint GET /api/content/{id}
        obtiene un contenido por su identificador, devuelve 200 con el objeto o 404 si no existe
    */
    @GetMapping("/{id}")
    public ResponseEntity<Content> getContentById(@PathVariable String id) {
        return contentService.getContentById(id)
                .map(content -> ResponseEntity.ok().body(content))
                .orElse(ResponseEntity.notFound().build());
    }

    /*
        endpoint POST /api/content
        crea un nuevo contenido usando el objeto recibido en el cuerpo de la solicitud
        retorna 200 con el contenido creado o 400 en caso de error de validacion
    */
    @PostMapping
    public ResponseEntity<Content> createContent(@RequestBody Content content) {
        try {
            Content createdContent = contentService.createContent(content);
            return ResponseEntity.ok(createdContent);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /*
        endpoint PUT /api/content/{id}
        actualiza los detalles de un contenido existente identificado por 'id'
        retorna 200 con el contenido actualizado o 404 si no se encuentra
    */
    @PutMapping("/{id}")
    public ResponseEntity<Content> updateContent(@PathVariable String id, @RequestBody Content contentDetails) {
        try {
            Content updatedContent = contentService.updateContent(id, contentDetails);
            return ResponseEntity.ok(updatedContent);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint PUT /api/content/{id}/publish
        publica un contenido previamente creado, cambiando su estado a publicado
        retorna 200 con el contenido publicado o 404 si no se encuentra
    */
    @PutMapping("/{id}/publish")
    public ResponseEntity<Content> publishContent(@PathVariable String id) {
        try {
            Content publishedContent = contentService.publishContent(id);
            return ResponseEntity.ok(publishedContent);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint DELETE /api/content/{id}
        elimina un contenido identificado por 'id', retorna 200 si se elimina o 404 si no existe
    */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteContent(@PathVariable String id) {
        try {
            contentService.deleteContent(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
