package com.esportscoach.backend.service;

import com.esportscoach.backend.model.User;
import com.esportscoach.backend.repository.UserRepository;
import com.esportscoach.backend.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/*
    servicio que implementa UserDetailsService de spring security:
    carga detalles del usuario para el proceso de autenticacion usando email o id
*/
@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    /*
        inyeccion del repositorio para acceder a datos de usuario en la base de datos
    */
    @Autowired
    UserRepository userRepository;

    /*
        metodo requerido por UserDetailsService:
        - carga un usuario por su email (username) para autenticacion
        - lanza UsernameNotFoundException si no existe
        - retorna un UserPrincipal que implementa UserDetails
    */
    @Override
    @Transactional
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("user not found with email: " + email));

        return UserPrincipal.create(user);
    }

    /*
        metodo auxiliar para cargar un usuario por su id (no parte de la interfaz original):
        - busca usuario por id, lanza UsernameNotFoundException si no existe
        - retorna UserPrincipal con datos del usuario
    */
    @Transactional
    public UserDetails loadUserById(String id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("user not found with id : " + id));

        return UserPrincipal.create(user);
    }
}
