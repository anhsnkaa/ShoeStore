/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import dal.implement.AnswerDAO;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Answer;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.ProductSize;
import model.Question;

/**
 *
 * @author FPTShop
 */
public class ProductDetailsController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();
    ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    QuestionDAO questionDAO = new QuestionDAO();
    AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve id product
        int id = Integer.parseInt(request.getParameter("id"));

        //lay product tu database
        Product productFindById = productDAO.getProductById(id);

        //lấy list câu hỏi đã duyệt:
        List<Question> qnaQuestions = questionDAO.getApprovedByProductId(id);

        //get ve list productSizeDAO
        List<ProductSize> listProductSize = productSizeDAO.getSizesByProduct(id);
        Map<Integer, List<Answer>> answersByQuestion = new HashMap<>();
        for (Question q : qnaQuestions) {
            List<Answer> answers = answerDAO.getApprovedByQuestionId(q.getId());
            answersByQuestion.put(q.getId(), answers);
        }
        //set product vao request va chuyen sang product-details- 
        request.setAttribute("qnaQuestions", qnaQuestions);
        request.setAttribute("answersByQuestion", answersByQuestion);
        request.setAttribute("product", productFindById);
        request.setAttribute("listProductSize", listProductSize);
        request.getRequestDispatcher("view/homepage/product-details.jsp").forward(request, response);
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
