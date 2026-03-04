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

    public ProductSize getByProductAndSize(int productId, int size) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            List<ProductSize> list = em.createQuery(
                    "SELECT ps FROM ProductSize ps "
                    + "WHERE ps.product.id = :pid AND ps.size = :size "
                    + "ORDER BY ps.id",
                    ProductSize.class
            )
                    .setParameter("pid", productId)
                    .setParameter("size", size)
                    .setMaxResults(1)
                    .getResultList();

            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public ProductSize getByProductSizeAndColor(int productId, int size, String color) {
        if (color == null || color.isBlank()) {
            return getByProductAndSize(productId, size);
        }

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            List<ProductSize> list = em.createQuery(
                    "SELECT ps FROM ProductSize ps "
                    + "WHERE ps.product.id = :pid "
                    + "AND ps.size = :size "
                    + "AND UPPER(ps.color) = :color",
                    ProductSize.class
            )
                    .setParameter("pid", productId)
                    .setParameter("size", size)
                    .setParameter("color", color.trim().toUpperCase())
                    .setMaxResults(1)
                    .getResultList();

            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public List<ProductSize> getSizesByProduct(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<ProductSize> list = em.createQuery(
                "SELECT ps FROM ProductSize ps "
                + "WHERE ps.product.id = :pid "
                + "AND ps.quantity > 0 "
                + "ORDER BY ps.color, ps.size",
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
                + "ORDER BY ps.color, ps.size",
                ProductSize.class
        )
                .setParameter("pid", productId)
                .getResultList();

        em.close();
        return list;
    }

    public List<String> getColorsByProduct(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT ps.color FROM ProductSize ps "
                    + "WHERE ps.product.id = :pid "
                    + "AND ps.quantity > 0 "
                    + "AND ps.color IS NOT NULL "
                    + "AND TRIM(ps.color) <> '' "
                    + "ORDER BY ps.color",
                    String.class)
                    .setParameter("pid", productId)
                    .getResultList();
        } finally {
            em.close();
        }
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
