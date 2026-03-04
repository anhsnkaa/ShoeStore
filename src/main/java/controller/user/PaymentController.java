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
        int productId = parseIntOrDefault(request.getParameter("productId"), -1);
        int sizeId = parseIntOrDefault(request.getParameter("sizeId"), -1);
        String requestedColor = normalizeColor(request.getParameter("color"));
        //get ve quantity
        int quantity = Math.max(1, parseIntOrDefault(request.getParameter("quantity"), 1));

        if (productId <= 0 || sizeId <= 0) {
            setCartMessage(session, "error", "Invalid product information.");
            return;
        }

        //lay ve cart o tren session
        Order cart = (Order) session.getAttribute("cart");
        if (cart == null) {
            cart = new Order();
        }

        Product product = productDAO.getProductById(productId);
        ProductSize productSize = productSizeDAO.getSizeById(sizeId);

        if (product == null || productSize == null || productSize.getProduct() == null
                || productSize.getProduct().getId() != productId) {
            setCartMessage(session, "error", "Product size is invalid.");
            return;
        }

        String selectedColor = normalizeColor(productSize.getColor());
        if (selectedColor == null) {
            selectedColor = requestedColor;
        }

        if (requestedColor != null && selectedColor != null && !requestedColor.equals(selectedColor)) {
            setCartMessage(session, "error", "Selected color is invalid.");
            return;
        }

        int availableQuantity = Math.max(0, productSize.getQuantity());
        if (availableQuantity <= 0) {
            setCartMessage(session, "error", "Selected size is out of stock.");
            return;
        }

        boolean limitedByStock = false;
        boolean existsInCart = false;

        for (OrderDetail obj : cart.getOrderDetails()) {
            if (isSameCartLine(obj, productId, productSize.getSize(), selectedColor)) {
                int newQuantity = obj.getQuantity() + quantity;
                if (newQuantity > availableQuantity) {
                    obj.setQuantity(availableQuantity);
                    limitedByStock = true;
                } else {
                    obj.setQuantity(newQuantity);
                }
                existsInCart = true;
                break;
            }
        }

        if (!existsInCart) {
            OrderDetail od = new OrderDetail();
            od.setProduct(product);
            od.setPrice(product.getFinalPrice());
            od.setSize(productSize.getSize());
            od.setColor(selectedColor);
            if (quantity > availableQuantity) {
                od.setQuantity(availableQuantity);
                limitedByStock = true;
            } else {
                od.setQuantity(quantity);
            }

            //them order details vao trong cart
            cart.getOrderDetails().add(od);
        }

        //them orderdetails vao trong cart
        session.setAttribute("cart", cart);

        if (limitedByStock) {
            setCartMessage(session, "error", "Quantity was adjusted to available stock.");
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
            int size = parseIntOrDefault(request.getParameter("size"), Integer.MIN_VALUE);
            String color = normalizeColor(request.getParameter("color"));
            //get ve quantity
            int quantity = Math.max(1, Integer.parseInt(request.getParameter("quantity")));
            //lay ve cart
            Order cart = (Order) session.getAttribute("cart");

            // Neu cart null thi khong can xu ly tiep.
            if (cart == null || cart.getOrderDetails() == null) {
                return;
            }

            OrderDetail target = null;
            for (OrderDetail obj : cart.getOrderDetails()) {
                if (obj.getProduct().getId() == id
                        && (size == Integer.MIN_VALUE || obj.getSize() == size)
                        && (color == null || isSameColor(obj.getColor(), color))) {
                    target = obj;
                    break;
                }
            }

            if (target == null) {
                return;
            }

            int availableQuantity = getAvailableQuantity(target.getProduct().getId(), target.getSize(), target.getColor());
            if (availableQuantity <= 0) {
                cart.getOrderDetails().remove(target);
                setCartMessage(session, "error", "Product is out of stock and was removed from cart.");
                return;
            }

            if (quantity > availableQuantity) {
                target.setQuantity(availableQuantity);
                setCartMessage(session, "error", "Quantity exceeds stock. Updated to maximum available quantity.");
            } else {
                target.setQuantity(quantity);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        int id = Integer.parseInt(request.getParameter("id"));
        int size = parseIntOrDefault(request.getParameter("size"), Integer.MIN_VALUE);
        String color = normalizeColor(request.getParameter("color"));
        Order cart = (Order) session.getAttribute("cart");

        // Neu cart null thi khong can xu ly tiep.
        if (cart == null || cart.getOrderDetails() == null) {
            return;
        }

        OrderDetail od = null;
        for (OrderDetail obj : cart.getOrderDetails()) {
            if (obj.getProduct().getId() == id
                    && (size == Integer.MIN_VALUE || obj.getSize() == size)
                    && (color == null || isSameColor(obj.getColor(), color))) {
                od = obj;
                break;
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

        boolean adjustedByStock = false;
        for (OrderDetail od : cart.getOrderDetails()) {
            int availableQuantity = getAvailableQuantity(od.getProduct().getId(), od.getSize(), od.getColor());

            if (availableQuantity <= 0) {
                session.setAttribute("checkoutType", "error");
                session.setAttribute("checkoutMessage", "Some products are out of stock. Please update your cart.");
                response.sendRedirect("payment");
                return;
            }

            if (od.getQuantity() > availableQuantity) {
                od.setQuantity(availableQuantity);
                adjustedByStock = true;
            }
        }

        if (adjustedByStock) {
            session.setAttribute("checkoutType", "error");
            session.setAttribute("checkoutMessage", "Some quantities were adjusted to available stock. Please review cart and checkout again.");
            response.sendRedirect("payment");
            return;
        }

        // Tinh tong tien cart.
        double amount = calculateAmount(cart);

        // Gan thong tin user va tong tien vao order.
        cart.setUser(account);
        cart.setTotalAmount(amount);

        // Luu order va tru kho ngay tai thoi diem checkout.
        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.insertOrderAndDeductStock(cart);

        // Chi xoa cart khi luu thanh cong.
        if (orderId > 0) {
            session.removeAttribute("cart");
            session.setAttribute("checkoutType", "success");
            session.setAttribute("checkoutMessage", "Checkout successful.");
        } else {
            session.setAttribute("checkoutType", "error");
            session.setAttribute("checkoutMessage", "Checkout failed because stock changed. Please review your cart and try again.");
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

    private int getAvailableQuantity(int productId, int size, String color) {
        ProductSize ps = productSizeDAO.getByProductSizeAndColor(productId, size, color);
        return ps == null ? 0 : Math.max(0, ps.getQuantity());
    }

    private boolean isSameCartLine(OrderDetail od, int productId, int size, String color) {
        if (od == null || od.getProduct() == null) {
            return false;
        }

        return od.getProduct().getId() == productId
                && od.getSize() == size
                && isSameColor(od.getColor(), color);
    }

    private boolean isSameColor(String a, String b) {
        String colorA = normalizeColor(a);
        String colorB = normalizeColor(b);

        if (colorA == null && colorB == null) {
            return true;
        }

        if (colorA == null || colorB == null) {
            return false;
        }

        return colorA.equals(colorB);
    }

    private String normalizeColor(String rawColor) {
        if (rawColor == null || rawColor.isBlank()) {
            return null;
        }

        return rawColor.trim().toUpperCase();
    }

    private int parseIntOrDefault(String raw, int defaultValue) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private void setCartMessage(HttpSession session, String type, String message) {
        session.setAttribute("checkoutType", type);
        session.setAttribute("checkoutMessage", message);
    }

}
