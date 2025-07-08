package com.example.bdd_dto.repository;

import com.example.bdd_dto.model.Automovil;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AutomovilRepository extends JpaRepository<Automovil, Long> {
    // Métodos básicos ya proporcionados por JpaRepository
}