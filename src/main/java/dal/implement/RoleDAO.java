/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;
import model.Role;

/**
 *
 * @author FPTShop
 */
public class RoleDAO {

    public List<Role> getAllRoles() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Role> list = em.createQuery(
                "SELECT r FROM Role r", Role.class)
                .getResultList();

        em.close();
        return list;
    }

    public Role findById(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Role role = em.find(Role.class, id);

        em.close();
        return role;
    }

    public Role findByName(String roleName) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            List<Role> list = em.createQuery(
                    "SELECT r FROM Role r WHERE UPPER(r.name) = UPPER(:name)",
                    Role.class
            )
                    .setParameter("name", roleName)
                    .setMaxResults(1)
                    .getResultList();

            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public Role getOrCreateRole(String roleName) {
        Role existed = findByName(roleName);
        if (existed != null) {
            return existed;
        }

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        try {
            em.getTransaction().begin();
            Role role = new Role();
            role.setName(roleName.toUpperCase());
            em.persist(role);
            em.getTransaction().commit();
            return role;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return findByName(roleName);
        } finally {
            em.close();
        }
    }
}
