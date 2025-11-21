package com.backend.heineken.controller;

import com.backend.heineken.model.Chemical;
import com.backend.heineken.service.QrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/chemicals") // Mantenemos la versión v1
public class ChemicalController {

    private final QrService qrService;

    @Autowired
    public ChemicalController(QrService qrService) {
        this.qrService = qrService;
    }

    // 1. Crear un nuevo químico (Genera el QR automáticamente)
    // POST http://localhost:8080/api/v1/chemicals
    @PostMapping
    public ResponseEntity<Chemical> createChemical(@RequestBody Chemical chemical) {
        // Validación básica
        if (chemical.getQrId() == null || chemical.getQrId().trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        
        // Llamada al servicio
        Chemical saved = qrService.createChemical(chemical);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    // 2. Obtener datos de un químico escaneando el QR
    // GET http://localhost:8080/api/v1/chemicals/{qrId}
    @GetMapping("/{qrId}")
    public ResponseEntity<Chemical> getChemical(@PathVariable String qrId) {
        return qrService.getChemicalByQrId(qrId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 3. Obtener la lista completa de químicos
    // GET http://localhost:8080/api/v1/chemicals
    @GetMapping
    public ResponseEntity<List<Chemical>> getAllChemicals() {
        List<Chemical> list = qrService.getAllChemicals();
        return ResponseEntity.ok(list);
    }

    // 4. Descargar la imagen del QR
    // GET http://localhost:8080/api/v1/chemicals/qr-image/{qrId}
    @GetMapping(value = "/qr-image/{qrId}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> getQrImage(@PathVariable String qrId) {
        try {
            byte[] imageBytes = qrService.generateQrImageBytes(qrId);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            headers.setContentLength(imageBytes.length);
            
            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}