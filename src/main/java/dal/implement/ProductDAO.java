/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal.implement;

import dal.JPAUtil;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
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
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(p);
            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    // Xoa san pham theo id.
    public void deleteProduct(int id) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            Product p = em.find(Product.class, id);

            if (p != null) {
                em.remove(p);
            }

            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
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

    public List<Product> getRelatedProductsByCategory(int categoryId, int currentProductId, int limit) {
        if (categoryId <= 0 || currentProductId <= 0 || limit <= 0) {
            return List.of();
        }

        EntityManager em = JPAUtil.getEMF().createEntityManager();

        try {
            return em.createQuery(
                    "SELECT p FROM Product p "
                    + "WHERE p.category.id = :categoryId "
                    + "AND p.id <> :currentProductId "
                    + "ORDER BY p.id DESC",
                    Product.class
            )
                    .setParameter("categoryId", categoryId)
                    .setParameter("currentProductId", currentProductId)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
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
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.category.id = :cid "
                + "AND UPPER(p.category.gender.name) = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("cid", categoryId)
                .setParameter("gender", normalizedGender)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getProductByCategoryName(String categoryName, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String normalizedCategoryName = normalizeCategoryNameValue(categoryName);
        if (normalizedCategoryName == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE UPPER(p.category.name) = :cname "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE UPPER(p2.category.name) = :cname "
                + "GROUP BY UPPER(p2.name)"
                + ")"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("cname", normalizedCategoryName)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getProductByCollection(String collection, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedCollection = normalizeCollectionValue(collection);

        if (normalizedCollection == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE UPPER(p.collectionSeason) = :collection "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE UPPER(p2.collectionSeason) = :collection "
                + "GROUP BY UPPER(p2.name)"
                + ")"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("collection", normalizedCollection)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getProductByCollectionAndGender(String collection, String gender, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedCollection = normalizeCollectionValue(collection);
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedCollection == null || normalizedGender == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE UPPER(p.collectionSeason) = :collection "
                + "AND UPPER(p.category.gender.name) = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("collection", normalizedCollection)
                .setParameter("gender", normalizedGender)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getHotProducts(int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.featured = true "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.featured = true "
                + "GROUP BY UPPER(p2.name)"
                + ")"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getHotProductsByGender(String gender, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.featured = true "
                + "AND UPPER(p.category.gender.name) = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("gender", normalizedGender)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getSaleProducts(int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        LocalDateTime now = LocalDateTime.now();

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.discount > 0 "
                + "AND (p.saleStartAt IS NULL OR p.saleStartAt <= :now) "
                + "AND (p.saleEndAt IS NULL OR p.saleEndAt >= :now) "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.discount > 0 "
                + "AND (p2.saleStartAt IS NULL OR p2.saleStartAt <= :now) "
                + "AND (p2.saleEndAt IS NULL OR p2.saleEndAt >= :now) "
                + "GROUP BY UPPER(p2.name)"
                + ")"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("now", now)
                .setFirstResult((page - 1) * PAGE_SIZE)
                .setMaxResults(PAGE_SIZE)
                .getResultList();

        em.close();
        return list;
    }

    public List<Product> getSaleProductsByGender(String gender, int page, String sort) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        LocalDateTime now = LocalDateTime.now();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.discount > 0 "
                + "AND (p.saleStartAt IS NULL OR p.saleStartAt <= :now) "
                + "AND (p.saleEndAt IS NULL OR p.saleEndAt >= :now) "
                + "AND UPPER(p.category.gender.name) = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("now", now)
                .setParameter("gender", normalizedGender)
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

        String jpql = "SELECT p FROM Product p "
                + "WHERE p.name LIKE :kw "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.name LIKE :kw "
                + "GROUP BY UPPER(p2.name)"
                + ")"
                + buildOrderByClause(sort);

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
            String jpql = "SELECT p FROM Product p "
                    + "WHERE p.price >= :min "
                    + "AND p.id IN ("
                    + "SELECT MIN(p2.id) FROM Product p2 "
                    + "WHERE p2.price >= :min "
                    + "GROUP BY UPPER(p2.name)"
                    + ")"
                    + buildOrderByClause(sort);
            list = em.createQuery(jpql, Product.class)
                    .setParameter("min", min)
                    .setFirstResult((page - 1) * PAGE_SIZE)
                    .setMaxResults(PAGE_SIZE)
                    .getResultList();
        } else {
            String jpql = "SELECT p FROM Product p "
                    + "WHERE p.price >= :min AND p.price <= :max "
                    + "AND p.id IN ("
                    + "SELECT MIN(p2.id) FROM Product p2 "
                    + "WHERE p2.price >= :min AND p2.price <= :max "
                    + "GROUP BY UPPER(p2.name)"
                    + ")"
                    + buildOrderByClause(sort);
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
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.name LIKE :kw "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.name LIKE :kw "
                + "GROUP BY UPPER(p2.name)"
                + ")",
                Long.class)
                .setParameter("kw", "%" + keyword + "%")
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByCategoryAndGender(int categoryId, String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.category.id = :cid "
                + "AND UPPER(p.category.gender.name) = :gender",
                Long.class)
                .setParameter("cid", categoryId)
                .setParameter("gender", normalizedGender)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByCategoryName(String categoryName) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedCategoryName = normalizeCategoryNameValue(categoryName);

        if (normalizedCategoryName == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE UPPER(p.category.name) = :cname "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE UPPER(p2.category.name) = :cname "
                + "GROUP BY UPPER(p2.name)"
                + ")",
                Long.class)
                .setParameter("cname", normalizedCategoryName)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByCollection(String collection) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedCollection = normalizeCollectionValue(collection);

        if (normalizedCollection == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE UPPER(p.collectionSeason) = :collection "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE UPPER(p2.collectionSeason) = :collection "
                + "GROUP BY UPPER(p2.name)"
                + ")",
                Long.class)
                .setParameter("collection", normalizedCollection)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalRecordByCollectionAndGender(String collection, String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedCollection = normalizeCollectionValue(collection);
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedCollection == null || normalizedGender == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE UPPER(p.collectionSeason) = :collection "
                + "AND UPPER(p.category.gender.name) = :gender",
                Long.class)
                .setParameter("collection", normalizedCollection)
                .setParameter("gender", normalizedGender)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public List<String> getAllCollections() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        List<String> list = em.createQuery(
                "SELECT DISTINCT p.collectionSeason FROM Product p "
                + "WHERE p.collectionSeason IS NOT NULL "
                + "AND TRIM(p.collectionSeason) <> '' "
                + "ORDER BY p.collectionSeason",
                String.class)
                .getResultList();

        em.close();
        return list;
    }

    public List<String> getCollectionsByGender(String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return List.of();
        }

        List<String> list = em.createQuery(
                "SELECT DISTINCT p.collectionSeason FROM Product p "
                + "WHERE p.collectionSeason IS NOT NULL "
                + "AND TRIM(p.collectionSeason) <> '' "
                + "AND UPPER(p.category.gender.name) = :gender "
                + "ORDER BY p.collectionSeason",
                String.class)
                .setParameter("gender", normalizedGender)
                .getResultList();

        em.close();
        return list;
    }

    public int getTotalHotProducts() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.featured = true "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.featured = true "
                + "GROUP BY UPPER(p2.name)"
                + ")",
                Long.class)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalHotProductsByGender(String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.featured = true "
                + "AND UPPER(p.category.gender.name) = :gender",
                Long.class)
                .setParameter("gender", normalizedGender)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalSaleProducts() {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        LocalDateTime now = LocalDateTime.now();

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.discount > 0 "
                + "AND (p.saleStartAt IS NULL OR p.saleStartAt <= :now) "
                + "AND (p.saleEndAt IS NULL OR p.saleEndAt >= :now) "
                + "AND p.id IN ("
                + "SELECT MIN(p2.id) FROM Product p2 "
                + "WHERE p2.discount > 0 "
                + "AND (p2.saleStartAt IS NULL OR p2.saleStartAt <= :now) "
                + "AND (p2.saleEndAt IS NULL OR p2.saleEndAt >= :now) "
                + "GROUP BY UPPER(p2.name)"
                + ")",
                Long.class)
                .setParameter("now", now)
                .getSingleResult();

        em.close();
        return total.intValue();
    }

    public int getTotalSaleProductsByGender(String gender) {
        EntityManager em = JPAUtil.getEMF().createEntityManager();
        LocalDateTime now = LocalDateTime.now();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p "
                + "WHERE p.discount > 0 "
                + "AND (p.saleStartAt IS NULL OR p.saleStartAt <= :now) "
                + "AND (p.saleEndAt IS NULL OR p.saleEndAt >= :now) "
                + "AND UPPER(p.category.gender.name) = :gender",
                Long.class)
                .setParameter("now", now)
                .setParameter("gender", normalizedGender)
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
                    "SELECT COUNT(p) FROM Product p "
                    + "WHERE p.price >= :min "
                    + "AND p.id IN ("
                    + "SELECT MIN(p2.id) FROM Product p2 "
                    + "WHERE p2.price >= :min "
                    + "GROUP BY UPPER(p2.name)"
                    + ")",
                    Long.class)
                    .setParameter("min", min)
                    .getSingleResult();
        } else {
            total = em.createQuery(
                    "SELECT COUNT(p) FROM Product p "
                    + "WHERE p.price >= :min AND p.price <= :max "
                    + "AND p.id IN ("
                    + "SELECT MIN(p2.id) FROM Product p2 "
                    + "WHERE p2.price >= :min AND p2.price <= :max "
                    + "GROUP BY UPPER(p2.name)"
                    + ")",
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
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            em.createQuery("DELETE FROM ProductSize ps WHERE ps.product.id = :id")
                    .setParameter("id", productId)
                    .executeUpdate();

            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    // Cap nhat thong tin san pham.
    public void updateProduct(Product p) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            em.merge(p);

            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    // Loc san pham theo gioi tinh co phan trang va sort.
    public List<Product> getProductByGender(String gender, int page, String sort) {

        EntityManager em = JPAUtil.getEMF().createEntityManager();
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return List.of();
        }

        String jpql = "SELECT p FROM Product p "
                + "WHERE UPPER(p.category.gender.name) = :gender"
                + buildOrderByClause(sort);

        List<Product> list = em.createQuery(jpql, Product.class)
                .setParameter("gender", normalizedGender)
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
        String normalizedGender = normalizeGenderValue(gender);

        if (normalizedGender == null) {
            em.close();
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(p) FROM Product p WHERE UPPER(p.category.gender.name) = :gender",
                Long.class
        )
                .setParameter("gender", normalizedGender)
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

    private String normalizeCollectionValue(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }

        return raw.trim().toUpperCase();
    }

    private String normalizeGenderValue(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }

        return raw.trim().toUpperCase();
    }

    private String normalizeCategoryNameValue(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }

        return raw.trim().toUpperCase();
    }
}
