package com.esportscoach.backend.controller;

import com.esportscoach.backend.dto.UpdateProfileRequest;
import com.esportscoach.backend.model.User;
import com.esportscoach.backend.model.UserPreferences;
import com.esportscoach.backend.security.UserPrincipal;
import com.esportscoach.backend.service.UserService;
import com.esportscoach.backend.service.UserPreferencesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

/*
    controlador que gestiona la obtencion y actualizacion del perfil de usuario,
    incluyendo sus preferencias asociadas
*/
@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UserController {

    /*
        inyeccion de servicios: uno para gestionar datos de usuario y otro para gestionar preferencias
    */
    @Autowired
    private UserService userService;

    @Autowired
    private UserPreferencesService userPreferencesService;

    /*
        endpoint GET /api/user/profile
        obtiene el usuario autenticado y sus preferencias (creandolas si no existen)
        retorna un objeto con exito, datos de usuario y preferencias o un error en caso de excepcion
    */
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(@AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            User user = userService.findById(userPrincipal.getId())
                .orElseThrow(() -> new RuntimeException("usuario no encontrado"));
            
            UserPreferences preferences = userPreferencesService.getOrCreatePreferences(userPrincipal.getId());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", user);
            response.put("preferences", preferences);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "error al obtener el perfil: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    /*
        endpoint PUT /api/user/profile
        actualiza datos del perfil del usuario autenticado y sus preferencias segun el request recibido
        retorna un objeto con exito, mensaje, datos actualizados o un error en caso de excepcion
    */
    @PutMapping("/profile")
    public ResponseEntity<?> updateProfile(
            @AuthenticationPrincipal UserPrincipal userPrincipal,
            @Valid @RequestBody UpdateProfileRequest request) {
        
        try {
            User updatedUser = userService.updateProfile(userPrincipal.getId(), request);
            UserPreferences updatedPreferences = userPreferencesService.updatePreferences(userPrincipal.getId(), request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "perfil actualizado correctamente");
            response.put("user", updatedUser);
            response.put("preferences", updatedPreferences);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "error al actualizar el perfil: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }
}
