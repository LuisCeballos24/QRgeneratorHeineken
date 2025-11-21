package com.backend.heineken.model;

import jakarta.persistence.*;
import java.util.List;

/**
 * Entidad JPA que representa un químico en la base de datos.
 * Esta clase mapea a una tabla donde se almacenarán todos los detalles
 * del producto químico.
 */
@Entity
@Table(name = "quimicos") // Define explícitamente el nombre de la tabla en la base de datos
public class Chemical {

    @Id
    // El ID del QR será la clave primaria, ya que es único por contenedor/producto
    @Column(name = "qr_id", unique = true, nullable = false)
    private String qrId; 
    
    @Column(nullable = false)
    private String name;
    
    private String location;

    // Utilizamos @ElementCollection para almacenar listas de Strings. 
    // Esto creará tablas secundarias automáticamente para mantener la normalización (1 a muchos).
    
    @ElementCollection(fetch = FetchType.EAGER) // EAGER carga los datos inmediatamente al consultar el químico
    @CollectionTable(name = "quimico_ghs_codes", joinColumns = @JoinColumn(name = "qr_id"))
    @Column(name = "ghs_code")
    private List<String> ghsCodes;
    
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "quimico_epp_required", joinColumns = @JoinColumn(name = "qr_id"))
    @Column(name = "epp_item")
    private List<String> requiredEpp;
    
    @Column(name = "ra_video_url", columnDefinition = "TEXT") // TEXT permite URLs largas
    private String raVideoUrl;

    @Column(name = "safe_procedure", columnDefinition = "TEXT") // TEXT permite descripciones largas
    private String safeProcedure;

    // --- Constructores ---

    // Constructor vacío requerido por JPA
    public Chemical() {
    }

    // Constructor completo para crear instancias fácilmente
    public Chemical(String qrId, String name, String location, List<String> ghsCodes, List<String> requiredEpp, String raVideoUrl, String safeProcedure) {
        this.qrId = qrId;
        this.name = name;
        this.location = location;
        this.ghsCodes = ghsCodes;
        this.requiredEpp = requiredEpp;
        this.raVideoUrl = raVideoUrl;
        this.safeProcedure = safeProcedure;
    }

    // --- Getters y Setters ---

    public String getQrId() {
        return qrId;
    }

    public void setQrId(String qrId) {
        this.qrId = qrId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public List<String> getGhsCodes() {
        return ghsCodes;
    }

    public void setGhsCodes(List<String> ghsCodes) {
        this.ghsCodes = ghsCodes;
    }

    public List<String> getRequiredEpp() {
        return requiredEpp;
    }

    public void setRequiredEpp(List<String> requiredEpp) {
        this.requiredEpp = requiredEpp;
    }

    public String getRaVideoUrl() {
        return raVideoUrl;
    }

    public void setRaVideoUrl(String raVideoUrl) {
        this.raVideoUrl = raVideoUrl;
    }

    public String getSafeProcedure() {
        return safeProcedure;
    }

    public void setSafeProcedure(String safeProcedure) {
        this.safeProcedure = safeProcedure;
    }
}