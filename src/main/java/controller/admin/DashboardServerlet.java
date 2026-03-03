/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.implement.AnswerDAO;
import dal.implement.CategoryDAO;
import dal.implement.OrderDAO;
import dal.implement.ProductDAO;
import dal.implement.ProductSizeDAO;
import dal.implement.QuestionDAO;
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
public class DashboardServerlet extends HttpServlet {

    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    OrderDAO orderDAO = new OrderDAO();
    QuestionDAO questionDAO = new QuestionDAO();
    AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int pendingQuestionCount = questionDAO.getPendingQuestionCount();
        int pendingAnswerCount = answerDAO.getPendingAnswerCount();
        int notificationCount = pendingQuestionCount + pendingAnswerCount;
        String action = request.getParameter("action");
        if ("getImages".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = productDAO.getProductById(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();

            out.print("[");
            for (int i = 0; i < product.getImages().size(); i++) {

                out.print("{");
                out.print("\"imageUrl\":\"" + product.getImages().get(i).getImageUrl() + "\"");
                out.print("}");

                if (i < product.getImages().size() - 1) {
                    out.print(",");
                }
            }
            out.print("]");

            out.flush();
            return;
        }
        // 🔥 Trường hợp AJAX load sizes
        if ("getSizes".equals(action)) {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            int productId = Integer.parseInt(request.getParameter("id"));

            List<ProductSize> sizes
                    = productSizeDAO.getQuantityOfSizes(productId);

            PrintWriter out = response.getWriter();

            out.print("[");
            for (int i = 0; i < sizes.size(); i++) {
                ProductSize ps = sizes.get(i);

                out.print("{");
                out.print("\"size\":" + ps.getSize() + ",");
                out.print("\"quantity\":" + ps.getQuantity());
                out.print("}");

                if (i < sizes.size() - 1) {
                    out.print(",");
                }
                System.out.println(ps.toString());
            }
            out.print("]");

            out.flush();
            return;
        }

        //get ve list productDAO
        List<Product> listProduct = productDAO.getAllProducts();
        //get ve list categoryDAO
        List<Category> listCategory = categoryDAO.getAllCategories();
        int orderCount = orderDAO.getAllOrders().size();
        long totalOrderCount = orderDAO.getTotalOrderCount();
        double totalRevenue = orderDAO.getTotalRevenue();
        double avgOrderValue = orderDAO.getAverageOrderValue();
        double maxOrderValue = orderDAO.getMaxOrderValue();
        double minOrderValue = orderDAO.getMinOrderValue();

        request.setAttribute("totalOrderCount", totalOrderCount);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("avgOrderValue", avgOrderValue);
        request.setAttribute("maxOrderValue", maxOrderValue);
        request.setAttribute("minOrderValue", minOrderValue);
        request.setAttribute("orderCount", orderCount);
        session.setAttribute("listProduct", listProduct);
        session.setAttribute("listCategory", listCategory);
        request.setAttribute("notificationCount", notificationCount);
        request.getRequestDispatcher("../view/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
