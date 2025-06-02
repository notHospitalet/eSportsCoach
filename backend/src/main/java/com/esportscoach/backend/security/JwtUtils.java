// src/main/java/com/esportscoach/backend/security/JwtUtils.java

package com.esportscoach.backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

/*
    componente que provee utilidades para generar y validar tokens JWT,
    usando algoritmo HS512 y una clave secreta en base64
*/
@Component
public class JwtUtils {
    /*
        logger para registrar errores al procesar JWT
    */
    private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);

    /**
     * clave secreta en base64 de 64 bytes = 512 bits para firmar HS512,
     * inyectada desde application.properties (app.jwtSecret)
     */
    @Value("${app.jwtSecret}")
    private String jwtSecretBase64;

    /** expiracion del token en milisegundos (p.ej. 86400000 = 1 dia), inyectada desde properties */
    @Value("${app.jwtExpirationMs}")
    private int jwtExpirationMs;

    /**
     * decodifica la clave base64 y construye un SecretKey de 512 bits
     */
    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecretBase64);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * genera un JWT firmado con HS512:
     * - subject: id de usuario (string)
     * - issuedAt: fecha actual
     * - expiration: fecha actual + jwtExpirationMs
     */
    public String generateJwtToken(Authentication authentication) {
        UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();

        return Jwts.builder()
                .setSubject(userPrincipal.getId().toString())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                .compact();
    }

    /**
     * obtiene el id de usuario (subject) de un token valido,
     * parseando claims con la clave de firma
     */
    public String getUserIdFromJwtToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }

    /**
     * valida formato, firma y expiracion del JWT:
     * retorna true si es valido, false en caso de excepciones
     */
    public boolean validateJwtToken(String authToken) {
        try {
            Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(authToken);
            return true;
        } catch (MalformedJwtException e) {
            logger.error("invalid jwt token: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            logger.error("jwt token is expired: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            logger.error("jwt token is unsupported: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.error("jwt claims string is empty: {}", e.getMessage());
        }
        return false;
    }
}
