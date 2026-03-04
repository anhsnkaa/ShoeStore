/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.*;

/**
 *
 * @author FPTShop
 */
@Entity
@Table(name = "ProductSizes")
public class ProductSize {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "color", columnDefinition = "NVARCHAR(100)")
    private String color;
    
    private int size;
    
    private int quantity;
    
    //nhiều size thuộc một product
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    public ProductSize() {
    }

    public ProductSize(int size, int quantity, Product product) {
        this.size = size;
        this.quantity = quantity;
        this.product = product;
    }

    public ProductSize(String color, int size, int quantity, Product product) {
        setColor(color);
        this.size = size;
        this.quantity = quantity;
        this.product = product;
    }

    public int getId() {
        return id;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        if (color == null || color.isBlank()) {
            this.color = null;
            return;
        }

        this.color = color.trim().toUpperCase();
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public String toString() {
        return String.format("%s %s %s", color, size, quantity);
    }
    
    
}
