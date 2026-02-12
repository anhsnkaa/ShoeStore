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

    public int getId() {
        return id;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
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
    
    
}
