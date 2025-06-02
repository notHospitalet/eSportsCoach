package com.esportscoach.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/*
    clase principal que inicia la aplicacion spring boot
    la anotacion springbootapplication habilita autoconfiguracion y escaneo de componentes
*/
@SpringBootApplication
public class BackendApplication {
    /*
        metodo main que arranca el contexto de spring ejecutando la aplicacion
    */
    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }
}
