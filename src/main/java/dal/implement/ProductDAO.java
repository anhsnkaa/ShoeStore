/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.Product;

/**
 *
 * @author FPTShop
 */
public class ProductDAO {

    public List<Product> getAllProducts() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();

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
    
    public List<Product> getProductByCategory(int categoryId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p Where p.category.id = :cid",Product.class).setParameter("cid",categoryId).getResultList();

        em.close();
        return list;
    }
    
    public List<Product> getProductByKeyword(String keyword) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery("SELECT p FROM Product p Where p.name LIKE :kw",Product.class).setParameter("kw","%"+ keyword + "%").getResultList();

        em.close();
        return list;
    }
}
