/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.Category;

/**
 *
 * @author FPTShop
 */
public class CategoryDAO {

    public List<Category> getAllCategories() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Category> list
                = em.createQuery("SELECT c FROM Category c",
                        Category.class)
                        .getResultList();

        em.close();
        return list;
    }

    public Category findById(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        Category c = em.find(Category.class, id);
        em.close();
        return c;
    }

    public void addCategory(Category c) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        em.getTransaction().begin();
        em.persist(c);
        em.getTransaction().commit();

        em.close();
    }
}
