package com.esportscoach.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import java.time.LocalDateTime;
import java.util.List;

/*
    documento que almacena las preferencias del usuario:
    incluye configuracion de juego y preferencias de la aplicacion
*/
@Document(collection = "user_preferences")
public class UserPreferences {
    /*
        identificador unico generado por mongodb
        userId indexado de forma unica para relacionar preferencias con un usuario
    */
    @Id
    private String id;

    @Indexed(unique = true)
    private String userId;

    /*
        preferencias de league of legends:
        liga, division, riot id, rol principal y campeones favoritos
    */
    private String tier;
    private String division;
    private String riotId;
    private String mainRole;
    private List<String> favoriteChampions;

    /*
        preferencias de la aplicacion:
        modo oscuro, idioma, notificaciones en app y notificaciones por correo
    */
    private Boolean darkMode = true;
    private String language = "es";
    private Boolean notifications = true;
    private Boolean emailNotifications = true;

    /*
        preferencias de juego general:
        modo de juego preferido, horas disponibles y zona horaria
    */
    private String preferredGameMode;
    private List<String> availableHours;
    private String timezone;

    /*
        marcas de tiempo para control de creacion y ultima actualizacion
        inicializadas en el momento de instanciar el objeto
    */
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    /*
        constructores:
        - vacio para frameworks de deserializacion
        - con userId para crear preferencias iniciales de un usuario
    */
    public UserPreferences() {}

    public UserPreferences(String userId) {
        this.userId = userId;
    }

    /*
        getters y setters para todos los campos del modelo,
        incluyen id, userId, league of legends, app y preferencias de juego
    */
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

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

    public Boolean getDarkMode() { return darkMode; }
    public void setDarkMode(Boolean darkMode) { this.darkMode = darkMode; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public Boolean getNotifications() { return notifications; }
    public void setNotifications(Boolean notifications) { this.notifications = notifications; }

    public Boolean getEmailNotifications() { return emailNotifications; }
    public void setEmailNotifications(Boolean emailNotifications) { this.emailNotifications = emailNotifications; }

    public String getPreferredGameMode() { return preferredGameMode; }
    public void setPreferredGameMode(String preferredGameMode) { this.preferredGameMode = preferredGameMode; }

    public List<String> getAvailableHours() { return availableHours; }
    public void setAvailableHours(List<String> availableHours) { this.availableHours = availableHours; }

    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    /*
        metodo helper para obtener el rango completo del usuario:
        concatena tier y division si ambos existen, de lo contrario retorna solo tier
    */
    public String getFullRank() {
        if (tier != null && division != null) {
            return tier + " " + division;
        }
        return tier;
    }
}
