package com.example.contactapi.service;

import com.example.contactapi.dto.ContactDTO;
import com.example.contactapi.model.Contact;
import com.example.contactapi.repository.ContactRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ContactService {

    @Autowired
    private ContactRepository repository;

    public List<Contact> listar() {
        return repository.findAll();
    }

    public Optional<Contact> obtener(Long id) {
        return repository.findById(id);
    }

    public Contact guardar(ContactDTO dto) {
        Contact contacto = new Contact();
        contacto.setNombre(dto.getNombre());
        contacto.setEmpresa(dto.getEmpresa());
        contacto.setNumero(dto.getNumero());
        contacto.setFoto(dto.getFoto());
        return repository.save(contacto);
    }

    public Contact actualizar(Long id, ContactDTO dto) {
        Contact contacto = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Contacto no encontrado"));
        contacto.setNombre(dto.getNombre());
        contacto.setEmpresa(dto.getEmpresa());
        contacto.setNumero(dto.getNumero());
        contacto.setFoto(dto.getFoto());
        return repository.save(contacto);
    }

    public void eliminar(Long id) {
        repository.deleteById(id);
    }
}
