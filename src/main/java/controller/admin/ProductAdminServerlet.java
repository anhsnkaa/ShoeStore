/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
import dal.implement.ProductImageDAO;
import dal.implement.ProductSizeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Gender;
import model.Product;
import model.ProductImage;
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
@MultipartConfig
public class ProductAdminServerlet extends HttpServlet {

    private static final DateTimeFormatter DATE_TIME_LOCAL_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    ProductImageDAO productImageDAO = new ProductImageDAO();
    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getProduct".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            Product p = productDAO.getProductById(id);
            List<ProductSize> sizes = productSizeDAO.getQuantityOfSizes(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();

            out.print("{");
            out.print("\"id\":" + p.getId() + ",");
            out.print("\"name\":\"" + escapeJson(p.getName()) + "\",");
            out.print("\"price\":" + p.getPrice() + ",");
            out.print("\"description\":\"" + escapeJson(p.getDescription()) + "\",");
            out.print("\"categoryId\":" + p.getCategory().getId() + ",");
            out.print("\"gender\":\"" + (p.getGender() == null ? "" : p.getGender().name()) + "\",");
            out.print("\"collection\":\"" + escapeJson(p.getCollectionSeason()) + "\",");
            out.print("\"featured\":" + Boolean.TRUE.equals(p.getFeatured()) + ",");
            out.print("\"discount\":" + (p.getDiscount() == null ? 0 : p.getDiscount()) + ",");
            out.print("\"saleStartAt\":\"" + formatDateTimeLocal(p.getSaleStartAt()) + "\",");
            out.print("\"saleEndAt\":\"" + formatDateTimeLocal(p.getSaleEndAt()) + "\",");
            out.print("\"sizes\":[");

            for (int i = 0; i < sizes.size(); i++) {
                ProductSize ps = sizes.get(i);

                out.print("{");
                out.print("\"size\":" + ps.getSize() + ",");
                out.print("\"quantity\":" + ps.getQuantity());
                out.print("}");

                if (i < sizes.size() - 1) {
                    out.print(",");
                }
            }

            out.print("]}");
            out.flush();
            return;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        //get session
        HttpSession session = request.getSession();

        //get action
        String action = request.getParameter("action") == null ? ""
                : request.getParameter("action");
        switch (action) {
            case "add":
                addProduct(request);
                break;
            case "delete":
                deleteProduct(request);
                break;
            case "update":
                updateProduct(request);
                break;
            default:
                throw new AssertionError();
        }
        response.sendRedirect("dashboard");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void addProduct(HttpServletRequest request) {
        try {
            //get name
            String name = request.getParameter("name");
            //get price
            int price = Integer.parseInt(request.getParameter("price"));
            //get description
            String description = request.getParameter("description");
            //get categoryid
            int categoryId = Integer.parseInt(request.getParameter("category"));
            Gender gender = parseGender(request.getParameter("gender"));
            String collection = parseCollection(request.getParameter("collection"));
            double discount = clampDiscount(parseDoubleOrDefault(request.getParameter("discount"), 0));
            boolean featured = request.getParameter("featured") != null;
            LocalDateTime saleStartAt = parseDateTimeLocal(request.getParameter("saleStartAt"));
            LocalDateTime saleEndAt = parseDateTimeLocal(request.getParameter("saleEndAt"));

            if (saleStartAt != null && saleEndAt != null && saleEndAt.isBefore(saleStartAt)) {
                saleEndAt = saleStartAt;
            }

            if (discount <= 0) {
                saleStartAt = null;
                saleEndAt = null;
            }

            if (gender == null) {
                gender = Gender.MEN;
            }
            Category category = categoryDAO.findById(categoryId);
            //image
            // ===== CREATE PRODUCT =====
            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setCategory(category);
            product.setGender(gender);
            product.setCollectionSeason(collection);
            product.setDiscount(discount);
            product.setFeatured(featured);
            product.setSaleStartAt(saleStartAt);
            product.setSaleEndAt(saleEndAt);

            // ===== UPLOAD MULTIPLE IMAGES (UNIQUE FILE NAME) =====
            List<String> uploadedImagePaths = storeUploadedImagePaths(request);
            appendImagesToProduct(product, uploadedImagePaths);

            // ===== ADD SIZE =====
            for (int s = 36; s <= 44; s++) {
                String paramName = "sizeQty_" + s;
                String qtyStr = request.getParameter(paramName);

                if (qtyStr != null && !qtyStr.isEmpty()) {

                    int quantity = Integer.parseInt(qtyStr);

                    if (quantity > 0) {

                        ProductSize ps = new ProductSize();
                        ps.setSize(s);
                        ps.setQuantity(quantity);

                        product.addSize(ps);
                    }
                }
            }
            // LƯU PRODUCT 
            productDAO.addProduct(product);
        } catch (IOException | ServletException ex) {
            ex.printStackTrace();
        }
    }

    private void deleteProduct(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(id);
    }

    private void updateProduct(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            int price = Integer.parseInt(request.getParameter("price"));
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("category"));
            Gender gender = parseGender(request.getParameter("gender"));
            String collection = parseCollection(request.getParameter("collection"));
            double discount = clampDiscount(parseDoubleOrDefault(request.getParameter("discount"), 0));
            boolean featured = request.getParameter("featured") != null;
            LocalDateTime saleStartAt = parseDateTimeLocal(request.getParameter("saleStartAt"));
            LocalDateTime saleEndAt = parseDateTimeLocal(request.getParameter("saleEndAt"));

            if (saleStartAt != null && saleEndAt != null && saleEndAt.isBefore(saleStartAt)) {
                saleEndAt = saleStartAt;
            }

            if (discount <= 0) {
                saleStartAt = null;
                saleEndAt = null;
            }

            Category category = categoryDAO.findById(categoryId);

            // 🔥 Lấy product cũ
            Product product = productDAO.getProductById(id);

            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setCategory(category);
            if (gender != null) {
                product.setGender(gender);
            }
            product.setCollectionSeason(collection);
            product.setDiscount(discount);
            product.setFeatured(featured);
            product.setSaleStartAt(saleStartAt);
            product.setSaleEndAt(saleEndAt);

            // ===== XỬ LÝ IMAGE =====
            List<String> uploadedImagePaths = storeUploadedImagePaths(request);
            if (!uploadedImagePaths.isEmpty()) {
                // Người dùng upload ảnh mới => thay toàn bộ ảnh cũ
                productImageDAO.deleteByProductId(id);
                product.getImages().clear();
                appendImagesToProduct(product, uploadedImagePaths);
            }

            // ===== UPDATE PRODUCT =====
            productDAO.updateProduct(product);

            // ===== UPDATE SIZE =====
            // 1️⃣ XÓA SIZE CŨ
            productSizeDAO.deleteByProductId(id);

            // 2️⃣ INSERT SIZE MỚI
            for (int s = 36; s <= 44; s++) {

                String qtyStr = request.getParameter("sizeQty_" + s);

                if (qtyStr != null && !qtyStr.isEmpty()) {

                    int quantity = Integer.parseInt(qtyStr);

                    if (quantity > 0) {

                        ProductSize ps = new ProductSize();
                        ps.setSize(s);
                        ps.setQuantity(quantity);
                        ps.setProduct(product);

                        productSizeDAO.addProductSize(ps);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Gender parseGender(String rawGender) {
        if (rawGender == null || rawGender.isBlank()) {
            return null;
        }

        try {
            return Gender.valueOf(rawGender.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private String parseCollection(String rawCollection) {
        if (rawCollection == null || rawCollection.isBlank()) {
            return null;
        }

        return rawCollection.trim();
    }

    private double parseDoubleOrDefault(String raw, double defaultValue) {
        try {
            return Double.parseDouble(raw);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private double clampDiscount(double discount) {
        if (discount < 0) {
            return 0;
        }

        if (discount > 100) {
            return 100;
        }

        return discount;
    }

    private LocalDateTime parseDateTimeLocal(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }

        try {
            return LocalDateTime.parse(raw, DATE_TIME_LOCAL_FORMAT);
        } catch (Exception e) {
            return null;
        }
    }

    private String formatDateTimeLocal(LocalDateTime value) {
        if (value == null) {
            return "";
        }

        return value.format(DATE_TIME_LOCAL_FORMAT);
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private List<String> storeUploadedImagePaths(HttpServletRequest request) throws IOException, ServletException {
        List<String> imagePaths = new ArrayList<>();

        String path = request.getServletContext().getRealPath("/images");
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (Part part : request.getParts()) {
            if (!"images".equals(part.getName())) {
                continue;
            }

            String submittedFileName = part.getSubmittedFileName();
            if (submittedFileName == null || submittedFileName.trim().isEmpty() || part.getSize() <= 0) {
                continue;
            }

            String safeFileName = sanitizeFileName(submittedFileName);
            String uniqueFileName = UUID.randomUUID().toString().replace("-", "") + "_" + safeFileName;

            File image = new File(dir, uniqueFileName);
            part.write(image.getAbsolutePath());

            imagePaths.add("images/" + uniqueFileName);
        }

        return imagePaths;
    }

    private void appendImagesToProduct(Product product, List<String> imagePaths) {
        if (imagePaths == null || imagePaths.isEmpty()) {
            return;
        }

        for (String imagePath : imagePaths) {
            ProductImage img = new ProductImage();
            img.setImageUrl(imagePath);
            img.setIsMain(false);
            product.addImage(img);
        }

        if (!product.getImages().isEmpty()) {
            product.getImages().get(0).setIsMain(true);
        }
    }

    private String sanitizeFileName(String submittedFileName) {
        String fileName = submittedFileName.trim();

        int slash = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));
        if (slash >= 0 && slash < fileName.length() - 1) {
            fileName = fileName.substring(slash + 1);
        }

        return fileName.replaceAll("[^A-Za-z0-9._-]", "_");
    }

}
