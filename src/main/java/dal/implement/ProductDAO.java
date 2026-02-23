/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.PageControl;
import model.Product;

/**
 *
 * @author FPTShop
 */
public class ProductDAO {

    public List<Product> getAllProducts(int page) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p", Product.class)
                .setFirstResult((page - 1) * 12)
                .setMaxResults(12)
                .getResultList();
        em.close();
        return list;
    }

    public void addProduct(Product p) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();
        em.persist(p);
        em.getTransaction().commit();
        em.close();
    }

    public Product getProductById(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        Product p = em.find(Product.class, id);
        em.close();
        return p;
    }

    public List<Product> getProductByCategory(int categoryId, int page) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p Where p.category.id = :cid", Product.class).setParameter("cid", categoryId)
                .setFirstResult((page - 1) * 12)
                .setMaxResults(12)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getProductByKeyword(String keyword, int page) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p Where p.name LIKE :kw", Product.class).setParameter("kw", "%" + keyword + "%")
                .setFirstResult((page - 1) * 12)
                .setMaxResults(12)
                .getResultList();

        em.close();
        return list;
    }

    public int getTotalRecordByCategory(int categoryId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.category.id = :cid",
                Long.class)
                .setParameter("cid", categoryId)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByKeyword(String keyword) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.name LIKE :kw",
                Long.class)
                .setParameter("kw", "%" + keyword + "%")
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalProducts() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p",
                Long.class)
                .getSingleResult();

        em.close();

        return total.intValue();   // ép sang int
    }
}
