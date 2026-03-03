/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.Collections;
import java.util.List;
import model.Account;
import model.Product;
import model.Question;

public class QuestionDAO {

    public int insertQuestion(Question question) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            if (question == null
                    || question.getUser() == null
                    || question.getUser().getId() <= 0
                    || question.getProduct() == null
                    || question.getProduct().getId() <= 0
                    || question.getContent() == null
                    || question.getContent().trim().isEmpty()) {
                return -1;
            }

            em.getTransaction().begin();

            Account managedUser = em.getReference(Account.class, question.getUser().getId());
            Product managedProduct = em.getReference(Product.class, question.getProduct().getId());
            question.setUser(managedUser);
            question.setProduct(managedProduct);

            em.persist(question);
            em.getTransaction().commit();
            return question.getId();
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

    public Question findById(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            return em.find(Question.class, id);
        } finally {
            em.close();
        }
    }

    public List<Question> getApprovedByProductId(int productId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Question> query = em.createQuery(
                    "SELECT q FROM Question q "
                    + "JOIN FETCH q.user u "
                    + "WHERE q.product.id = :productId "
                    + "AND q.status = 'APPROVED' "
                    + "ORDER BY q.createdDate DESC",
                    Question.class
            );
            query.setParameter("productId", productId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public List<Question> getPendingQuestions() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Question> query = em.createQuery(
                    "SELECT q FROM Question q "
                    + "JOIN FETCH q.user u "
                    + "JOIN FETCH q.product p "
                    + "WHERE q.status = 'PENDING' "
                    + "ORDER BY q.createdDate DESC",
                    Question.class
            );
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public boolean updateQuestionStatus(int questionId, String status) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            int updated = em.createQuery(
                    "UPDATE Question q SET q.status = :status WHERE q.id = :id"
            )
                    .setParameter("status", status)
                    .setParameter("id", questionId)
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

    public int getPendingQuestionCount() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            Long total = em.createQuery(
                    "SELECT COUNT(q) FROM Question q WHERE q.status = 'PENDING'",
                    Long.class
            ).getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }
}
