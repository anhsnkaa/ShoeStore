/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Blogs")
public class Blog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    private String thumbnail;

    private LocalDateTime createdDate;

    private boolean status; // true = hiển thị

    @ManyToOne
    @JoinColumn(name = "author_id")
    private Account author;
}
