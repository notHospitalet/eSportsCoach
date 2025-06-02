package com.esportscoach.backend.security;

import com.esportscoach.backend.service.UserDetailsServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/*
    filtro personalizado que se ejecuta una vez por cada solicitud HTTP,
    se encarga de extraer y validar el token jwt de la cabecera,
    y si es valido, establece el contexto de seguridad con la autenticacion del usuario
*/
public class AuthTokenFilter extends OncePerRequestFilter {

    /*
        inyeccion de utilidades jwt para validacion y extraccion de datos del token
        inyeccion del servicio que carga detalles de usuario segun id
    */
    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    /*
        logger para registrar errores durante el proceso de autenticacion
    */
    private static final Logger logger = LoggerFactory.getLogger(AuthTokenFilter.class);

    /*
        metodo principal que intercepta la solicitud HTTP,
        parsea el token, lo valida, y si es valido,
        carga el usuario y establece la autenticacion en el contexto de seguridad
    */
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        try {
            // obtener el token de la cabecera Authorization
            String jwt = parseJwt(request);
            // si existe token y es valido, extraer id de usuario y cargar detalles
            if (jwt != null && jwtUtils.validateJwtToken(jwt)) {
                String userId = jwtUtils.getUserIdFromJwtToken(jwt);

                UserDetails userDetails = userDetailsService.loadUserById(userId);
                // crear objeto de autenticacion con los detalles del usuario y sus roles
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // establecer autenticacion en el contexto de seguridad para que spring la use en el resto de la solicitud
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception e) {
            // registrar error si no se pudo establecer la autenticacion
            logger.error("cannot set user authentication: {}", e);
        }

        // continuar con la cadena de filtros
        filterChain.doFilter(request, response);
    }

    /*
        metodo auxiliar que extrae el token jwt de la cabecera "Authorization"
        verifica que comience con la palabra "Bearer " y en caso afirmativo retorna solo el token
        de lo contrario retorna null
    */
    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }

        return null;
    }
}
