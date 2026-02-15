/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
import dal.implement.ProductSizeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Product;
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
public class HomeController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();
    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve list productDAO

        List<Product> listProduct = findProductDoGet(request);
        //get ve list productSizeDAO
        List<ProductSize> listProductSize = productSizeDAO.getSizesByProduct(0);
        //get ve list categoryDAO
        List<Category> listCategory = categoryDAO.getAllCategories();

        //set vao listProduct, listProductSize, listCategory trong session
        HttpSession session = request.getSession();
        session.setAttribute("listProduct", listProduct);
        session.setAttribute("listProductSize", listProductSize);
        session.setAttribute("listCategory", listCategory);
        request.getRequestDispatcher("view/homepage/home.jsp").forward(request, response);
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

    private List<Product> findProductDoGet(HttpServletRequest request) {
        String actionSearch = request.getParameter("search") == null
                ? "default" : request.getParameter("search");
        List<Product> product;
        switch (actionSearch) {
            case "category":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                product = productDAO.getProductByCategory(categoryId);
                break;
            default:
                product = productDAO.getAllProducts();

        }
        return product;
    }

}
