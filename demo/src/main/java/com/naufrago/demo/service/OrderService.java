package com.naufrago.demo.service;

import com.naufrago.demo.dto.OrderRequestDTO;
import com.naufrago.demo.dto.OrderResponseDTO;
import com.naufrago.demo.model.Order;
import com.naufrago.demo.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OrderService {

    private final OrderRepository repositorioOrden;

    private static final Map<String, Double> PRECIOS_HAMBURGUESAS = new HashMap<>();
    static {
        PRECIOS_HAMBURGUESAS.put("SIMPLE", 20.00);
        PRECIOS_HAMBURGUESAS.put("DOBLE", 25.00);
        PRECIOS_HAMBURGUESAS.put("TRIPLE", 28.00);
    }

    private static final double TASA_RECARGO_TARJETA_CREDITO = 0.05;

    @Autowired
    public OrderService(OrderRepository orderRepository) {
        this.repositorioOrden = orderRepository;
    }

    public OrderResponseDTO calculateOrderTotal(OrderRequestDTO solicitudDTO) {
        String tipoHamburguesa = solicitudDTO.getHamburgerType().toUpperCase();
        if (!PRECIOS_HAMBURGUESAS.containsKey(tipoHamburguesa)) {
            throw new IllegalArgumentException("Tipo de hamburguesa no válido: " + solicitudDTO.getHamburgerType());
        }

        double precioBasePorHamburguesa = PRECIOS_HAMBURGUESAS.get(tipoHamburguesa);
        double costoTotalBase = precioBasePorHamburguesa * solicitudDTO.getQuantity();
        double totalFinal;
        double montoRecargoTarjetaCredito;

        if (solicitudDTO.isCreditCardPayment()) {
            totalFinal = costoTotalBase * (1 + TASA_RECARGO_TARJETA_CREDITO);
        } else {
            totalFinal = costoTotalBase * 1.00;
        }

        montoRecargoTarjetaCredito = totalFinal - costoTotalBase;

        Order orden = new Order();
        orden.setHamburgerType(tipoHamburguesa);
        orden.setQuantity(solicitudDTO.getQuantity());
        orden.setCreditCardPayment(solicitudDTO.isCreditCardPayment());
        orden.setBasePricePerHamburger(precioBasePorHamburguesa);
        orden.setTotalBaseCost(costoTotalBase);
        orden.setCreditCardSurchargeAmount(montoRecargoTarjetaCredito);
        orden.setFinalTotal(totalFinal);
        orden.setPurchaseDate(LocalDateTime.now());

        repositorioOrden.save(orden);

        OrderResponseDTO respuestaDTO = new OrderResponseDTO();
        respuestaDTO.setHamburgerType(tipoHamburguesa);
        respuestaDTO.setQuantity(solicitudDTO.getQuantity());
        respuestaDTO.setBasePricePerHamburger(precioBasePorHamburguesa);
        respuestaDTO.setTotalBaseCost(costoTotalBase);
        respuestaDTO.setCreditCardSurchargeAmount(montoRecargoTarjetaCredito);
        respuestaDTO.setFinalTotal(totalFinal);

        return respuestaDTO;
    }

    public List<Order> getAllOrders() {
        return repositorioOrden.findAll();
    }
}
