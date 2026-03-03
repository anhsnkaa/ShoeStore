/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.Collections;
import java.util.List;
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

    public List<Order> getOrdersByUserId(int userId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Order> query = em.createQuery(
                    "SELECT DISTINCT o FROM Order o "
                    + "LEFT JOIN FETCH o.user u "
                    + "LEFT JOIN FETCH o.orderDetails od "
                    + "LEFT JOIN FETCH od.product p "
                    + "WHERE u.id = :userId "
                    + "ORDER BY o.createdDate DESC",
                    Order.class
            );
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public List<Order> getAllOrders() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Order> query = em.createQuery(
                    "SELECT DISTINCT o FROM Order o "
                    + "LEFT JOIN FETCH o.user u "
                    + "LEFT JOIN FETCH o.orderDetails od "
                    + "LEFT JOIN FETCH od.product p "
                    + "ORDER BY o.createdDate DESC",
                    Order.class
            );
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public Order getOrderById(int orderId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Order> query = em.createQuery(
                    "SELECT DISTINCT o FROM Order o "
                    + "LEFT JOIN FETCH o.user u "
                    + "LEFT JOIN FETCH o.orderDetails od "
                    + "LEFT JOIN FETCH od.product p "
                    + "WHERE o.id = :orderId",
                    Order.class
            );
            query.setParameter("orderId", orderId);
            List<Order> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            int updated = em.createQuery(
                    "UPDATE Order o SET o.status = :status WHERE o.id = :orderId"
            )
                    .setParameter("status", status)
                    .setParameter("orderId", orderId)
                    .executeUpdate();
            em.getTransaction().commit();
            return updated > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
