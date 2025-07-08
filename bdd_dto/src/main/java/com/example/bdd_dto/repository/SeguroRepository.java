package com.example.bdd_dto.repository;

import com.example.bdd_dto.model.Seguro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SeguroRepository extends JpaRepository<Seguro, Long> {

    // Método existente: Busca un seguro por el ID de su automóvil
    Optional<Seguro> findByAutomovilId(Long automovilId);

    // Método existente: Elimina un seguro por el ID de su automóvil
    void deleteByAutomovilId(Long automovilId);

    // --- Nuevos métodos para la funcionalidad de búsqueda ---

    /**
     * Busca seguros por el modelo del automóvil, ignorando mayúsculas y minúsculas.
     * Usa la palabra clave 'ContainingIgnoreCase' de Spring Data JPA.
     * @param modelo El modelo del automóvil a buscar.
     * @return Una lista de seguros que coinciden con el modelo.
     */
    List<Seguro> findByAutomovilModeloContainingIgnoreCase(String modelo);

    /**
     * Busca seguros por el nombre o apellido del propietario, ignorando mayúsculas y minúsculas.
     * Utiliza una consulta JPQL personalizada.
     * @param nombrePropietario El nombre o apellido (o parte de él) del propietario a buscar.
     * @return Una lista de seguros cuyos propietarios coinciden con el nombre/apellido.
     */
    @Query("SELECT s FROM Seguro s WHERE LOWER(s.automovil.propietario.nombre) LIKE LOWER(CONCAT('%', :nombrePropietario, '%')) OR LOWER(s.automovil.propietario.apellido) LIKE LOWER(CONCAT('%', :nombrePropietario, '%'))")
    List<Seguro> findByPropietarioNombreContainingIgnoreCase(@Param("nombrePropietario") String nombrePropietario);
}