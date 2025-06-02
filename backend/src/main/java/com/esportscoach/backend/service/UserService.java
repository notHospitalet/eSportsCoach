package com.esportscoach.backend.service;

import com.esportscoach.backend.dto.UpdateProfileRequest;
import com.esportscoach.backend.model.User;
import com.esportscoach.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Optional;

/*
    servicio que gestiona la logica de negocio relacionada con usuarios:
    incluye busqueda por id y actualizacion de perfil segun datos recibidos
*/
@Service
public class UserService {
    
    /*
        inyeccion del repositorio de usuarios para operaciones sobre la coleccion "users"
    */
    @Autowired
    private UserRepository userRepository;

    /*
        metodo para buscar un usuario por su identificador
        retorna un Optional<User> para manejar ausencia de registro
    */
    public Optional<User> findById(String id) {
        return userRepository.findById(id);
    }

    /*
        metodo para actualizar el perfil de un usuario existente:
        - busca al usuario por id, lanza excepcion si no existe
        - actualiza campos opcionales: username, tier, division, riotId, mainRole y favoriteChampions
        - actualiza la marca de tiempo updatedAt
        - guarda y retorna el usuario modificado
    */
    public User updateProfile(String userId, UpdateProfileRequest request) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("usuario no encontrado"));

        if (request.getUsername() != null) {
            user.setUsername(request.getUsername());
        }
        if (request.getTier() != null) {
            user.setTier(request.getTier());
        }
        if (request.getDivision() != null) {
            user.setDivision(request.getDivision());
        }
        if (request.getRiotId() != null) {
            user.setRiotId(request.getRiotId());
        }
        if (request.getMainRole() != null) {
            user.setMainRole(request.getMainRole());
        }
        if (request.getFavoriteChampions() != null) {
            user.setFavoriteChampions(request.getFavoriteChampions());
        }

        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }
}
