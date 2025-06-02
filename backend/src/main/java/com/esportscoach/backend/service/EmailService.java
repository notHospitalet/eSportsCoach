package com.esportscoach.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/*
    servicio encargado de envios de correo:
    incluye metodos para email de bienvenida, confirmacion de reserva,
    contacto y notificacion de nueva reserva
*/
@Service
public class EmailService {

    /*
        inyeccion del componente para enviar correos
    */
    @Autowired
    private JavaMailSender emailSender;

    /*
        metodo que envia un correo de bienvenida al usuario registrado:
        - destinatario: to
        - asunto y cuerpo con mensaje estandar de bienvenida
    */
    public void sendWelcomeEmail(String to, String username) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("adriannulero@gmail.com");
        message.setTo(to);
        message.setSubject("¡Bienvenido a eSports Coach!");
        message.setText(String.format(
            "hola %s,\n\n" +
            "¡bienvenido a eSports Coach! estamos emocionados de tenerte en nuestra comunidad.\n\n" +
            "ahora puedes acceder a:\n" +
            "- contenido educativo exclusivo\n" +
            "- servicios de coaching personalizados\n" +
            "- guías y análisis profesionales\n\n" +
            "¡comienza tu viaje hacia la mejora en los eSports!\n\n" +
            "saludos,\n" +
            "el equipo de eSports Coach",
            username
        ));
        
        emailSender.send(message);
    }

    /*
        metodo que envia correo de confirmacion de reserva al usuario:
        - destinatario: to
        - incluye nombre de usuario, nombre del servicio y fecha formateada de reserva
    */
    public void sendBookingConfirmationEmail(String to, String username, String serviceName, LocalDateTime bookingDate) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("adriannulero@gmail.com");
        message.setTo(to);
        message.setSubject("Confirmación de Reserva - eSports Coach");
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String formattedDate = bookingDate.format(formatter);
        
        message.setText(String.format(
            "hola %s,\n\n" +
            "tu reserva ha sido confirmada con éxito.\n\n" +
            "detalles de la reserva:\n" +
            "- servicio: %s\n" +
            "- fecha y hora: %s\n\n" +
            "te contactaremos pronto con más detalles sobre tu sesión.\n\n" +
            "¡gracias por confiar en eSports Coach!\n\n" +
            "saludos,\n" +
            "el equipo de eSports Coach",
            username, serviceName, formattedDate
        ));
        
        emailSender.send(message);
    }

    /*
        metodo que envia correo de contacto recibido:
        - destinatario: to
        - incluye nombre, email, asunto y contenido del mensaje de contacto
    */
    public void sendContactEmail(String to, String name, String email, String subject, String messageContent) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("adriannulero@gmail.com");
        message.setTo(to);
        message.setSubject("Nuevo mensaje de contacto: " + subject);
        message.setText(String.format(
            "nuevo mensaje de contacto recibido:\n\n" +
            "nombre: %s\n" +
            "email: %s\n" +
            "asunto: %s\n\n" +
            "mensaje:\n%s",
            name, email, subject, messageContent
        ));
        
        emailSender.send(message);
    }

    /*
        metodo que envia notificacion de nueva reserva al coach o admin:
        - destinatario: to
        - incluye datos del cliente, email, servicio y fecha formateada de la reserva
    */
    public void sendNewBookingNotificationEmail(String to, String customerName, String customerEmail, String serviceName, LocalDateTime bookingDate) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("adriannulero@gmail.com");
        message.setTo(to);
        message.setSubject("Nueva Reserva - eSports Coach");
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String formattedDate = bookingDate.format(formatter);
        
        message.setText(String.format(
            "nueva reserva recibida:\n\n" +
            "cliente: %s\n" +
            "email: %s\n" +
            "servicio: %s\n" +
            "fecha y hora: %s\n\n" +
            "por favor, contacta al cliente para confirmar los detalles de la sesión.\n\n" +
            "panel de administración: [url_del_panel]",
            customerName, customerEmail, serviceName, formattedDate
        ));
        
        emailSender.send(message);
    }
}
