package com.esportscoach.backend.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

/*
    dto que representa los datos necesarios para registrar un nuevo usuario:
    incluye nombre de usuario, email y contrasena con validaciones de tamano y formato
*/
public class RegisterRequest {
    /*
        nombre de usuario, no puede estar en blanco y debe tener entre 3 y 20 caracteres
    */
    @NotBlank
    @Size(min = 3, max = 20)
    private String username;

    /*
        email del usuario, no puede estar en blanco, maximo 50 caracteres y debe tener formato valido
    */
    @NotBlank
    @Size(max = 50)
    @Email
    private String email;

    /*
        contrasena del usuario, no puede estar en blanco y debe tener entre 6 y 40 caracteres
    */
    @NotBlank
    @Size(min = 6, max = 40)
    private String password;

    /*
        constructor vacio requerido por frameworks de deserializacion
    */
    public RegisterRequest() {}

    /*
        constructor que inicializa username, email y password del nuevo usuario
    */
    public RegisterRequest(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }

    /*
        getters y setters para acceder y modificar los campos username, email y password
    */
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
