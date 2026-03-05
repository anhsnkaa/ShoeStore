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
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import model.Category;
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
            List<ProductImage> images = productImageDAO.getByProductId(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();

            out.print("{");
            out.print("\"id\":" + p.getId() + ",");
            out.print("\"name\":\"" + escapeJson(p.getName()) + "\",");
            out.print("\"price\":" + p.getPrice() + ",");
            out.print("\"description\":\"" + escapeJson(p.getDescription()) + "\",");
            out.print("\"categoryId\":" + p.getCategory().getId() + ",");
            String genderName = "";
            if (p.getCategory() != null && p.getCategory().getGender() != null && p.getCategory().getGender().getName() != null) {
                genderName = p.getCategory().getGender().getName();
            }
            out.print("\"gender\":\"" + escapeJson(genderName) + "\",");
            out.print("\"collection\":\"" + escapeJson(p.getCollectionSeason()) + "\",");
            out.print("\"featured\":" + Boolean.TRUE.equals(p.getFeatured()) + ",");
            out.print("\"discount\":" + (p.getDiscount() == null ? 0 : p.getDiscount()) + ",");
            out.print("\"saleStartAt\":\"" + formatDateTimeLocal(p.getSaleStartAt()) + "\",");
            out.print("\"saleEndAt\":\"" + formatDateTimeLocal(p.getSaleEndAt()) + "\",");
            out.print("\"sizes\":[");

            for (int i = 0; i < sizes.size(); i++) {
                ProductSize ps = sizes.get(i);

                out.print("{");
                out.print("\"color\":\"" + escapeJson(ps.getColor()) + "\",");
                out.print("\"size\":" + ps.getSize() + ",");
                out.print("\"quantity\":" + ps.getQuantity());
                out.print("}");

                if (i < sizes.size() - 1) {
                    out.print(",");
                }
            }

            out.print("],");
            out.print("\"images\":[");

            for (int i = 0; i < images.size(); i++) {
                ProductImage image = images.get(i);

                out.print("{");
                out.print("\"color\":\"" + escapeJson(image.getColor()) + "\",");
                out.print("\"imageUrl\":\"" + escapeJson(image.getImageUrl()) + "\",");
                out.print("\"isMain\":" + image.isIsMain());
                out.print("}");

                if (i < images.size() - 1) {
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

        boolean success = true;
        String message;

        try {
            switch (action) {
                case "add":
                    addProduct(request);
                    message = "Add product successful.";
                    break;
                case "delete":
                    deleteProduct(request);
                    message = "Delete product successful.";
                    break;
                case "update":
                    updateProduct(request);
                    message = "Update product successful.";
                    break;
                default:
                    success = false;
                    message = "Unknown product action.";
                    break;
            }
        } catch (IllegalArgumentException e) {
            success = false;
            message = e.getMessage() == null || e.getMessage().isBlank()
                    ? "Invalid product data."
                    : e.getMessage();
        } catch (Exception e) {
            success = false;
            message = "Product action failed. Please try again.";
            e.printStackTrace();
        }

        session.setAttribute("productType", success ? "success" : "error");
        session.setAttribute("productMessage", message);
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
        //get name
        String name = request.getParameter("name");
        //get price
        int price = Integer.parseInt(request.getParameter("price"));
        //get description
        String description = request.getParameter("description");
        //get categoryid
        int categoryId = Integer.parseInt(request.getParameter("category"));
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
        if (category == null) {
            throw new IllegalArgumentException("Category is invalid.");
        }

        // ===== CREATE PRODUCT =====
        Product product = new Product();
        product.setName(name);
        product.setPrice(price);
        product.setDescription(description);
        product.setCategory(category);
        product.setCollectionSeason(collection);
        product.setDiscount(discount);
        product.setFeatured(featured);
        product.setSaleStartAt(saleStartAt);
        product.setSaleEndAt(saleEndAt);

        // ===== ADD SIZE =====
        List<ProductSize> variants = parseVariantEntries(request, product);
        if (variants.isEmpty()) {
            throw new IllegalArgumentException("Please add at least one variant (color-size-quantity).");
        }

        for (ProductSize variant : variants) {
            product.addSize(variant);
        }

        // ===== IMAGE BY COLOR =====
        Map<String, List<String>> uploadedImagesByColor;
        try {
            uploadedImagesByColor = storeUploadedImagesByColor(request);
        } catch (IOException | ServletException e) {
            throw new RuntimeException(e);
        }

        validateImagesByVariantColors(variants, uploadedImagesByColor);
        appendImagesToProductByColor(product, uploadedImagesByColor);
        ensureSingleMainImage(product);

        // LƯU PRODUCT
        productDAO.addProduct(product);
    }

    private void deleteProduct(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(id);
    }

    private void updateProduct(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("category"));
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
        if (category == null) {
            throw new IllegalArgumentException("Category is invalid.");
        }

        // 🔥 Lấy product cũ
        Product product = productDAO.getProductById(id);
        if (product == null) {
            throw new IllegalArgumentException("Product not found.");
        }

        product.setName(name);
        product.setPrice(price);
        product.setDescription(description);
        product.setCategory(category);
        product.setCollectionSeason(collection);
        product.setDiscount(discount);
        product.setFeatured(featured);
        product.setSaleStartAt(saleStartAt);
        product.setSaleEndAt(saleEndAt);

        // ===== UPDATE SIZE =====
        List<ProductSize> variants = parseVariantEntries(request, product);
        if (variants.isEmpty()) {
            throw new IllegalArgumentException("Please add at least one variant (color-size-quantity).");
        }

        productSizeDAO.deleteByProductId(id);
        for (ProductSize variant : variants) {
            variant.setProduct(product);
            productSizeDAO.addProductSize(variant);
        }

        // ===== REPLACE IMAGES BY COLOR =====
        Map<String, List<String>> uploadedImagesByColor;
        try {
            uploadedImagesByColor = storeUploadedImagesByColor(request);
        } catch (IOException | ServletException e) {
            throw new RuntimeException(e);
        }

        List<String> variantColors = extractVariantColors(variants);
        productImageDAO.deleteByProductExcludingColors(id, variantColors);
        product.getImages().removeIf(img -> !variantColors.contains(normalizeColor(img.getColor())));

        for (Map.Entry<String, List<String>> entry : uploadedImagesByColor.entrySet()) {
            String color = normalizeColor(entry.getKey());
            List<String> imagePaths = entry.getValue();

            if (color == null || imagePaths == null || imagePaths.isEmpty()) {
                continue;
            }

            if (!variantColors.contains(color)) {
                continue;
            }

            productImageDAO.deleteByProductAndColor(id, color);
            product.getImages().removeIf(img -> isSameColor(img.getColor(), color));
            appendImagesToProductByColor(product, color, imagePaths);
        }

        if (product.getImages().isEmpty()) {
            throw new IllegalArgumentException("Please keep at least one image. Upload image(s) by color.");
        }

        ensureSingleMainImage(product);

        // ===== UPDATE PRODUCT =====
        productDAO.updateProduct(product);
    }

    private List<ProductSize> parseVariantEntries(HttpServletRequest request, Product product) {
        List<ProductSize> variants = new ArrayList<>();

        String[] colors = request.getParameterValues("variantColor");
        String[] sizes = request.getParameterValues("variantSize");
        String[] quantities = request.getParameterValues("variantQty");

        if (colors == null || sizes == null || quantities == null) {
            return variants;
        }

        int len = Math.min(colors.length, Math.min(sizes.length, quantities.length));
        Map<String, ProductSize> deduplicated = new LinkedHashMap<>();

        for (int i = 0; i < len; i++) {
            String color = normalizeColor(colors[i]);
            int size = parseIntOrDefault(sizes[i], -1);
            int quantity = parseIntOrDefault(quantities[i], 0);

            if (color == null || size <= 0 || quantity < 0) {
                continue;
            }

            String key = color + "#" + size;
            ProductSize existing = deduplicated.get(key);
            if (existing != null) {
                throw new IllegalArgumentException("Duplicate variant found for color " + color + " and size " + size + ".");
            }

            ProductSize ps = new ProductSize();
            ps.setColor(color);
            ps.setSize(size);
            ps.setQuantity(quantity);
            ps.setProduct(product);
            deduplicated.put(key, ps);
        }

        variants.addAll(deduplicated.values());
        return variants;
    }

    private int parseIntOrDefault(String raw, int defaultValue) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String normalizeColor(String rawColor) {
        if (rawColor == null || rawColor.isBlank()) {
            return null;
        }

        return rawColor.trim().toUpperCase();
    }

    private String parseCollection(String rawCollection) {
        if (rawCollection == null || rawCollection.isBlank()) {
            return null;
        }

        String normalizedCollection = rawCollection.trim();

        if (normalizedCollection.length() > 100) {
            throw new IllegalArgumentException("Collection must be 100 characters or fewer.");
        }

        return normalizedCollection;
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

    private Map<String, List<String>> storeUploadedImagesByColor(HttpServletRequest request) throws IOException, ServletException {
        Map<String, List<String>> imagePathsByColor = new LinkedHashMap<>();

        String[] colorKeys = request.getParameterValues("imageColorKey");
        String[] colorValues = request.getParameterValues("imageColorValue");
        if (colorKeys == null || colorValues == null) {
            return imagePathsByColor;
        }

        Map<String, String> keyToColor = new LinkedHashMap<>();
        int len = Math.min(colorKeys.length, colorValues.length);
        for (int i = 0; i < len; i++) {
            String key = colorKeys[i] == null ? null : colorKeys[i].trim();
            String color = normalizeColor(colorValues[i]);

            if (key == null || key.isBlank() || color == null) {
                continue;
            }

            keyToColor.put(key, color);
        }

        if (keyToColor.isEmpty()) {
            return imagePathsByColor;
        }

        Collection<Part> requestParts = request.getParts();
        Map<String, List<Part>> partsByFieldName = new LinkedHashMap<>();

        for (Part part : requestParts) {
            if (part == null) {
                continue;
            }

            String partName = part.getName();
            if (partName == null || partName.isBlank()) {
                continue;
            }

            partsByFieldName.computeIfAbsent(partName, key -> new ArrayList<>()).add(part);
        }

        String path = request.getServletContext().getRealPath("/images");
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (Map.Entry<String, String> entry : keyToColor.entrySet()) {
            String key = entry.getKey();
            String color = entry.getValue();
            String fieldName = "imagesByColor_" + key;
            List<Part> matchingParts = partsByFieldName.get(fieldName);

            if (matchingParts == null || matchingParts.isEmpty()) {
                continue;
            }

            for (Part part : matchingParts) {
                String submittedFileName = part.getSubmittedFileName();
                if (submittedFileName == null || submittedFileName.trim().isEmpty() || part.getSize() <= 0) {
                    continue;
                }

                String safeFileName = sanitizeFileName(submittedFileName);
                String uniqueFileName = UUID.randomUUID().toString().replace("-", "") + "_" + safeFileName;

                File image = new File(dir, uniqueFileName);
                part.write(image.getAbsolutePath());

                imagePathsByColor.computeIfAbsent(color, k -> new ArrayList<>())
                        .add("images/" + uniqueFileName);
            }
        }

        return imagePathsByColor;
    }

    private void appendImagesToProductByColor(Product product, Map<String, List<String>> imagePathsByColor) {
        if (imagePathsByColor == null || imagePathsByColor.isEmpty()) {
            return;
        }

        for (Map.Entry<String, List<String>> entry : imagePathsByColor.entrySet()) {
            appendImagesToProductByColor(product, entry.getKey(), entry.getValue());
        }
    }

    private void appendImagesToProductByColor(Product product, String color, List<String> imagePaths) {
        String normalizedColor = normalizeColor(color);
        if (normalizedColor == null || imagePaths == null || imagePaths.isEmpty()) {
            return;
        }

        for (String imagePath : imagePaths) {
            ProductImage img = new ProductImage();
            img.setImageUrl(imagePath);
            img.setColor(normalizedColor);
            img.setIsMain(false);
            product.addImage(img);
        }
    }

    private void validateImagesByVariantColors(List<ProductSize> variants, Map<String, List<String>> imagePathsByColor) {
        if (variants == null || variants.isEmpty()) {
            throw new IllegalArgumentException("Please add at least one variant.");
        }

        List<String> variantColors = extractVariantColors(variants);
        if (variantColors.isEmpty()) {
            throw new IllegalArgumentException("Please add at least one variant color.");
        }

        if (imagePathsByColor == null || imagePathsByColor.isEmpty()) {
            throw new IllegalArgumentException("Please upload at least one image for each color.");
        }

        for (String color : variantColors) {
            List<String> imagePaths = imagePathsByColor.get(color);
            if (imagePaths == null || imagePaths.isEmpty()) {
                throw new IllegalArgumentException("Please upload image(s) for color " + color + ".");
            }
        }
    }

    private List<String> extractVariantColors(List<ProductSize> variants) {
        Map<String, Boolean> uniqueColors = new LinkedHashMap<>();

        for (ProductSize variant : variants) {
            if (variant == null) {
                continue;
            }

            String color = normalizeColor(variant.getColor());
            if (color != null) {
                uniqueColors.put(color, Boolean.TRUE);
            }
        }

        return new ArrayList<>(uniqueColors.keySet());
    }

    private void ensureSingleMainImage(Product product) {
        if (product == null || product.getImages() == null || product.getImages().isEmpty()) {
            return;
        }

        int mainIndex = -1;
        for (int i = 0; i < product.getImages().size(); i++) {
            if (product.getImages().get(i).isIsMain()) {
                mainIndex = i;
                break;
            }
        }

        if (mainIndex < 0) {
            mainIndex = 0;
        }

        for (int i = 0; i < product.getImages().size(); i++) {
            product.getImages().get(i).setIsMain(i == mainIndex);
        }
    }

    private boolean isSameColor(String colorA, String colorB) {
        String a = normalizeColor(colorA);
        String b = normalizeColor(colorB);

        if (a == null && b == null) {
            return true;
        }

        if (a == null || b == null) {
            return false;
        }

        return a.equals(b);
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
