package com.esportscoach.backend.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.core.MongoTemplate;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import java.util.concurrent.TimeUnit;

/*
    clase que configura la conexion a mongodb, incluyendo manejo de ssl para aceptar todos los certificados
*/
@Configuration
public class MongoConfig extends AbstractMongoClientConfiguration {

    /*
        propiedades inyectadas desde application.properties para uri y nombre de base de datos
    */
    @Value("${spring.data.mongodb.uri}")
    private String mongoUri;

    @Value("${spring.data.mongodb.database}")
    private String databaseName;

    /*
        metodo que retorna el nombre de la base de datos usada por mongodb
    */
    @Override
    protected String getDatabaseName() {
        return databaseName;
    }

    /*
        bean que crea el cliente de mongodb con configuracion de ssl que acepta todos los certificados,
        ademas se establecen tiempos de espera para conexion, lectura y seleccion de servidores
    */
    @Bean
    @Override
    public MongoClient mongoClient() {
        try {
            /*
                se crea un trustmanager que no valida ningun certificado (acepta todos)
            */
            TrustManager[] trustAllCerts = new TrustManager[] {
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) { }
                    public void checkServerTrusted(X509Certificate[] certs, String authType) { }
                }
            };

            // se inicializa el contexto ssl con el trustmanager que acepta todos los certificados
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());

            ConnectionString connectionString = new ConnectionString(mongoUri);
            
            /*
                configuracion de cliente mongodb aplicando uri, ajustes ssl, tiempos de espera de socket y clúster
            */
            MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .applyToSslSettings(builder -> {
                    builder.enabled(true)
                           .invalidHostNameAllowed(true)
                           .context(sslContext);
                })
                .applyToSocketSettings(builder -> {
                    builder.connectTimeout(10, TimeUnit.SECONDS)
                           .readTimeout(10, TimeUnit.SECONDS);
                })
                .applyToClusterSettings(builder -> {
                    builder.serverSelectionTimeout(10, TimeUnit.SECONDS);
                })
                .build();

            return MongoClients.create(settings);
        } catch (Exception e) {
            // en caso de error, mostrar mensaje y crear cliente con configuracion por defecto usando uri
            System.err.println("error configurando mongodb: " + e.getMessage());
            return MongoClients.create(mongoUri);
        }
    }

    /*
        bean que crea el template de mongodb para operaciones CRUD usando el cliente configurado
    */
    @Bean
    public MongoTemplate mongoTemplate() {
        return new MongoTemplate(mongoClient(), getDatabaseName());
    }
}
