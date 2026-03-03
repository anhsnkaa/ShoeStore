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
import model.Answer;
import model.Question;

public class AnswerDAO {

    public int insertAnswer(Answer answer) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            if (answer == null
                    || answer.getUser() == null
                    || answer.getUser().getId() <= 0
                    || answer.getQuestion() == null
                    || answer.getQuestion().getId() <= 0
                    || answer.getContent() == null
                    || answer.getContent().trim().isEmpty()) {
                return -1;
            }

            em.getTransaction().begin();

            Account managedUser = em.getReference(Account.class, answer.getUser().getId());
            Question managedQuestion = em.getReference(Question.class, answer.getQuestion().getId());
            answer.setUser(managedUser);
            answer.setQuestion(managedQuestion);

            em.persist(answer);
            em.getTransaction().commit();
            return answer.getId();
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

    public Answer findById(int id) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            return em.find(Answer.class, id);
        } finally {
            em.close();
        }
    }

    public List<Answer> getApprovedByQuestionId(int questionId) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Answer> query = em.createQuery(
                    "SELECT a FROM Answer a "
                    + "JOIN FETCH a.user u "
                    + "WHERE a.question.id = :questionId "
                    + "AND a.status = 'APPROVED' "
                    + "ORDER BY a.createdDate ASC",
                    Answer.class
            );
            query.setParameter("questionId", questionId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public List<Answer> getPendingAnswers() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            TypedQuery<Answer> query = em.createQuery(
                    "SELECT a FROM Answer a "
                    + "JOIN FETCH a.user u "
                    + "JOIN FETCH a.question q "
                    + "JOIN FETCH q.product p "
                    + "WHERE a.status = 'PENDING' "
                    + "ORDER BY a.createdDate DESC",
                    Answer.class
            );
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public boolean updateAnswerStatus(int answerId, String status) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            int updated = em.createQuery(
                    "UPDATE Answer a SET a.status = :status WHERE a.id = :id"
            )
                    .setParameter("status", status)
                    .setParameter("id", answerId)
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

    public int getPendingAnswerCount() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            Long total = em.createQuery(
                    "SELECT COUNT(a) FROM Answer a WHERE a.status = 'PENDING'",
                    Long.class
            ).getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }
}
