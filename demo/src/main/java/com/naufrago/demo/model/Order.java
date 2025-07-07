package com.naufrago.demo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String hamburgerType;

    @Column(nullable = false)
    private int quantity;

    @Column(nullable = false)
    private boolean isCreditCardPayment;

    @Column(nullable = false)
    private double basePricePerHamburger;

    @Column(nullable = false)
    private double totalBaseCost;

    @Column(nullable = false)
    private double creditCardSurchargeAmount;

    @Column(nullable = false)
    private double finalTotal;

    @Column(nullable = false)
    private LocalDateTime purchaseDate;
}
