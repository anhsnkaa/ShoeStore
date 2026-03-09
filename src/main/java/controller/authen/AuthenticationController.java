/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authen;

import controller.common.HeaderDataSupport;
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
            case "forgot-password":
                url = "view/authen/forgot-password.jsp";
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
        if (url != null && url.startsWith("view/")) {
            HeaderDataSupport.populate(request);
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
            case "forgot-password":
                url = forgotPasswordDoPost(request);
                break;
            case "change-password":
                changePasswordDoPost(request, response);
                return;
            case "update-profile":
                updateProfileDoPost(request, response);
                return;
            default:
                url = "home";
        }
        if (url != null && url.startsWith("view/")) {
            HeaderDataSupport.populate(request);
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
            if (accountFindByUsernamePass.getRole() == null) {
                request.setAttribute("error", "Account role is missing. Please initialize Roles data.");
                return "view/authen/login.jsp";
            }
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
            Role userRole = roleDAO.findByName("USER");
            if (userRole == null) {
                userRole = roleDAO.findById(2); // fallback du lieu cu
            }
            if (userRole == null) {
                userRole = roleDAO.getOrCreateRole("USER");
            }

            if (userRole == null) {
                request.setAttribute("error", "Role USER is missing. Please initialize Roles table.");
                return "view/authen/sign-up.jsp";
            }

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
            Account freshAccount = accountDAO.findByUsernameAndPass(username, password);
            session.setAttribute("account", freshAccount != null ? freshAccount : acc);

            return "home";
        }
    }

    private String forgotPasswordDoPost(HttpServletRequest request) {
        String username = request.getParameter("username") == null ? "" : request.getParameter("username").trim();
        String email = request.getParameter("email") == null ? "" : request.getParameter("email").trim();
        String newPassword = request.getParameter("newPassword") == null ? "" : request.getParameter("newPassword").trim();
        String confirmPassword = request.getParameter("confirmPassword") == null ? "" : request.getParameter("confirmPassword").trim();

        if (username.isEmpty() || email.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Please fill all fields.");
            return "view/authen/forgot-password.jsp";
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match.");
            return "view/authen/forgot-password.jsp";
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters.");
            return "view/authen/forgot-password.jsp";
        }

        Account account = accountDAO.findActiveByUsernameAndEmail(username, email);
        if (account == null) {
            request.setAttribute("error", "Username or email is incorrect.");
            return "view/authen/forgot-password.jsp";
        }

        boolean ok = accountDAO.updatePassword(account.getId(), newPassword);
        if (!ok) {
            request.setAttribute("error", "Reset password failed. Please try again.");
            return "view/authen/forgot-password.jsp";
        }

        request.setAttribute("message", "Password reset successfully. Please login again.");
        return "view/authen/login.jsp";
    }

    private void changePasswordDoPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        String currentPassword = request.getParameter("currentPassword") == null ? "" : request.getParameter("currentPassword").trim();
        String newPassword = request.getParameter("newPassword") == null ? "" : request.getParameter("newPassword").trim();
        String confirmPassword = request.getParameter("confirmPassword") == null ? "" : request.getParameter("confirmPassword").trim();
        String target = request.getParameter("target") == null ? "" : request.getParameter("target").trim();
        String redirectUrl;
        if ("admin".equals(target)) {
            redirectUrl = request.getContextPath() + "/admin/dashboard";
        } else if ("user".equals(target)) {
            redirectUrl = request.getContextPath() + "/dashboard";
        } else {
            redirectUrl = isAdmin(account)
                    ? request.getContextPath() + "/admin/dashboard"
                    : request.getContextPath() + "/dashboard";
        }
        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Please fill all password fields.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (!account.getPassword().equals(currentPassword)) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Current password is incorrect.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Confirm password does not match.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (newPassword.length() < 6) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "New password must be at least 6 characters.");
            response.sendRedirect(redirectUrl);
            return;
        }
        boolean ok = accountDAO.updatePassword(account.getId(), newPassword);
        if (!ok) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Change password failed.");
            response.sendRedirect(redirectUrl);
            return;
        }
        account.setPassword(newPassword);
        session.setAttribute("account", account);
        session.setAttribute("authType", "success");
        session.setAttribute("authMessage", "Password changed successfully.");
        response.sendRedirect(redirectUrl);
    }

    private void updateProfileDoPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        String fullName = request.getParameter("fullName") == null ? "" : request.getParameter("fullName").trim();
        String email = request.getParameter("email") == null ? "" : request.getParameter("email").trim();
        String phone = request.getParameter("phone") == null ? "" : request.getParameter("phone").trim();
        String address = request.getParameter("address") == null ? "" : request.getParameter("address").trim();
        String target = request.getParameter("target") == null ? "" : request.getParameter("target").trim();
        String redirectUrl;
        if ("admin".equals(target)) {
            redirectUrl = request.getContextPath() + "/admin/dashboard";
        } else if ("user".equals(target)) {
            redirectUrl = request.getContextPath() + "/dashboard";
        } else {
            redirectUrl = isAdmin(account)
                    ? request.getContextPath() + "/admin/dashboard"
                    : request.getContextPath() + "/dashboard";
        }
        if (fullName.isEmpty() || email.isEmpty()) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Full name and email are required.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (accountDAO.isEmailExistsExceptId(account.getId(), email)) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Email already exists.");
            response.sendRedirect(redirectUrl);
            return;
        }
        Account updated = new Account();
        updated.setId(account.getId());
        updated.setFullName(fullName);
        updated.setEmail(email);
        updated.setPhone(phone);
        updated.setAddress(address);
        boolean ok = accountDAO.updateProfile(updated);
        if (!ok) {
            session.setAttribute("authType", "error");
            session.setAttribute("authMessage", "Update profile failed.");
            response.sendRedirect(redirectUrl);
            return;
        }
        Account fresh = accountDAO.findById(account.getId());
        session.setAttribute("account", fresh);
        session.setAttribute("authType", "success");
        session.setAttribute("authMessage", "Profile updated successfully.");
        response.sendRedirect(redirectUrl);
    }

    private boolean isAdmin(Account account) {
        if (account == null || account.getRole() == null) {
            return false;
        }

        Role role = account.getRole();
        String roleName = role.getName();
        if (roleName != null && !roleName.isBlank()) {
            return "ADMIN".equalsIgnoreCase(roleName);
        }

        return role.getId() == 1;
    }
}
