/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
public class ProductSizeDAO {

    public ProductSize getSizeById(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        ProductSize ps = em.find(ProductSize.class, id);
        em.close();
        return ps;
    }

    public List<ProductSize> getSizesByProduct(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<ProductSize> list = em.createQuery(
                "SELECT ps FROM ProductSize ps "
                + "WHERE ps.product.id = :pid "
                + "AND ps.quantity > 0",
                ProductSize.class)
                .setParameter("pid", productId)
                .getResultList();

        em.close();
        return list;
    }

    public List<ProductSize> getQuantityOfSizes(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<ProductSize> list = em.createQuery(
                "SELECT ps FROM ProductSize ps "
                + "WHERE ps.product.id = :pid "
                + "ORDER BY ps.size",
                ProductSize.class
        )
                .setParameter("pid", productId)
                .getResultList();

        em.close();
        return list;
    }

    public void addProductSize(ProductSize ps) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        em.getTransaction().begin();
        em.persist(ps);
        em.getTransaction().commit();

        em.close();
    }

    public void deleteByProductId(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        em.createQuery("DELETE FROM ProductSize ps WHERE ps.product.id = :pid")
                .setParameter("pid", productId)
                .executeUpdate();

        em.getTransaction().commit();
        em.close();
    }
}
