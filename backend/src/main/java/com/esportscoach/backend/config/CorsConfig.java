package com.esportscoach.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/*
    clase encargada de configurar cors para permitir peticiones desde cualquier origen
*/
@Configuration
public class CorsConfig {

    /*
        crea un bean que define las reglas de cors para la aplicacion
    */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        // se crea la configuracion base donde se establecen orígenes, metodos y cabeceras permitidos
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);

        // se asocia la configuracion cors a todas las rutas de la aplicacion
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
