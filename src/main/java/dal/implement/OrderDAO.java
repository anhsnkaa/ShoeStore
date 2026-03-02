/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import model.Account;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author FPTShop
 */
public class OrderDAO {

    public int insertOrder(Order order) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            if (order == null || order.getOrderDetails() == null || order.getOrderDetails().isEmpty()) {
                return -1;
            }
            em.getTransaction().begin();

            if (order.getUser() != null && order.getUser().getId() > 0) {
                Account managedUser = em.getReference(Account.class, order.getUser().getId());
                order.setUser(managedUser);
            }

            // đảm bảo liên kết 2 chiều trước khi persist
            for (OrderDetail detail : order.getOrderDetails()) {
                detail.setOrder(order);
            }
            order.calculateTotal();
            em.persist(order); // CascadeType.ALL sẽ lưu luôn OrderDetail
            em.getTransaction().commit();
            return order.getId();
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
