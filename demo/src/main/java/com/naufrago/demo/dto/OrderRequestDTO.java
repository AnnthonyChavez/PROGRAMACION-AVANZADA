package com.naufrago.demo.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderRequestDTO {
    private String hamburgerType;
    private int quantity;
    @JsonProperty("isCreditCardPayment")
    private boolean isCreditCardPayment;
}