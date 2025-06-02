package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

/*
    repositorio para gestionar operaciones CRUD sobre la coleccion "users"
    incluye metodos personalizados para buscar usuarios por email o username 
    y verificar existencia de registros duplicados
*/
@Repository
public interface UserRepository extends MongoRepository<User, String> {
    
    /*
        metodo para buscar un usuario segun su email
        retorna Optional<User> para manejar caso de usuario no existente
    */
    Optional<User> findByEmail(String email);

    /*
        metodo para buscar un usuario segun su username
        retorna Optional<User> para manejar caso de usuario no existente
    */
    Optional<User> findByUsername(String username);

    /*
        metodo para verificar si ya existe un usuario con el email proporcionado
        retorna true si existe al menos un registro con ese email
    */
    Boolean existsByEmail(String email);

    /*
        metodo para verificar si ya existe un usuario con el username proporcionado
        retorna true si existe al menos un registro con ese username
    */
    Boolean existsByUsername(String username);
}
