/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.Account;

/**
 *
 * @author FPTShop
 */
public class AccountDAO {

    public List<Account> getAllAccounts() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Account> list = em.createQuery(
                "SELECT a FROM Account a", Account.class)
                .getResultList();

        em.close();
        return list;
    }

    public Account findById(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Account acc = em.find(Account.class, id);

        em.close();
        return acc;
    }

    public boolean isUsernameExists(String username) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Account a WHERE a.username = :user",
                Long.class)
                .setParameter("user", username)
                .getSingleResult();

        em.close();

        return count > 0;
    }

    public Account findByUsernameAndPass(String username, String password) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            return em.createQuery(
                    "SELECT a FROM Account a "
                    + "WHERE a.username = :user "
                    + "AND a.password = :pass "
                    + "AND a.status = true",
                    Account.class)
                    .setParameter("user", username)
                    .setParameter("pass", password)
                    .getSingleResult();

        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public void addAccount(Account acc) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            em.getTransaction().begin();

            em.persist(acc);   // Lưu vào DB

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public boolean updatePassword(int accountId, String newPassword) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            Account acc = em.find(Account.class, accountId);
            if (acc == null) {
                em.getTransaction().rollback();
                return false;
            }
            acc.setPassword(newPassword);
            em.getTransaction().commit();
            return true;
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

    public boolean isEmailExistsExceptId(int accountId, String email) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(a) FROM Account a WHERE a.email = :email AND a.id <> :id",
                    Long.class
            )
                    .setParameter("email", email)
                    .setParameter("id", accountId)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    public boolean updateProfile(Account updated) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            Account acc = em.find(Account.class, updated.getId());
            if (acc == null) {
                em.getTransaction().rollback();
                return false;
            }
            acc.setFullName(updated.getFullName());
            acc.setEmail(updated.getEmail());
            acc.setPhone(updated.getPhone());
            acc.setAddress(updated.getAddress());
            em.getTransaction().commit();
            return true;
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
