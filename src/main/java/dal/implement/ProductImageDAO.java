/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import jakarta.persistence.TypedQuery;
import java.util.List;
import model.ProductImage;

public class ProductImageDAO {

    // 🔹 Thêm ảnh
    public void add(ProductImage image) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            em.getTransaction().begin();
            em.persist(image);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 🔹 Lấy tất cả ảnh của 1 product
    public List<ProductImage> getByProductId(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            String jpql = "SELECT pi FROM ProductImage pi WHERE pi.product.id = :pid";
            TypedQuery<ProductImage> query = em.createQuery(jpql, ProductImage.class);
            query.setParameter("pid", productId);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // 🔹 Lấy ảnh chính (thumbnail + main)
    public ProductImage getMainImage(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            String jpql = "SELECT pi FROM ProductImage pi WHERE pi.product.id = :pid AND pi.isMain = true";
            TypedQuery<ProductImage> query = em.createQuery(jpql, ProductImage.class);
            query.setParameter("pid", productId);

            List<ProductImage> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);

        } finally {
            em.close();
        }
    }

    // 🔹 Xóa ảnh theo id
    public void delete(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            em.getTransaction().begin();

            ProductImage image = em.find(ProductImage.class, id);
            if (image != null) {
                em.remove(image);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 🔹 Xóa toàn bộ ảnh theo product
    public void deleteByProduct(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            em.getTransaction().begin();

            String jpql = "DELETE FROM ProductImage pi WHERE pi.product.id = :pid";
            em.createQuery(jpql)
                    .setParameter("pid", productId)
                    .executeUpdate();

            em.getTransaction().commit();

        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public void deleteByProductId(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();
            em.createQuery("DELETE FROM ProductImage pi WHERE pi.product.id = :pid")
                    .setParameter("pid", productId)
                    .executeUpdate();
            trans.commit();
        } catch (Exception e) {
            trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
