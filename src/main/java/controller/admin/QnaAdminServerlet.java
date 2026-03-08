/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.implement.AnswerDAO;
import dal.implement.QuestionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object qnaMessage = session.getAttribute("qnaMessage");
            Object qnaType = session.getAttribute("qnaType");

            if (qnaMessage != null) {
                request.setAttribute("qnaMessage", qnaMessage);
                session.removeAttribute("qnaMessage");
            }

            if (qnaType != null) {
                request.setAttribute("qnaType", qnaType);
                session.removeAttribute("qnaType");
            }
        }

        List<Question> pendingQuestions = questionDAO.getPendingQuestions();
        List<Answer> pendingAnswers = answerDAO.getPendingAnswers();
        request.setAttribute("pendingQuestions", pendingQuestions);
        request.setAttribute("pendingAnswers", pendingAnswers);
        request.setAttribute("pendingQuestionCount", pendingQuestions.size());
        request.setAttribute("pendingAnswerCount", pendingAnswers.size());
        request.setAttribute("totalPendingCount", pendingQuestions.size() + pendingAnswers.size());
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
        HttpSession session = request.getSession();
        String action = request.getParameter("action") == null ? "" : request.getParameter("action");
        boolean updated = false;
        String successMessage;

        switch (action) {
            case "approve-question":
                updated = questionDAO.updateQuestionStatus(parseInt(request.getParameter("questionId")), "APPROVED");
                successMessage = "Question approved successfully.";
                break;
            case "reject-question":
                updated = questionDAO.updateQuestionStatus(parseInt(request.getParameter("questionId")), "REJECTED");
                successMessage = "Question rejected successfully.";
                break;
            case "approve-answer":
                updated = answerDAO.updateAnswerStatus(parseInt(request.getParameter("answerId")), "APPROVED");
                successMessage = "Answer approved successfully.";
                break;
            case "reject-answer":
                updated = answerDAO.updateAnswerStatus(parseInt(request.getParameter("answerId")), "REJECTED");
                successMessage = "Answer rejected successfully.";
                break;
            default:
                successMessage = "Invalid Q&A request.";
                updated = false;
                break;
        }

        if (updated) {
            session.setAttribute("qnaType", "success");
            session.setAttribute("qnaMessage", successMessage);
        } else {
            session.setAttribute("qnaType", "error");
            session.setAttribute("qnaMessage", "Action failed. Please check the selected item.");
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
