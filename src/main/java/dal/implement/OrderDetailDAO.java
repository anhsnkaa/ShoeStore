/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.EntityManager;
import model.OrderDetail;

/**
 *
 * @author FPTShop
 */
public class OrderDetailDAO {

    public int insertOrderDetail(OrderDetail orderDetail) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            if (orderDetail == null
                    || orderDetail.getOrder() == null
                    || orderDetail.getProduct() == null) {
                return -1;
            }

            em.getTransaction().begin();
            em.persist(orderDetail);
            em.getTransaction().commit();
            return orderDetail.getId();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

}
