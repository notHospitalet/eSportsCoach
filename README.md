# eSportsCoach - Aplicación Flutter con Spring Boot

Este proyecto consiste en una aplicación de coaching para eSports con una arquitectura de frontend y backend separados.

## Estructura del Proyecto

```
eSportsCoach/
├── frontend/          # Aplicación Flutter
└── backend/           # Aplicación Spring Boot
```

## Requisitos Previos

### Frontend (Flutter)
- Flutter SDK (última versión estable)
- Dart SDK
- Android Studio / VS Code con extensiones de Flutter
- Un emulador Android o dispositivo iOS para pruebas

### Backend (Spring Boot)
- Java JDK 17 o superior
- Maven
- IDE (recomendado: IntelliJ IDEA o Spring Tool Suite)

## Configuración del Frontend

1. Navegar al directorio frontend:
```bash
cd frontend
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Ejecutar la aplicación:
```bash
flutter run
```

## Configuración del Backend

1. Navegar al directorio backend:
```bash
cd backend
```

2. Compilar el proyecto:
```bash
./mvnw clean install
```

3. Ejecutar la aplicación:
```bash
./mvnw spring-boot:run
```

## Características Principales

- Frontend en Flutter para una experiencia de usuario multiplataforma
- Backend en Spring Boot para una API REST robusta
- Arquitectura moderna y escalable
- Soporte para autenticación y autorización
- Integración con bases de datos

## Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request 