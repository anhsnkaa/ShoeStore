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
}
