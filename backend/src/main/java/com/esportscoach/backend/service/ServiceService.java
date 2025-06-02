package com.esportscoach.backend.service;

import com.esportscoach.backend.model.Service;
import com.esportscoach.backend.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;

/*
    servicio que gestiona la logica de negocio relacionada con los servicios ofrecidos:
    incluye obtencion de servicios activos, populares, filtrado por tipo, creacion, actualizacion y desactivacion
*/
@org.springframework.stereotype.Service
public class ServiceService {

    /*
        inyeccion del repositorio que opera sobre la coleccion "services" en mongodb
    */
    @Autowired
    private ServiceRepository serviceRepository;

    /*
        metodo para obtener todos los servicios que estan activos (isActive = true)
        retorna lista de objetos Service
    */
    public List<Service> getAllServices() {
        return serviceRepository.findByIsActiveTrue();
    }

    /*
        metodo para obtener los servicios marcados como populares y activos
        utiliza el metodo findByIsActiveTrueAndIsPopularTrue del repositorio
    */
    public List<Service> getPopularServices() {
        return serviceRepository.findByIsActiveTrueAndIsPopularTrue();
    }

    /*
        metodo para obtener servicios activos filtrados por un tipo especifico
        recibe un enum ServiceType (INDIVIDUAL, MONTHLY, COURSE, GUIDE, TEAM)
        y delega en findByIsActiveTrueAndType del repositorio
    */
    public List<Service> getServicesByType(Service.ServiceType type) {
        return serviceRepository.findByIsActiveTrueAndType(type);
    }

    /*
        metodo para buscar un servicio por su identificador unico
        retorna Optional<Service> para manejar ausencia de registro
    */
    public Optional<Service> getServiceById(String id) {
        return serviceRepository.findById(id);
    }

    /*
        metodo para crear un nuevo servicio
        recibe un objeto Service y lo guarda en la base de datos sin validaciones adicionales
    */
    public Service createService(Service service) {
        return serviceRepository.save(service);
    }

    /*
        metodo para actualizar un servicio existente:
        - busca el servicio por id, si no existe lanza excepcion
        - actualiza campos basicos: titulo, descripcion, precio, tipo, url de imagen, caracteristicas, duracion, flags de popular y activo
        - guarda y retorna el objeto modificado
    */
    public Service updateService(String id, Service serviceDetails) {
        Service service = serviceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("service not found with id: " + id));

        service.setTitle(serviceDetails.getTitle());
        service.setDescription(serviceDetails.getDescription());
        service.setPrice(serviceDetails.getPrice());
        service.setType(serviceDetails.getType());
        service.setImageUrl(serviceDetails.getImageUrl());
        service.setFeatures(serviceDetails.getFeatures());
        service.setDurationMinutes(serviceDetails.getDurationMinutes());
        service.setIsPopular(serviceDetails.getIsPopular());
        service.setIsActive(serviceDetails.getIsActive());

        return serviceRepository.save(service);
    }

    /*
        metodo para eliminar (desactivar) un servicio:
        - busca el servicio por id, si no existe lanza excepcion
        - en lugar de borrar fisicamente, marca isActive como false y guarda el cambio
    */
    public void deleteService(String id) {
        Service service = serviceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("service not found with id: " + id));
        
        service.setIsActive(false);
        serviceRepository.save(service);
    }
}
