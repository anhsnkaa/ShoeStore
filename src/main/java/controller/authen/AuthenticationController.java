/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authen;

import dal.implement.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author FPTShop
 */
public class AuthenticationController extends HttpServlet {

    AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve action
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        //dua theo action set url trang can chuyen den
        String url;
        switch (action) {
            case "login":
                url = "view/authen/login.jsp";
                break;
            case "logout":
                url = logOut(request, response);
            default:
                url = "home";
        }
        //chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
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
            throws ServletException, IOException { //get ve action
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        //dựa theo action để xử lý request
        String url;
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            default:
                url = "home";
        }
        //chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
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

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        //get về thông tin người dùng nhập
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        //kiểm tra thông tin có tồn tại trong db không
        Account accountFindByUsernamePass = accountDAO.findByUsernameAndPass(username, password);
        //true => trang home
        if (accountFindByUsernamePass != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", accountFindByUsernamePass);
            url = "home";
        } //false => quay tro lai trang login(set them thong bao loi)
        else {
            request.setAttribute("error", "Username or password incorrect!");
            url = "view/authen/login.jsp";
        }
        return url;
    }

    private String logOut(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute("account");
        return "home";
    }

}
