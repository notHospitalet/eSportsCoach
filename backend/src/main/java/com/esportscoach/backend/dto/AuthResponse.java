package com.esportscoach.backend.dto;

import com.esportscoach.backend.model.User;

/*
    dto que encapsula la respuesta de autenticacion, incluyendo token y datos basicos del usuario
*/
public class AuthResponse {
    private String token;
    private String type = "Bearer";
    private String id;
    private String username;
    private String email;
    private User.Role role;

    /*
        constructor que inicializa el token, id, username, email y rol del usuario autenticado
    */
    public AuthResponse(String accessToken, String id, String username, String email, User.Role role) {
        this.token = accessToken;
        this.id = id;
        this.username = username;
        this.email = email;
        this.role = role;
    }

    /*
        getters y setters para acceder y modificar los campos del dto
    */
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public User.Role getRole() { return role; }
    public void setRole(User.Role role) { this.role = role; }
}
