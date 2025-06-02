package com.esportscoach.backend.config;

import com.esportscoach.backend.model.*;
import com.esportscoach.backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Arrays;

/*
    clase encargada de inicializar datos de prueba al arrancar la aplicacion
*/
@Component
public class DataInitializer implements CommandLineRunner {

    /*
        inyeccion de repositorios y codificador de contrasenas necesarios
    */
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private ContentRepository contentRepository;

    @Autowired
    private TestimonialRepository testimonialRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /*
        metodo que se ejecuta al arrancar la aplicacion para verificar y poblar datos
    */
    @Override
    public void run(String... args) throws Exception {
        try {
            System.out.println("🔄 iniciando inicializacion de datos...");
            
            /*
                verificar conexion a mongodb contando usuarios existentes
            */
            long userCount = userRepository.count();
            System.out.println("✅ conexion a mongodb exitosa. usuarios existentes: " + userCount);
            
            /*
                si no hay usuarios, ejecutar inicializacion; de lo contrario, omitir
            */
            if (userCount == 0) {
                initializeData();
            } else {
                System.out.println("ℹ️ los datos ya estan inicializados. saltando inicializacion.");
            }
            
        } catch (Exception e) {
            System.err.println("❌ error durante la inicializacion: " + e.getMessage());
            System.err.println("⚠️ la aplicacion continuara sin datos de prueba.");
            // no lanzar excepcion para que la aplicacion pueda continuar
        }
    }

    /*
        metodo que limpia colecciones y crea datos de prueba: usuarios, servicios, contenidos y testimonios
    */
    private void initializeData() {
        try {
            System.out.println("🗑️ limpiando datos existentes...");
            
            /*
                eliminacion segura de datos anteriores en orden de dependencias
            */
            userRepository.deleteAll();
            serviceRepository.deleteAll();
            contentRepository.deleteAll();
            testimonialRepository.deleteAll();

            System.out.println("👤 creando usuarios...");
            
            /*
                creacion de usuario administrador, coach y jugador con roles y atributos iniciales
            */
            User admin = new User("admin", "admin@esportscoach.com", passwordEncoder.encode("admin123"));
            admin.setRole(User.Role.ADMIN);
            admin.setProfileImage("https://via.placeholder.com/150");
            userRepository.save(admin);

            User coach = new User("coach", "coach@esportscoach.com", passwordEncoder.encode("coach123"));
            coach.setRole(User.Role.COACH);
            coach.setProfileImage("https://via.placeholder.com/150");
            coach.setTier("CHALLENGER");
            coach.setDivision("I");
            coach.setMainRole("Support");
            coach.setRiotId("Coach#EUW");
            userRepository.save(coach);

            User player = new User("player", "player@esportscoach.com", passwordEncoder.encode("player123"));
            player.setRole(User.Role.USER);
            player.setProfileImage("https://via.placeholder.com/150");
            player.setTier("GOLD");
            player.setDivision("II");
            player.setMainRole("ADC");
            player.setRiotId("Player#EUW");
            player.setFavoriteChampions(Arrays.asList("Jinx", "Caitlyn", "Vayne"));
            userRepository.save(player);

            System.out.println("🛠️ creando servicios...");
            
            /*
                creacion de servicios: coaching individual, plan mensual y coaching de equipo
            */
            Service individualCoaching = new Service("Coaching Individual", "Sesion personalizada 1 vs 1 con analisis detallado", 25.0, Service.ServiceType.INDIVIDUAL);
            individualCoaching.setImageUrl("https://via.placeholder.com/300x200");
            individualCoaching.setFeatures(Arrays.asList("Analisis de replays", "Consejos personalizados", "Plan de mejora"));
            individualCoaching.setDurationMinutes(60);
            individualCoaching.setIsPopular(true);
            individualCoaching.setCoachId(coach.getId());
            serviceRepository.save(individualCoaching);

            Service monthlyPlan = new Service("Plan Mensual", "Coaching continuo durante un mes completo", 80.0, Service.ServiceType.MONTHLY);
            monthlyPlan.setImageUrl("https://via.placeholder.com/300x200");
            monthlyPlan.setFeatures(Arrays.asList("4 sesiones individuales", "Seguimiento semanal", "Acceso a contenido premium"));
            monthlyPlan.setDurationMinutes(240);
            monthlyPlan.setIsPopular(true);
            monthlyPlan.setCoachId(coach.getId());
            serviceRepository.save(monthlyPlan);

            Service teamCoaching = new Service("Coaching de Equipo", "Sesion grupal para equipos de 5 jugadores", 100.0, Service.ServiceType.TEAM);
            teamCoaching.setImageUrl("https://via.placeholder.com/300x200");
            teamCoaching.setFeatures(Arrays.asList("Estrategias de equipo", "Comunicacion", "Coordinacion"));
            teamCoaching.setDurationMinutes(90);
            teamCoaching.setCoachId(coach.getId());
            serviceRepository.save(teamCoaching);

            // Nuevos servicios
            Service vodReview = new Service("Análisis de Partidas (VOD Review)", "Revisión detallada de tus partidas para identificar errores y áreas de mejora", 29.99, Service.ServiceType.INDIVIDUAL);
            vodReview.setImageUrl("https://via.placeholder.com/300x200");
            vodReview.setFeatures(Arrays.asList("Análisis detallado", "Feedback personalizado", "Guía de mejora"));
            vodReview.setDurationMinutes(45);
            vodReview.setIsPopular(true);
            vodReview.setCoachId(coach.getId());
            serviceRepository.save(vodReview);

            Service championMastery = new Service("Dominio de Campeón", "Aprende a dominar tu campeón favorito con un coach especializado", 35.0, Service.ServiceType.INDIVIDUAL);
            championMastery.setImageUrl("https://via.placeholder.com/300x200");
            championMastery.setFeatures(Arrays.asList("Combos y mecánicas", "Matchups", "Builds optimizadas"));
            championMastery.setDurationMinutes(60);
            championMastery.setCoachId(coach.getId());
            serviceRepository.save(championMastery);

            Service duoQueue = new Service("Duo Queue", "Juega partidas clasificatorias con tu coach", 40.0, Service.ServiceType.INDIVIDUAL);
            duoQueue.setImageUrl("https://via.placeholder.com/300x200");
            duoQueue.setFeatures(Arrays.asList("3 partidas", "Feedback en tiempo real", "Estrategias de lane"));
            duoQueue.setDurationMinutes(180);
            duoQueue.setCoachId(coach.getId());
            serviceRepository.save(duoQueue);

            System.out.println("📝 creando contenido...");
            
            /*
                creacion de contenido: guia de ward placement, video de analisis de partida y contenido premium
            */
            Content guideContent = new Content("Guia Completa de Ward Placement", "Aprende donde y cuando colocar wards para maximizar la vision", Content.ContentType.GUIDE);
            guideContent.setThumbnailUrl("https://via.placeholder.com/400x250");
            guideContent.setContentUrl("https://example.com/guide1");
            guideContent.setTags(Arrays.asList("vision", "support", "macro"));
            guideContent.setIsPublished(true);
            guideContent.setPublishedAt(LocalDateTime.now().minusDays(5));
            guideContent.setAuthorId(coach.getId());
            guideContent.setContent("Contenido completo de la guia sobre ward placement...");
            contentRepository.save(guideContent);

            Content videoContent = new Content("Analisis de Partida: Como Carriear desde ADC", "Video analisis de una partida profesional", Content.ContentType.VIDEO);
            videoContent.setThumbnailUrl("https://via.placeholder.com/400x250");
            videoContent.setContentUrl("https://example.com/video1");
            videoContent.setTags(Arrays.asList("adc", "carry", "positioning"));
            videoContent.setIsPublished(true);
            videoContent.setPublishedAt(LocalDateTime.now().minusDays(3));
            videoContent.setAuthorId(coach.getId());
            contentRepository.save(videoContent);

            Content premiumContent = new Content("Estrategias Avanzadas de Macro", "Contenido premium sobre macro game avanzado", Content.ContentType.ARTICLE);
            premiumContent.setThumbnailUrl("https://via.placeholder.com/400x250");
            premiumContent.setTags(Arrays.asList("macro", "strategy", "advanced"));
            premiumContent.setIsPremium(true);
            premiumContent.setIsPublished(true);
            premiumContent.setPublishedAt(LocalDateTime.now().minusDays(1));
            premiumContent.setAuthorId(coach.getId());
            premiumContent.setContent("Contenido premium sobre estrategias avanzadas...");
            contentRepository.save(premiumContent);

            // Nuevo contenido
            Content yasuoGuide = new Content("Guía Completa de Yasuo", "Aprende a dominar a Yasuo con esta guía detallada", Content.ContentType.GUIDE);
            yasuoGuide.setThumbnailUrl("https://via.placeholder.com/400x250");
            yasuoGuide.setContentUrl("https://example.com/yasuo-guide");
            yasuoGuide.setTags(Arrays.asList("Yasuo", "Mid", "Guía de Campeón"));
            yasuoGuide.setIsPublished(true);
            yasuoGuide.setPublishedAt(LocalDateTime.now().minusDays(2));
            yasuoGuide.setAuthorId(coach.getId());
            yasuoGuide.setContent("Guía completa sobre Yasuo...");
            contentRepository.save(yasuoGuide);

            Content junglePathing = new Content("Rutas de Jungla Optimizadas", "Aprende las rutas más eficientes para cada campeón jungla", Content.ContentType.VIDEO);
            junglePathing.setThumbnailUrl("https://via.placeholder.com/400x250");
            junglePathing.setContentUrl("https://example.com/jungle-pathing");
            junglePathing.setTags(Arrays.asList("Jungla", "Rutas", "Optimización"));
            junglePathing.setIsPublished(true);
            junglePathing.setPublishedAt(LocalDateTime.now().minusDays(4));
            junglePathing.setAuthorId(coach.getId());
            contentRepository.save(junglePathing);

            Content waveManagement = new Content("Gestión de Olas Avanzada", "Domina el control de las olas de minions", Content.ContentType.ARTICLE);
            waveManagement.setThumbnailUrl("https://via.placeholder.com/400x250");
            waveManagement.setTags(Arrays.asList("Lane", "Wave Management", "Macro"));
            waveManagement.setIsPremium(true);
            waveManagement.setIsPublished(true);
            waveManagement.setPublishedAt(LocalDateTime.now().minusDays(6));
            waveManagement.setAuthorId(coach.getId());
            waveManagement.setContent("Guía avanzada sobre gestión de olas...");
            contentRepository.save(waveManagement);

            System.out.println("💬 creando testimonios...");
            
            /*
                creacion de testimonios con avatar, rango inicial y actual, puntuacion y aprobacion
            */
            Testimonial testimonial1 = new Testimonial("Carlos M.", "Excelente coach, me ayudo a subir de Gold a Platinum en solo 2 semanas", 5);
            testimonial1.setAvatarUrl("https://via.placeholder.com/100");
            testimonial1.setInitialRank("Gold III");
            testimonial1.setCurrentRank("Platinum IV");
            testimonial1.setUserId(player.getId());
            testimonial1.setIsApproved(true);
            testimonialRepository.save(testimonial1);

            Testimonial testimonial2 = new Testimonial("Ana L.", "Las sesiones son muy profesionales y utiles. recomiendo 100%", 5);
            testimonial2.setAvatarUrl("https://via.placeholder.com/100");
            testimonial2.setInitialRank("Silver I");
            testimonial2.setCurrentRank("Gold II");
            testimonial2.setIsApproved(true);
            testimonialRepository.save(testimonial2);

            Testimonial testimonial3 = new Testimonial("Miguel R.", "Mejore mucho mi gameplay gracias a los consejos personalizados", 4);
            testimonial3.setAvatarUrl("https://via.placeholder.com/100");
            testimonial3.setInitialRank("Bronze II");
            testimonial3.setCurrentRank("Silver III");
            testimonial3.setIsApproved(true);
            testimonialRepository.save(testimonial3);

            System.out.println("✅ datos de prueba inicializados correctamente");
            System.out.println("👤 usuarios creados:");
            System.out.println("   - admin: admin@esportscoach.com / admin123");
            System.out.println("   - coach: coach@esportscoach.com / coach123");
            System.out.println("   - player: player@esportscoach.com / player123");
            
        } catch (Exception e) {
            System.err.println("❌ error durante la inicializacion de datos: " + e.getMessage());
            throw e;
        }
    }
}
