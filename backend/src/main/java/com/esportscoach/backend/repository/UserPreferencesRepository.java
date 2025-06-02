package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.UserPreferences;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

/*
    repositorio para gestionar operaciones CRUD sobre la coleccion "user_preferences"
    permite buscar, verificar existencia y eliminar preferencias asociadas a un usuario
*/
@Repository
public interface UserPreferencesRepository extends MongoRepository<UserPreferences, String> {
    
    /*
        metodo para obtener las preferencias de un usuario segun su userId
        retorna Optional<UserPreferences> para manejar caso de usuario sin preferencias creadas
    */
    Optional<UserPreferences> findByUserId(String userId);

    /*
        metodo para verificar si existen preferencias para un userId dado
        retorna true si ya hay registro de preferencias para ese usuario
    */
    Boolean existsByUserId(String userId);

    /*
        metodo para eliminar las preferencias asociadas a un userId
    */
    void deleteByUserId(String userId);
}
