package com.backend.heineken.model;

import java.util.List;

/**
 * Objeto simple para representar el químico.
 * Firestore lo guardará como un documento JSON.
 * No requiere anotaciones SQL (@Entity, @Table, etc.).
 */
public class Chemical {

    // Este campo se usará como el ID del documento en Firestore
    private String qrId; 
    
    private String name;
    
    private String location;

    // Firestore guarda listas automáticamente como arrays JSON
    private List<String> ghsCodes;
    
    private List<String> requiredEpp;
    
    private String raVideoUrl;

    private String safeProcedure;

    // --- Constructores ---

    // Constructor vacío (OBLIGATORIO para que Firebase pueda deserializar los datos)
    public Chemical() {
    }

    // Constructor completo para facilitar la creación de objetos
    public Chemical(String qrId, String name, String location, List<String> ghsCodes, List<String> requiredEpp, String raVideoUrl, String safeProcedure) {
        this.qrId = qrId;
        this.name = name;
        this.location = location;
        this.ghsCodes = ghsCodes;
        this.requiredEpp = requiredEpp;
        this.raVideoUrl = raVideoUrl;
        this.safeProcedure = safeProcedure;
    }

    // --- Getters y Setters (Necesarios para Firebase) ---

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