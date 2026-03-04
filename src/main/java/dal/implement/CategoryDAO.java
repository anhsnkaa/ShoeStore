/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.Category;
import model.Gender;

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

    public List<Category> getCategoriesByGender(String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            return em.createQuery(
                    "SELECT DISTINCT c FROM Category c "
                    + "JOIN c.products p "
                    + "WHERE p.gender = :gender "
                    + "ORDER BY c.name",
                    Category.class
            )
                    .setParameter("gender", Gender.valueOf(gender))
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void addCategory(Category c) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        em.getTransaction().begin();
        em.persist(c);
        em.getTransaction().commit();

        em.close();
    }
}
