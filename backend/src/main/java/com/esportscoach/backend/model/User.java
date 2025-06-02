package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.List;

/*
    documento que representa un usuario en la aplicacion:
    incluye datos de autenticacion, perfil, roles y control de fechas
*/
@Document(collection = "users")
public class User {
    /*
        campos principales y validaciones:
        - id: identificador unico generado por mongodb
        - username: nombre de usuario, obligatorio con tamanio entre 3 y 20
        - email: correo electronico, obligatorio, maximo 50 caracteres, unico y con formato valido
        - password: contrasena, obligatorio con longitud entre 6 y 120 caracteres
    */
    @Id
    private String id;

    @NotBlank
    @Size(min = 3, max = 20)
    private String username;

    @NotBlank
    @Size(max = 50)
    @Email
    @Indexed(unique = true)
    private String email;

    @NotBlank
    @Size(min = 6, max = 120)
    private String password;

    /*
        campos de perfil y preferencias:
        - profileImage: url de la imagen de perfil (opcional)
        - tier y division: liga y division del jugador (opcional)
        - riotId: identificador dentro de riot (opcional)
        - mainRole: rol principal en el juego (opcional)
        - favoriteChampions: lista de campeones favoritos (opcional)
        - isPremium: indica si el usuario tiene suscripcion premium
    */
    private String profileImage;
    private String tier; // iron, bronze, silver, etc.
    private String division; // i, ii, iii, iv
    private String riotId; // riot id del usuario
    private String mainRole;
    private List<String> favoriteChampions;
    private Boolean isPremium = false;

    /*
        rol del usuario dentro de la aplicacion: usuario normal, coach o administrador
        - por defecto, el rol es USER
    */
    private Role role = Role.USER;

    /*
        marcas de tiempo para control de creacion y ultima actualizacion
        se inicializan al momento de crear el objeto
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        enumeracion que define los posibles roles:
        USER: usuario normal
        COACH: entrenador
        ADMIN: administrador
    */
    public enum Role {
        USER, COACH, ADMIN
    }

    /*
        constructores:
        - vacio: necesario para frameworks que deserializan objetos
        - con parametros basicos (username, email, password): para crear un usuario nuevo
    */
    public User() {}

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }

    /*
        getters y setters para acceder y modificar cada campo del modelo
        incluyen id, username, email, password, profileImage, tier, division,
        riotId, mainRole, favoriteChampions, isPremium, role, createdAt y updatedAt
    */
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }

    public String getRiotId() { return riotId; }
    public void setRiotId(String riotId) { this.riotId = riotId; }

    public String getMainRole() { return mainRole; }
    public void setMainRole(String mainRole) { this.mainRole = mainRole; }

    public List<String> getFavoriteChampions() { return favoriteChampions; }
    public void setFavoriteChampions(List<String> favoriteChampions) { this.favoriteChampions = favoriteChampions; }

    public Boolean getIsPremium() { return isPremium; }
    public void setIsPremium(Boolean isPremium) { this.isPremium = isPremium; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    /*
        metodos helper para obtener o establecer el rango completo del usuario:
        - getFullRank: concatena tier y division si ambos existen, de lo contrario retorna tier
        - getRank y setRank: mantienen compatibilidad con codigo existente que espere propiedad 'rank'
    */
    public String getFullRank() {
        if (tier != null && division != null) {
            return tier + " " + division;
        }
        return tier;
    }

    public String getRank() {
        return getFullRank();
    }

    public void setRank(String rank) {
        if (rank != null && !rank.isEmpty()) {
            String[] parts = rank.split(" ");
            if (parts.length > 1) {
                this.tier = parts[0];
                this.division = parts[1];
            } else {
                this.tier = rank;
                this.division = null;
            }
        }
    }
}
