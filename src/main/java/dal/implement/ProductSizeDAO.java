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

    public List<ProductSize> getSizesByProduct(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<ProductSize> list
                = em.createQuery(
                        "SELECT ps FROM ProductSize ps WHERE ps.product.id = :pid",
                        ProductSize.class)
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
}
