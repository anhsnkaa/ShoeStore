/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.implement.AnswerDAO;
import dal.implement.QuestionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Answer;
import model.Question;

/**
 *
 * @author FPTShop
 */
public class QnaAdminServerlet extends HttpServlet {

    QuestionDAO questionDAO = new QuestionDAO();
    AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Question> pendingQuestions = questionDAO.getPendingQuestions();
        List<Answer> pendingAnswers = answerDAO.getPendingAnswers();
        request.setAttribute("pendingQuestions", pendingQuestions);
        request.setAttribute("pendingAnswers", pendingAnswers);
        request.getRequestDispatcher("/view/admin/qna.jsp").forward(request, response);
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
            case "approve-question":
                questionDAO.updateQuestionStatus(parseInt(request.getParameter("questionId")), "APPROVED");
                break;
            case "reject-question":
                questionDAO.updateQuestionStatus(parseInt(request.getParameter("questionId")), "REJECTED");
                break;
            case "approve-answer":
                answerDAO.updateAnswerStatus(parseInt(request.getParameter("answerId")), "APPROVED");
                break;
            case "reject-answer":
                answerDAO.updateAnswerStatus(parseInt(request.getParameter("answerId")), "REJECTED");
                break;
            default:
                break;
        }
        response.sendRedirect(request.getContextPath() + "/admin/qna");
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
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
