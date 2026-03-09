/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import controller.common.HeaderDataSupport;
import dal.implement.AnswerDAO;
import dal.implement.ProductDAO;
import dal.implement.ProductSizeDAO;
import dal.implement.QuestionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Answer;
import model.Product;
import model.ProductImage;
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
        List<ProductSize> listProductSize = productSizeDAO.getQuantityOfSizes(id);
        List<String> listColor = mergeColors(productSizeDAO.getColorsByProduct(id), productFindById);
        Map<Integer, List<Answer>> answersByQuestion = new HashMap<>();
        for (Question q : qnaQuestions) {
            List<Answer> answers = answerDAO.getApprovedByQuestionId(q.getId());
            answersByQuestion.put(q.getId(), answers);
        }
        //set product vao request va chuyen sang product-details- 
        request.setAttribute("qnaQuestions", qnaQuestions);
        request.setAttribute("answersByQuestion", answersByQuestion);
        request.setAttribute("product", productFindById);
        request.setAttribute("listColor", listColor);
        request.setAttribute("listProductSize", listProductSize);
        request.setAttribute("selectedColor", normalizeColor(request.getParameter("color")));
        HeaderDataSupport.populate(request);
        request.getRequestDispatcher("view/homepage/product-details.jsp").forward(request, response);
    }

    private List<String> mergeColors(List<String> colorsFromSize, Product product) {
        Map<String, String> colorMap = new LinkedHashMap<>();

        if (colorsFromSize != null) {
            for (String color : colorsFromSize) {
                String normalizedColor = normalizeColor(color);
                if (normalizedColor != null) {
                    colorMap.putIfAbsent(normalizedColor, normalizedColor);
                }
            }
        }

        if (product != null && product.getImages() != null) {
            for (ProductImage image : product.getImages()) {
                if (image == null) {
                    continue;
                }

                String normalizedColor = normalizeColor(image.getColor());
                if (normalizedColor != null) {
                    colorMap.putIfAbsent(normalizedColor, normalizedColor);
                }
            }
        }

        return new ArrayList<>(colorMap.values());
    }

    private String normalizeColor(String rawColor) {
        if (rawColor == null || rawColor.isBlank()) {
            return null;
        }

        return rawColor.trim().toUpperCase();
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
