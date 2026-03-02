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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
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
            out.print("\"name\":\"" + p.getName() + "\",");
            out.print("\"price\":" + p.getPrice() + ",");
            out.print("\"description\":\"" + p.getDescription() + "\",");
            out.print("\"categoryId\":" + p.getCategory().getId() + ",");
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
            Category category = categoryDAO.findById(categoryId);
            //image
            // ===== CREATE PRODUCT =====
            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setCategory(category);

            // ===== UPLOAD MULTIPLE IMAGES =====
            for (Part part : request.getParts()) {

                if ("images".equals(part.getName())
                        && part.getSubmittedFileName() != null
                        && !part.getSubmittedFileName().trim().isEmpty()) {

                    String path = request.getServletContext().getRealPath("/images");
                    File dir = new File(path);

                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    File image = new File(dir, part.getSubmittedFileName());
                    part.write(image.getAbsolutePath());

                    String imagePath = "images/" + part.getSubmittedFileName();

                    ProductImage img = new ProductImage();
                    img.setImageUrl(imagePath);
                    img.setIsMain(false);

                    product.addImage(img); // 🔥 DÙNG CASCADE
                }
            }

            // SET ẢNH ĐẦU LÀ ẢNH CHÍNH
            if (!product.getImages().isEmpty()) {
                product.getImages().get(0).setIsMain(true);
            }

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

            Category category = categoryDAO.findById(categoryId);

            // 🔥 Lấy product cũ
            Product product = productDAO.getProductById(id);

            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setCategory(category);

            // ===== XỬ LÝ IMAGE =====
            for (Part part : request.getParts()) {

                if ("images".equals(part.getName())
                        && part.getSubmittedFileName() != null
                        && !part.getSubmittedFileName().trim().isEmpty()) {

                    String path = request.getServletContext().getRealPath("/images");
                    File dir = new File(path);

                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    File image = new File(dir, part.getSubmittedFileName());
                    part.write(image.getAbsolutePath());

                    String imagePath = "images/" + part.getSubmittedFileName();

                    ProductImage img = new ProductImage();
                    img.setImageUrl(imagePath);
                    img.setIsMain(false);

                    product.addImage(img);
                }
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

}
