package com.backend.heineken.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @Value("${FIREBASE_CREDENTIALS}")
    private String firebaseCredentialsPath;

    @Value("${firebase.storage.bucket-name}")
    private String bucketName;

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        if (!FirebaseApp.getApps().isEmpty()) {
            return FirebaseApp.getInstance();
        }

        // Cargar credenciales
        try (FileInputStream serviceAccount = new FileInputStream(firebaseCredentialsPath)) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setStorageBucket(bucketName)
                    // Nota: setDatabaseUrl es opcional si solo usas Firestore, 
                    // pero necesario si usas Realtime Database.
                    .setDatabaseUrl("https://qrgenerator-ec984.firebaseio.com") 
                    .build();

            System.out.println("🔥 Inicializando Firebase con: " + firebaseCredentialsPath);
            return FirebaseApp.initializeApp(options);
        }
    }

    @Bean
    public Firestore firestore(FirebaseApp firebaseApp) {
        return FirestoreClient.getFirestore(firebaseApp);
    }

    @Bean
    public Storage storage() throws IOException {
        // Para Google Cloud Storage puro, necesitamos configurar las credenciales explícitamente
        // igual que en FirebaseApp para evitar errores de "Application Default Credentials" en local.
        try (FileInputStream serviceAccount = new FileInputStream(firebaseCredentialsPath)) {
            return StorageOptions.newBuilder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build()
                    .getService();
        }
    }
}