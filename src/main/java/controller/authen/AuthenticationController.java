/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authen;

import dal.implement.AccountDAO;
import dal.implement.RoleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Role;

/**
 *
 * @author FPTShop
 */
public class AuthenticationController extends HttpServlet {

    AccountDAO accountDAO = new AccountDAO();
    RoleDAO roleDAO = new RoleDAO();

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
                break;
            case "sign-up":
                url = "view/authen/sign-up.jsp";
                break;
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        //dựa theo action để xử lý request
        String url;
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "sign-up":
                url = signUpDoPost(request, response);
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
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // xoa account + cart + moi du lieu session
        }
        return "home";
    }

    private String signUpDoPost(HttpServletRequest request, HttpServletResponse response) {
        //get ve cac thong tin nguoi dung nhap
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String address = request.getParameter("address").trim();
        //kiem tra xem username da ton tai trong db
        if (accountDAO.isUsernameExists(username)) {
            //true => quay tro lai trang register thong bao loi
            request.setAttribute("error", "Username already exists!");
            return "view/authen/sign-up.jsp";
        } else {
            //false => quay tro lai trang home (ghi tai khoan vao trong db)
            Role userRole = roleDAO.findById(2); // giả sử 2 là USER

            Account acc = new Account();
            acc.setFullName(fullName);
            acc.setUsername(username);
            acc.setPassword(password); // ⚠ sau này nên hash
            acc.setEmail(email);
            acc.setPhone(phone);
            acc.setAddress(address);
            acc.setStatus(true);
            acc.setRole(userRole);

            accountDAO.addAccount(acc);
            //tự động login sau khi đăng kí
            HttpSession session = request.getSession();
            session.setAttribute("account", acc);

            return "home";
        }
    }
}
