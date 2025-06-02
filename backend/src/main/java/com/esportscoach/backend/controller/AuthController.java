package com.esportscoach.backend.controller;

import com.esportscoach.backend.dto.AuthResponse;
import com.esportscoach.backend.dto.LoginRequest;
import com.esportscoach.backend.dto.RegisterRequest;
import com.esportscoach.backend.model.User;
import com.esportscoach.backend.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/*
    controlador que expone endpoints para autenticacion, registro y obtener datos del usuario actual
*/
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    /*
        inyeccion del servicio de autenticacion que maneja logica de login y registro
    */
    @Autowired
    AuthService authService;

    /*
        endpoint para autenticar usuario:
        recibe credenciales, obtiene respuesta con token, construye estructura de datos esperada por el frontend
    */
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            AuthResponse auth = authService.authenticateUser(loginRequest);

            // construir envoltorio de datos que espera el frontend
            Map<String,Object> data = new HashMap<>();
            data.put("user", Map.of(
              "id",       auth.getId(),
              "username", auth.getUsername(),
              "email",    auth.getEmail(),
              "role",     auth.getRole()
              // agregar otros campos si es necesario para el frontend
            ));
            data.put("token", auth.getToken());

            return ResponseEntity.ok(Collections.singletonMap("data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("error: " + e.getMessage()));
        }
    }

    /*
        endpoint para registrar un nuevo usuario:
        recibe datos de registro, delega logica a servicio de autenticacion y retorna respuesta
    */
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody RegisterRequest signUpRequest) {
        try {
            AuthResponse authResponse = authService.registerUser(signUpRequest);
            return ResponseEntity.ok(authResponse);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("error: " + e.getMessage()));
        }
    }

    /*
        endpoint para obtener informacion del usuario autenticado:
        si existe usuario en contexto, retorna objeto user, si no, retorna error
    */
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        try {
            User currentUser = authService.getCurrentUser();
            if (currentUser != null) {
                return ResponseEntity.ok(currentUser);
            } else {
                return ResponseEntity.badRequest()
                        .body(new MessageResponse("error: user not found"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("error: " + e.getMessage()));
        }
    }

    /*
        clase interna para encapsular mensajes de error en las respuestas
    */
    public static class MessageResponse {
        private String message;

        public MessageResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
