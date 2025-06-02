package com.esportscoach.backend.security;

import com.esportscoach.backend.model.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

/*
    clase que implementa UserDetails para adaptarse a spring security:
    encapsula datos del usuario y sus autoridades (roles)
*/
public class UserPrincipal implements UserDetails {
    /*
        campos principales del usuario:
        - id: identificador unico del usuario
        - username: nombre de usuario
        - email: correo electronico
        - password: contrasena encriptada
        - authorities: coleccion de roles/granted authorities
    */
    private String id;
    private String username;
    private String email;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;

    /*
        constructor que inicializa todos los campos del user principal
    */
    public UserPrincipal(String id, String username, String email, String password, Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.authorities = authorities;
    }

    /*
        metodo factory para crear un UserPrincipal a partir de un modelo User:
        construye la autoridad a partir del rol del usuario y crea la instancia
    */
    public static UserPrincipal create(User user) {
        GrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + user.getRole().name());

        return new UserPrincipal(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(authority)
        );
    }

    /*
        getter para id (utilizado internamente, no es parte de UserDetails)
    */
    public String getId() {
        return id;
    }

    /*
        getter para email (utilizado internamente, no es parte de UserDetails)
    */
    public String getEmail() {
        return email;
    }

    /*
        metodos de UserDetails:
        - getUsername: devuelve el nombre de usuario
        - getPassword: devuelve la contrasena
        - getAuthorities: devuelve la lista de roles/autorizaciones
        - isAccountNonExpired, isAccountNonLocked, isCredentialsNonExpired, isEnabled:
          todos retornan true indicando que la cuenta esta activa y valida
    */
    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
