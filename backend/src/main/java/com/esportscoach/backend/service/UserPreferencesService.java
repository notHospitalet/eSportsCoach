package com.esportscoach.backend.service;

import com.esportscoach.backend.dto.UpdateProfileRequest;
import com.esportscoach.backend.model.UserPreferences;
import com.esportscoach.backend.repository.UserPreferencesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Optional;

/*
    servicio que gestiona las preferencias de usuario:
    permite buscar, crear y actualizar las preferencias asociadas a un usuario
*/
@Service
public class UserPreferencesService {
    
    /*
        inyeccion del repositorio de preferencias para operaciones sobre la coleccion "user_preferences"
    */
    @Autowired
    private UserPreferencesRepository userPreferencesRepository;

    /*
        metodo para buscar preferencias por userId:
        retorna un Optional<UserPreferences> para manejar usuario sin preferencias
    */
    public Optional<UserPreferences> findByUserId(String userId) {
        return userPreferencesRepository.findByUserId(userId);
    }

    /*
        metodo para crear preferencias por defecto para un usuario:
        se instancia UserPreferences con valores iniciales y se guarda en la base de datos
    */
    public UserPreferences createDefaultPreferences(String userId) {
        UserPreferences preferences = new UserPreferences(userId);
        return userPreferencesRepository.save(preferences);
    }

    /*
        metodo para actualizar las preferencias de un usuario:
        - busca preferencias existentes o crea una nueva instancia si no existen
        - actualiza campos de tier, division, riotId, mainRole y favoriteChampions si vienen en el request
        - actualiza updatedAt y guarda los cambios en la base de datos
    */
    public UserPreferences updatePreferences(String userId, UpdateProfileRequest request) {
        UserPreferences preferences = userPreferencesRepository.findByUserId(userId)
            .orElse(new UserPreferences(userId));

        if (request.getTier() != null) {
            preferences.setTier(request.getTier());
        }
        if (request.getDivision() != null) {
            preferences.setDivision(request.getDivision());
        }
        if (request.getRiotId() != null) {
            preferences.setRiotId(request.getRiotId());
        }
        if (request.getMainRole() != null) {
            preferences.setMainRole(request.getMainRole());
        }
        if (request.getFavoriteChampions() != null) {
            preferences.setFavoriteChampions(request.getFavoriteChampions());
        }

        preferences.setUpdatedAt(LocalDateTime.now());
        return userPreferencesRepository.save(preferences);
    }

    /*
        metodo para obtener preferencias existentes o crear las por defecto si no existen:
        utiliza findByUserId y en caso de ausencia crea una nueva instancia
    */
    public UserPreferences getOrCreatePreferences(String userId) {
        return userPreferencesRepository.findByUserId(userId)
            .orElseGet(() -> createDefaultPreferences(userId));
    }
}
