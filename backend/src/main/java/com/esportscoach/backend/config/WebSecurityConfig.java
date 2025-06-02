package com.esportscoach.backend.config;

import com.esportscoach.backend.security.AuthTokenFilter;
import com.esportscoach.backend.service.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.firewall.DefaultHttpFirewall;
import org.springframework.security.web.firewall.HttpFirewall;

/*
    clase que configura la seguridad web, incluyendo autenticacion jwt y reglas de acceso
*/
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig {

    /*
        inyeccion del servicio que carga detalles de usuario para autenticar
    */
    @Autowired
    UserDetailsServiceImpl userDetailsService;

    /*
        bean que provee el filtro para procesar tokens jwt en las solicitudes
    */
    @Bean
    public AuthTokenFilter authenticationJwtTokenFilter() {
        return new AuthTokenFilter();
    }

    /*
        bean que configura el proveedor de autenticacion usando el servicio de detalles de usuario
        y el encoder de contrasenas
    */
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    /*
        bean que expone el authentication manager para ser usado en otros componentes (por ejemplo controladores)
    */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    /*
        bean que define el encoder de contrasenas usando bcrypt
    */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /*
        bean que configura el firewall para permitir dobles barras en las urls
    */
    @Bean
    public HttpFirewall defaultHttpFirewall() {
        return new DefaultHttpFirewall();
    }

    /*
        configuracion de seguridad http: cors y csrf deshabilitados,
        politica de sesiones stateless, rutas publicas y proteccion de otras rutas,
        ademas se deshabilitan frame options para h2 console y se agrega el filtro jwt
    */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
                .authorizeRequests()
                    .antMatchers("/api/auth/**").permitAll()
                    .antMatchers("/api/services/**").permitAll()
                    .antMatchers("/api/content/**").permitAll()
                    .antMatchers("/api/testimonials/**").permitAll()
                    .antMatchers("/h2-console/**").permitAll()
                    .anyRequest().authenticated();

        // ajuste necesario para el uso de la consola h2 en navegadores
        http.headers().frameOptions().disable();

        // se agrega el filtro jwt antes del filtro de autenticacion por usuario y contrasena
        http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
