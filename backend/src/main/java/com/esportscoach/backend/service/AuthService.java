package com.esportscoach.backend.service;

import com.esportscoach.backend.dto.AuthResponse;
import com.esportscoach.backend.dto.LoginRequest;
import com.esportscoach.backend.dto.RegisterRequest;
import com.esportscoach.backend.model.User;
import com.esportscoach.backend.repository.UserRepository;
import com.esportscoach.backend.security.JwtUtils;
import com.esportscoach.backend.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/*
    servicio que maneja la logica de autenticacion y registro de usuarios,
    incluyendo generacion de tokens JWT y envio de correos de bienvenida
*/
@Service
public class AuthService {

    /*
        inyeccion de componentes necesarios:
        - AuthenticationManager para autenticar credenciales
        - UserRepository para operacion sobre usuarios en BD
        - PasswordEncoder para encriptar contrasenas
        - JwtUtils para generar y validar tokens
        - EmailService para enviar correo de bienvenida
    */
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    EmailService emailService;

    /*
        metodo para autenticar un usuario existente:
        - utiliza AuthenticationManager para validar email y password
        - establece el contexto de seguridad con la autenticacion obtenida
        - genera un token JWT para el usuario autentificado
        - construye y retorna un AuthResponse con token y datos del usuario
    */
    public AuthResponse authenticateUser(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();

        return new AuthResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                userRepository.findById(userDetails.getId()).get().getRole());
    }

    /*
        metodo para registrar un nuevo usuario:
        - verifica que email y username no esten en uso
        - crea un objeto User con datos proporcionados y contrasena encriptada
        - asigna rol USER y guarda en la base de datos
        - intenta enviar un correo de bienvenida (loggea error en caso de falla sin interrumpir)
        - luego realiza un auto-login para el nuevo usuario y genera un token JWT
        - retorna un AuthResponse con el token y datos del usuario
    */
    public AuthResponse registerUser(RegisterRequest signUpRequest) {
        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            throw new RuntimeException("Error: Email is already in use!");
        }

        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            throw new RuntimeException("Error: Username is already taken!");
        }

        // Creacion de la cuenta del usuario
        User user = new User(signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()));

        user.setRole(User.Role.USER);
        userRepository.save(user);

        // Envio de correo de bienvenida
        try {
            emailService.sendWelcomeEmail(user.getEmail(), user.getUsername());
        } catch (Exception e) {
            // Loguear error pero no fallar el registro
            System.err.println("failed to send welcome email: " + e.getMessage());
        }

        // Auto-login despues del registro
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(signUpRequest.getEmail(), signUpRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();

        return new AuthResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                user.getRole());
    }

    /*
        metodo para obtener el usuario actualmente autenticado:
        - extrae el objeto Authentication del contexto de seguridad
        - si el principal es instancia de UserPrincipal, busca y retorna el User correspondiente
        - si no hay autenticacion valida, retorna null
    */
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserPrincipal) {
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
            return userRepository.findById(userPrincipal.getId()).orElse(null);
        }
        return null;
    }
}
