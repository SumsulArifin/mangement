package com.example.springApp.Entities;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.*;



@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull(message = "name can not be null")
    private String name;
    @NotNull(message = "description can not be null")
    private String description;
    @NotNull(message = "image can not be null")
    private String image;
    @NotNull(message = "price can not be null")
    private double price;

}
