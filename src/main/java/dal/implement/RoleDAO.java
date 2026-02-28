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
}
