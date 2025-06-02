package com.esportscoach.backend.dto;

import javax.validation.constraints.NotBlank;

/*
    dto que contiene los datos de inicio de sesion:
    incluye email y password obligatorios para autenticar al usuario
*/
public class LoginRequest {
    /*
        email del usuario, no puede estar en blanco
    */
    @NotBlank
    private String email;

    /*
        contrasena del usuario, no puede estar en blanco
    */
    @NotBlank
    private String password;

    /*
        constructor vacio requerido para deserializacion de peticiones
    */
    public LoginRequest() {}

    /*
        constructor que inicializa email y password
    */
    public LoginRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }

    /*
        getters y setters para acceder y modificar los campos email y password
    */
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
