package com.backend.heineken.repository;

import com.backend.heineken.model.Chemical;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repositorio JPA para la entidad Chemical.
 * Permite la interacción con la base de datos usando el ID (String) de la entidad.
 */
@Repository
public interface ChemicalRepository extends JpaRepository<Chemical, String> {
    // Spring Data JPA automáticamente implementa métodos como save(), findById(), etc.
}