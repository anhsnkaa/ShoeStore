/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import model.Gender;
import model.Product;

/**
 *
 * @author FPTShop
 */
public class ProductDAO {

    private static final int PAGE_SIZE = 12;

    // Lay toan bo san pham (khong phan trang), dung cho dashboard/admin.
    public List<Product> getAllProducts() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list = em.createQuery(
                "SELECT DISTINCT p FROM Product p "
                + "LEFT JOIN FETCH p.images",
                Product.class
        ).getResultList();

        em.close();
        return list;
    }

    // Lay danh sach san pham phan trang cho trang home theo sort.
    public List<Product> getAllProductsPaging(int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p" + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    // Overload de giu tuong thich voi code cu.
    public List<Product> getAllProductsPaging(int page) {
        return getAllProductsPaging(page, null);
    }

    // Them moi san pham vao database.
    public void addProduct(Product p) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();
        em.persist(p);
        em.getTransaction().commit();
        em.close();
    }

    // Xoa san pham theo id.
    public void deleteProduct(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        Product p = em.find(Product.class, id);

        if (p != null) {
            em.remove(p);
        }

        em.getTransaction().commit();
        em.close();
    }

    // Lay thong tin 1 san pham theo id.
    public Product getProductById(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Product product = em.createQuery(
                "SELECT p FROM Product p "
                + "LEFT JOIN FETCH p.images "
                + "WHERE p.id = :id",
                Product.class
        )
                .setParameter("id", id)
                .getSingleResult();

        em.close();
        return product;
    }

    // Lay san pham theo category co phan trang va sort.
    public List<Product> getProductByCategory(int categoryId, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p WHERE p.category.id = :cid" + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("cid", categoryId)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getProductByCategoryAndGender(int categoryId, String gender, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.category.id = :cid AND p.gender = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("cid", categoryId)
                .setParameter("gender", Gender.valueOf(gender))
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    // Overload de giu tuong thich voi code cu.
    public List<Product> getProductByCategory(int categoryId, int page) {
        return getProductByCategory(categoryId, page, null);
    }

    // Tim san pham theo ten co phan trang va sort.
    public List<Product> getProductByKeyword(String keyword, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p WHERE p.name LIKE :kw" + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("kw", "%" + keyword + "%")
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    // Overload de giu tuong thich voi code cu.
    public List<Product> getProductByKeyword(String keyword, int page) {
        return getProductByKeyword(keyword, page, null);
    }

    // Loc san pham theo khoang gia co phan trang va sort.
    public List<Product> getProductByPriceRange(double min, Double max, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<Product> list;
        if (max == null) {
            String jpql = "SELECT p FROM Product p WHERE p.price >= :min" + buildOrderByClause(sort);
            list = em.createQuery(jpql, Product.class)
                    .setParameter("min", min)
                    .setFirstResult((page - 1) * PAGE_SIZE)
                    .setMaxResults(PAGE_SIZE)
                    .getResultList();
        } else {
            String jpql = "SELECT p FROM Product p WHERE p.price >= :min AND p.price <= :max" + buildOrderByClause(sort);
            list = em.createQuery(jpql, Product.class)
                    .setParameter("min", min)
                    .setParameter("max", max)
                    .setFirstResult((page - 1) * PAGE_SIZE)
                    .setMaxResults(PAGE_SIZE)
                    .getResultList();
        }

        em.close();
        return list;
    }

    // Overload de giu tuong thich voi code cu.
    public List<Product> getProductByPriceRange(double min, Double max, int page) {
        return getProductByPriceRange(min, max, page, null);
    }

    // Dem tong so ban ghi theo category de phan trang.
    public int getTotalRecordByCategory(int categoryId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.category.id = :cid",
                Long.class)
                .setParameter("cid", categoryId)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    // Dem tong so ban ghi theo tu khoa tim kiem de phan trang.
    public int getTotalRecordByKeyword(String keyword) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.name LIKE :kw",
                Long.class)
                .setParameter("kw", "%" + keyword + "%")
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByCategoryAndGender(int categoryId, String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.category.id = :cid AND p.gender = :gender",
                Long.class)
                .setParameter("cid", categoryId)
                .setParameter("gender", Gender.valueOf(gender))
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    // Dem tong so ban ghi theo khoang gia de phan trang.
    public int getTotalRecordByPriceRange(double min, Double max) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total;
        if (max == null) {
            total = em.createQuery(
                    "SELECT COUNT(p) FROM Product p WHERE p.price >= :min",
                    Long.class)
                    .setParameter("min", min)
                    .getSingleResult();
        } else {
            total = em.createQuery(
                    "SELECT COUNT(p) FROM Product p WHERE p.price >= :min AND p.price <= :max",
                    Long.class)
                    .setParameter("min", min)
                    .setParameter("max", max)
                    .getSingleResult();
        }

        em.close();
        return total.intValue();
    }

    // Dem tong so san pham.
    public int getTotalProducts() {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p",
                Long.class)
                .getSingleResult();

        em.close();

        return total.intValue();   // ép sang int
    }

    // Xoa danh sach size theo product (ho tro truoc khi xoa product).
    public void deleteByProduct(int productId) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        em.createQuery("DELETE FROM ProductSize ps WHERE ps.product.id = :id")
                .setParameter("id", productId)
                .executeUpdate();

        em.getTransaction().commit();
        em.close();
    }

    // Cap nhat thong tin san pham.
    public void updateProduct(Product p) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        em.getTransaction().begin();

        em.merge(p);

        em.getTransaction().commit();
        em.close();
    }

    // Loc san pham theo gioi tinh co phan trang va sort.
    public List<Product> getProductByGender(String gender, int page, String sort) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p WHERE p.gender = :gender" + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("gender", Gender.valueOf(gender)) // 🔥 QUAN TRỌNG
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    // Overload de giu tuong thich voi code cu.
    public List<Product> getProductByGender(String gender, int page) {
        return getProductByGender(gender, page, null);
    }

    // Dem tong so ban ghi theo gioi tinh de phan trang.
    public int getTotalRecordByGender(String gender) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE p.gender = :gender",
                Long.class
        )
                .setParameter("gender", Gender.valueOf(gender)) // 🔥 QUAN TRỌNG
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    // Map gia tri sort tu request thanh ORDER BY an toan.
    private String buildOrderByClause(String sort) {
        if (sort == null || sort.isBlank()) {
            return " ORDER BY p.id DESC";
        }

        switch (sort) {
            case "nameAsc":
                return " ORDER BY p.name ASC";
            case "nameDesc":
                return " ORDER BY p.name DESC";
            case "priceAsc":
                return " ORDER BY p.price ASC";
            case "priceDesc":
                return " ORDER BY p.price DESC";
            default:
                return " ORDER BY p.id DESC";
        }
    }
}
