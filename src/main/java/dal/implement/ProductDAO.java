/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.Gender;
import model.PageControl;
import model.Product;

/**
 *
 * @author FPTShop
 */
public class ProductDAO {

    public List<Product> getAllProducts() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery(
                "SELECT DISTINCT p FROM Product p "
                + "LEFT JOIN FETCH p.images",
                Product.class
        ).getResultList();

        em.close();
        return list;
    }

    public List<Product> getAllProductsPaging(int page) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery(
                "SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.images",
                Product.class)
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

    public void deleteProduct(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        Product p = em.find(Product.class, id);

        if (p != null) {
            em.remove(p);
        }

        em.getTransaction().commit();
        em.close();
    }

    public Product getProductById(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Product product = em.createQuery(
                "SELECT p FROM Product p "
                + "LEFT JOIN FETCH p.images "
                + "WHERE p.id = :id",
                Product.class
        )
                .setParameter("id", id)
                .getSingleResult();

        em.close();
        return product;
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

    public void deleteByProduct(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        em.createQuery("DELETE FROM ProductSize ps WHERE ps.product.id = :id")
                .setParameter("id", productId)
                .executeUpdate();

        em.getTransaction().commit();
        em.close();
    }

    public void updateProduct(Product p) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        em.merge(p);

        em.getTransaction().commit();
        em.close();
    }

    public List<Product> getProductByGender(String gender, int page) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery(
                "SELECT p FROM Product p WHERE p.gender = :gender",
                Product.class
        )
                .setParameter("gender", Gender.valueOf(gender)) // 🔥 QUAN TRỌNG
                .setFirstResult((page - 1) * 12)
                .setMaxResults(12)
                .getResultList();

        em.close();
        return list;
    }

    public int getTotalRecordByGender(String gender) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.gender = :gender",
                Long.class
        )
                .setParameter("gender", Gender.valueOf(gender)) // 🔥 QUAN TRỌNG
                .getSingleResult();

        em.close();
        return total.intValue();
    }
}