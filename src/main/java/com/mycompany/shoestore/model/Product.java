/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.shoestore.model;

import model.*;
import jakarta.persistence.*;
import java.util.List;

/**
 *
 * @author FPTShop
 */
@Entity
@Table(name = "Products")

public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(columnDefinition = "NVARCHAR(150)")
    private String name;
    
    private String img;
    private double price;
    
    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String description;
    
    // nhiều product thuộc 1 category
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
    
    // 1 product có nhiều size
    @OneToMany(mappedBy = "product")
    private List<ProductSize> sizes;

    public Product() {
    }

    public Product(String name, String img, double price, String description, Category category) {
        this.name = name;
        this.img = img;
        this.price = price;
        this.description = description;
        this.category = category;
    }

    public int getId() {
        return id;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductSize> getSizes() {
        return sizes;
    }

    public void setSizes(List<ProductSize> sizes) {
        this.sizes = sizes;
    }
    

}
