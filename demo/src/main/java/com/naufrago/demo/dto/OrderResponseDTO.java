package com.naufrago.demo.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponseDTO {
    private String hamburgerType;
    private int quantity;
    private double basePricePerHamburger;
    private double totalBaseCost;
    private double creditCardSurchargeAmount;
    private double finalTotal;
}
