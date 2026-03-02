/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.implement.OrderDAO;
import dal.implement.ProductDAO;
import dal.implement.ProductSizeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
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
        HttpSession session = request.getSession();
        Object checkoutMessage = session.getAttribute("checkoutMessage");
        Object checkoutType = session.getAttribute("checkoutType");

        if (checkoutMessage != null) {
            request.setAttribute("checkoutMessage", checkoutMessage);
            session.removeAttribute("checkoutMessage");
        }

        if (checkoutType != null) {
            request.setAttribute("checkoutType", checkoutType);
            session.removeAttribute("checkoutType");
        }

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
            case "change-quantity":
                changeQuantity(request, response);
                break;
            case "delete-product":
                deleteProduct(request, response);
                break;
            case "check-out":
                checkOut(request, response);
                return;
            default:
                break;
        }
        response.sendRedirect("payment");
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

    private void changeQuantity(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        try {
            //get ve product id
            int id = Integer.parseInt(request.getParameter("id"));
            //get ve quantity
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            //lay ve cart
            Order cart = (Order) session.getAttribute("cart");

            // Neu cart null thi khong can xu ly tiep.
            if (cart == null || cart.getOrderDetails() == null) {
                return;
            }

            //thay doi quantity
            for (OrderDetail obj : cart.getOrderDetails()) {
                if (obj.getProduct().getId() == id) {
                    obj.setQuantity(quantity);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        int id = Integer.parseInt(request.getParameter("id"));
        Order cart = (Order) session.getAttribute("cart");

        // Neu cart null thi khong can xu ly tiep.
        if (cart == null || cart.getOrderDetails() == null) {
            return;
        }

        OrderDetail od = null;
        for (OrderDetail obj : cart.getOrderDetails()) {
            if (obj.getProduct().getId() == id) {
                od = obj;
            }
        }
        cart.getOrderDetails().remove(od);
    }

    private void checkOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Lay cart trong session.
        HttpSession session = request.getSession();
        Order cart = (Order) session.getAttribute("cart");

        // Neu cart null hoac khong co san pham thi dung xu ly.
        if (cart == null || cart.getOrderDetails() == null || cart.getOrderDetails().isEmpty()) {
            session.setAttribute("checkoutType", "error");
            session.setAttribute("checkoutMessage", "Your cart is empty.");
            response.sendRedirect("payment");
            return;
        }

        // Lay tai khoan dang dang nhap.
        Account account = (Account) session.getAttribute("account");

        // Neu chua dang nhap thi khong cho checkout.
        if (account == null) {
            session.setAttribute("checkoutType", "error");
            session.setAttribute("checkoutMessage", "Please login before checkout.");
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        // Tinh tong tien cart.
        double amount = calculateAmount(cart);

        // Gan thong tin user va tong tien vao order.
        cart.setUser(account);
        cart.setTotalAmount(amount);

        // Luu order, orderDetails duoc luu cung nho CascadeType.ALL.
        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.insertOrder(cart);

        // Chi xoa cart khi luu thanh cong.
        if (orderId > 0) {
            session.removeAttribute("cart");
            session.setAttribute("checkoutType", "success");
            session.setAttribute("checkoutMessage", "Checkout successful.");
        } else {
            session.setAttribute("checkoutType", "error");
            session.setAttribute("checkoutMessage", "Checkout failed. Please try again.");
        }

        response.sendRedirect("payment");
    }

    private double calculateAmount(Order cart) {
        // Neu cart null hoac khong co item thi tong tien = 0.
        if (cart == null || cart.getOrderDetails() == null || cart.getOrderDetails().isEmpty()) {
            return 0;
        }

        // Cong tien cua tung orderDetail.
        double total = 0;
        for (OrderDetail od : cart.getOrderDetails()) {
            total += od.getPrice() * od.getQuantity();
        }

        // Tra tong tien ve cho ham goi.
        return total;
    }

}
