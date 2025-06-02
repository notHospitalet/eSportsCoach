package com.esportscoach.backend.dto;

import javax.validation.constraints.Size;
import java.util.List;

/*
    dto para actualizar datos de perfil de usuario:
    incluye opcion de cambiar nombre de usuario, liga, division, riot id, rol principal y campeones favoritos
*/
public class UpdateProfileRequest {
    /*
        nombre de usuario nuevo (opcional), debe tener entre 3 y 20 caracteres
    */
    @Size(min = 3, max = 20)
    private String username;
    
    /*
        liga del jugador (opcional)
    */
    private String tier;
    /*
        division del jugador dentro de la liga (opcional)
    */
    private String division;
    /*
        identificador de riot del jugador (opcional)
    */
    private String riotId;
    /*
        rol principal del jugador (opcional)
    */
    private String mainRole;
    /*
        lista de campeones favoritos (opcional)
    */
    private List<String> favoriteChampions;

    /*
        constructor vacio requerido para deserializacion de peticiones
    */
    public UpdateProfileRequest() {}

    /*
        getters y setters para todos los campos del dto
    */
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

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
}
