package model;

import jakarta.persistence.*;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author FPTShop
 */
@Entity
@Table(name = "Accounts")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(unique = true, nullable = false)
    private String username;

    private String password;

    @Column(unique = true)
    private String email;

    private String phone;

    private String address;

    private boolean status = true;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
}
