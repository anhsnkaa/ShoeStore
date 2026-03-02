/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private double totalAmount;

    private String status;

    private LocalDateTime createdDate;

    // ===== RELATION =====
    @ManyToOne
    @JoinColumn(name = "user_id")
    private Account user;

    @OneToMany(mappedBy = "order",
            cascade = CascadeType.ALL,
            orphanRemoval = true)
    private List<OrderDetail> orderDetails = new ArrayList<>();

    // ===== CONSTRUCTOR =====
    public Order() {
        this.createdDate = LocalDateTime.now();
        this.status = "PENDING";
    }

    // ===== BUSINESS METHOD =====
    public void addOrderDetail(OrderDetail detail) {
        orderDetails.add(detail);
        detail.setOrder(this);
    }

    public void calculateTotal() {
        this.totalAmount = orderDetails.stream()
                .mapToDouble(OrderDetail::getTotalPrice)
                .sum();
    }
    // getters setters

    public double getTotal() {
        double total = 0;

        for (OrderDetail od : orderDetails) {
            total += od.getPrice() * od.getQuantity();
        }

        return total;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public Account getUser() {
        return user;
    }

    public void setUser(Account user) {
        this.user = user;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

}
