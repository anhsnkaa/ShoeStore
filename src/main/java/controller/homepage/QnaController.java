/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import dal.implement.AnswerDAO;
import dal.implement.QuestionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Answer;
import model.Product;
import model.Question;

/**
 *
 * @author FPTShop
 */
public class QnaController extends HttpServlet {
    
    QuestionDAO questionDAO = new QuestionDAO();
    AnswerDAO answerDAO = new AnswerDAO();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/home");
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
        String action = request.getParameter("action") == null ? "" : request.getParameter("action");
        switch (action) {
            case "ask":
                handleAsk(request, response);
                break;
            case "answer":
                handleAnswer(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
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

    private void handleAsk(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        int productId = parseIntOrDefault(request.getParameter("productId"), -1);
        String content = request.getParameter("content") == null ? "" : request.getParameter("content").trim();
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        if (productId <= 0 || content.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId + "#Qna");
            return;
        }
        Question q = new Question();
        q.setContent(content);
        q.setStatus("PENDING");//duyet admin sau
        Product p = new Product();
        p.setId(productId);
        q.setProduct(p);
        q.setUser(account);
        questionDAO.insertQuestion(q);
        response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId + "#Qna");
    }

    private void handleAnswer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        int productId = parseIntOrDefault(request.getParameter("productId"), -1);
        int questionId = parseIntOrDefault(request.getParameter("questionId"), -1);
        String content = request.getParameter("content") == null ? "" : request.getParameter("content").trim();

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        if (productId <= 0 || questionId <= 0 || content.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId + "#Qna");
            return;
        }

        Answer answer = new Answer();
        answer.setContent(content);
        answer.setStatus("PENDING");
        answer.setUser(account);

        Question question = new Question();
        question.setId(questionId);
        answer.setQuestion(question);

        answerDAO.insertAnswer(answer);

        response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId + "#Qna");
    }
    
    private int parseIntOrDefault(String raw, int defaultValue) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
