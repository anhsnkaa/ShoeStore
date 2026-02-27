/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
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
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
@MultipartConfig
public class ProductAdminServerlet extends HttpServlet {

    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            Part part = request.getPart("image");
            String imagePath = null;

            if (part == null || part.getSubmittedFileName() == null || part.getSubmittedFileName().trim().isEmpty()) {
                imagePath = null;
            } else {
                //duong dan luu anh
                String path = request.getServletContext().getRealPath("/images");
                File dir = new File(path);

                //xem duong dan nay ton tai chua
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                File image = new File(dir, part.getSubmittedFileName());
                //ghi file vao trong duong dan
                part.write(image.getAbsolutePath());
                //lay ra cai context path cua project
                imagePath = "images/" + part.getSubmittedFileName();
            }
            // ===== CREATE PRODUCT =====
            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setImg(imagePath);
            product.setCategory(category);

            productDAO.addProduct(product); // LƯU PRODUCT
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
                        ps.setProduct(product);

                        productSizeDAO.addProductSize(ps);
                    }
                }
            }
        } catch (IOException | ServletException ex) {
            ex.printStackTrace();
        }
    }

}
