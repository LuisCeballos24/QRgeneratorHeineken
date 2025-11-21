package com.backend.heineken.service;

import com.backend.heineken.model.Chemical;
import java.util.List;
import com.backend.heineken.repository.ChemicalRepository;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Collections;
import java.util.Optional;

@Service
public class QrService {

    private final ChemicalRepository chemicalRepository;
    private static final int QR_SIZE = 300;

    @Autowired
    public QrService(ChemicalRepository chemicalRepository) {
        this.chemicalRepository = chemicalRepository;
    }

    public Chemical createChemical(Chemical chemical) {
        try {
            // 1. Guardar en Firestore
            chemicalRepository.save(chemical);

            // 2. Retornamos el objeto (el QR se genera bajo demanda en el endpoint GET /qr-image)
            return chemical;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error guardando en Firestore: " + e.getMessage());
        }
    }

    public Optional<Chemical> getChemicalByQrId(String qrId) {
        try {
            return chemicalRepository.findById(qrId);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    public List<Chemical> getAllChemicals() {
        try {
            return chemicalRepository.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public byte[] generateQrImageBytes(String text) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, QR_SIZE, QR_SIZE);

        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
        return pngOutputStream.toByteArray();
    }
}