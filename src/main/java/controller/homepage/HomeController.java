/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

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
import model.PageControl;
import model.Product;
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
public class HomeController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PageControl pageControl = new PageControl();

        //get ve list productDAO
        List<Product> listProduct = findProductDoGet(request, pageControl);
        //get ve list categoryDAO
        List<Category> listCategory = categoryDAO.getAllCategories();

        //set vao listProduct, listProductSize, listCategory trong session
        HttpSession session = request.getSession();
        session.setAttribute("listProduct", listProduct);
        session.setAttribute("listCategory", listCategory);
        session.setAttribute("pageControl", pageControl);
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

    private List<Product> findProductDoGet(HttpServletRequest request, PageControl pageControl) {
        //get ve page
        String pageRaw = request.getParameter("page");
        //valid page
        int page;
        int pageSize = 12;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 0) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        //get ve search
        String actionSearch = request.getParameter("search") == null
                ? "default" : request.getParameter("search");
        //get ve listProductDAO
        List<Product> product;
        //get ve requestUrl
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;
        switch (actionSearch) {
            case "category":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                totalRecord = productDAO.getTotalRecordByCategory(categoryId);
                product = productDAO.getProductByCategory(categoryId, page);
                pageControl.setUrlPattern(requestURL + "?search=category&categoryId=" + categoryId + "&");
                break;
            case "searchByKeyword":
                String keyword = request.getParameter("keyword");
                totalRecord = productDAO.getTotalRecordByKeyword(keyword);
                product = productDAO.getProductByKeyword(keyword, page);
                pageControl.setUrlPattern(requestURL + "?search=searchByKeyword&keyword=" + keyword + "&");
                break;
            default:
                product = productDAO.getAllProductsPaging(page);
                totalRecord = productDAO.getTotalProducts();
                pageControl.setUrlPattern(requestURL + "?");
        }
        //total page
        int totalPage = (int) Math.ceil(totalRecord * 1.0 / pageSize);

        //set total record, total page, page vao page control
        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);
        return product;
    }

}
