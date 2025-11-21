package com.backend.heineken.repository;

import com.backend.heineken.model.Chemical;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

import java.util.Optional;
import java.util.concurrent.ExecutionException;

@Repository
public class ChemicalRepository {

    @Autowired
    private Firestore firestore;
    public List<Chemical> findAll() throws ExecutionException, InterruptedException {
        List<Chemical> chemicals = firestore.collection(COLLECTION_NAME)
                .get()
                .get()
                .toObjects(Chemical.class);
        return chemicals;
    }

    private static final String COLLECTION_NAME = "quimicos";

    /**
     * Guarda un químico en la colección 'quimicos' usando el qrId como ID del documento.
     */
    public String save(Chemical chemical) throws ExecutionException, InterruptedException {
        ApiFuture<WriteResult> future = firestore.collection(COLLECTION_NAME)
                .document(chemical.getQrId())
                .set(chemical);
        
        // Retorna el timestamp de la actualización
        return future.get().getUpdateTime().toString();
    }

    /**
     * Busca un documento por ID.
     */
    public Optional<Chemical> findById(String qrId) throws ExecutionException, InterruptedException {
        DocumentReference docRef = firestore.collection(COLLECTION_NAME).document(qrId);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();

        if (document.exists()) {
            return Optional.ofNullable(document.toObject(Chemical.class));
        } else {
            return Optional.empty();
        }
    }
}