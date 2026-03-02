/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.implement.ProductDAO;
import dal.implement.ProductSizeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.ProductSize;

/**
 *
 * @author FPTShop
 */
public class PaymentController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();
    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/user/payment/cart.jsp").forward(request, response);
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
        String action = request.getParameter("action") == null
                ? "" : request.getParameter("action");
        switch (action) {
            case "add-product":
                addProduct(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //get ve session
        HttpSession session = request.getSession();
        //get ve product id va size id
        int productId = Integer.parseInt(request.getParameter("productId"));
        int sizeId = Integer.parseInt(request.getParameter("sizeId"));
        //get ve quantity
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        //lay ve cart o tren session
        Order cart = (Order) session.getAttribute("cart");
        if (cart == null) {
            cart = new Order();
        }
        OrderDetail od = new OrderDetail();
        Product product = productDAO.getProductById(productId);
        ProductSize productSize = productSizeDAO.getSizeById(sizeId);
        od.setProduct(product);
        od.setPrice(product.getFinalPrice());
        od.setSize(productSize.getSize());
        od.setQuantity(quantity);

        //them order details vao trong cart
        addOrderDetailsToOrder(od, cart);

        //them orderdetails vao trong cart
        session.setAttribute("cart", cart);
        response.sendRedirect("payment");
    }

    private void addOrderDetailsToOrder(OrderDetail od, Order cart) {
        boolean isAdd = false;
        for (OrderDetail obj : cart.getOrderDetails()) {

            if (obj.getProduct().getId() == od.getProduct().getId()
                    && obj.getSize() == od.getSize()) {

                obj.setQuantity(obj.getQuantity() + od.getQuantity());
                isAdd = true;
                break;
            }
        }
        if (!isAdd) {
            cart.getOrderDetails().add(od);
        }
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

}
