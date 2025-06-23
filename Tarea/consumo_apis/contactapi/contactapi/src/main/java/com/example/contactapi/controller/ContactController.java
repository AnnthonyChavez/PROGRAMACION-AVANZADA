package com.example.contactapi.controller;

import com.example.contactapi.dto.ContactDTO;
import com.example.contactapi.model.Contact;
import com.example.contactapi.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contactos")
public class ContactController {

    @Autowired
    private ContactService service;

    @GetMapping
    public List<Contact> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Contact> obtener(@PathVariable Long id) {
        return service.obtener(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Contact> crear(@RequestBody ContactDTO dto) {
        return ResponseEntity.ok(service.guardar(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Contact> actualizar(@PathVariable Long id, @RequestBody ContactDTO dto) {
        return ResponseEntity.ok(service.actualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
