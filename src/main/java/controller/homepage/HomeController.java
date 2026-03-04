/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.PageControl;
import model.Product;

/**
 *
 * @author FPTShop
 */
public class HomeController extends HttpServlet {

    // DAO chinh dung de lay du lieu san pham tren home.
    ProductDAO productDAO = new ProductDAO();
    // DAO category cho bo loc category.
    CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khoi tao thong tin phan trang cho lan tai hien tai.
        PageControl pageControl = new PageControl();
        String selectedGender = normalizeGender(request.getParameter("gender"));

        // Lay danh sach san pham theo bo loc + sort.
        List<Product> listProduct = findProductDoGet(request, pageControl);
        // Lay danh sach category de hien thi o sidebar.
        List<Category> listCategory = selectedGender == null
                ? categoryDAO.getAllCategories()
                : categoryDAO.getCategoriesByGender(selectedGender);

        // Day du lieu vao session de jsp dung truc tiep.
        HttpSession session = request.getSession();
        session.setAttribute("listProduct", listProduct);
        session.setAttribute("listCategory", listCategory);
        session.setAttribute("pageControl", pageControl);
        request.setAttribute("selectedGender", selectedGender);
        // Chuyen huong den trang home.jsp.
        request.getRequestDispatcher("view/homepage/home.jsp").forward(request, response);
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
        // Home chi xu ly GET, POST se chuyen ve GET.
        response.sendRedirect("home");
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

    // Xu ly tat ca bo loc/search/sort va tinh toan thong tin phan trang.
    private List<Product> findProductDoGet(HttpServletRequest request, PageControl pageControl) {
        // Lay page tu request.
        String pageRaw = request.getParameter("page");

        // Validate page.
        int page;
        int pageSize = 12;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 0) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Lay action search hien tai.
        String actionSearch = request.getParameter("search") == null
                ? "default" : request.getParameter("search");

        // Chuan hoa gia tri sort de dung cho query.
        String sort = normalizeSort(request.getParameter("sort"));

        // Bien chua ket qua san pham.
        List<Product> product;

        // URL hien tai de tao pattern cho pagination.
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;
        String sortQuery = buildSortQuery(sort);

        switch (actionSearch) {
            case "category":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String selectedGender = normalizeGender(request.getParameter("gender"));
                if (selectedGender == null) {
                    totalRecord = productDAO.getTotalRecordByCategory(categoryId);
                    product = productDAO.getProductByCategory(categoryId, page, sort);
                    pageControl.setUrlPattern(requestURL + "?search=category&categoryId=" + categoryId + sortQuery + "&");
                } else {
                    totalRecord = productDAO.getTotalRecordByCategoryAndGender(categoryId, selectedGender);
                    product = productDAO.getProductByCategoryAndGender(categoryId, selectedGender, page, sort);
                    pageControl.setUrlPattern(requestURL + "?search=category&categoryId=" + categoryId + "&gender=" + selectedGender + sortQuery + "&");
                }
                break;
            case "searchByKeyword":
                String keyword = request.getParameter("keyword");
                totalRecord = productDAO.getTotalRecordByKeyword(keyword);
                product = productDAO.getProductByKeyword(keyword, page, sort);
                pageControl.setUrlPattern(requestURL + "?search=searchByKeyword&keyword=" + keyword + sortQuery + "&");
                break;
            case "gender":
                String gender = normalizeGender(request.getParameter("gender"));
                if (gender == null) {
                    product = productDAO.getAllProductsPaging(page, sort);
                    totalRecord = productDAO.getTotalProducts();
                    pageControl.setUrlPattern(requestURL + "?" + (sort == null ? "" : "sort=" + sort + "&"));
                    break;
                }
                totalRecord = productDAO.getTotalRecordByGender(gender);
                product = productDAO.getProductByGender(gender, page, sort);
                pageControl.setUrlPattern(requestURL + "?search=gender&gender=" + gender + sortQuery + "&");
                break;
            case "price":
                double min = parseDoubleOrDefault(request.getParameter("min"), 0);
                Double max = parseNullableDouble(request.getParameter("max"));

                if (max != null && max < min) {
                    double temp = min;
                    min = max;
                    max = temp;
                }

                totalRecord = productDAO.getTotalRecordByPriceRange(min, max);
                product = productDAO.getProductByPriceRange(min, max, page, sort);

                StringBuilder pattern = new StringBuilder(requestURL)
                        .append("?search=price&min=")
                        .append(min);

                if (max != null) {
                    pattern.append("&max=").append(max);
                }

                pattern.append(sortQuery);

                pattern.append("&");
                pageControl.setUrlPattern(pattern.toString());
                break;
            default:
                product = productDAO.getAllProductsPaging(page, sort);
                totalRecord = productDAO.getTotalProducts();
                pageControl.setUrlPattern(requestURL + "?" + (sort == null ? "" : "sort=" + sort + "&"));
        }

        // Tinh tong page.
        int totalPage = (int) Math.ceil(totalRecord * 1.0 / pageSize);

        // Set thong tin phan trang cho view.
        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);
        return product;
    }

    // Parse double va tra gia tri mac dinh neu loi.
    private double parseDoubleOrDefault(String raw, double defaultValue) {
        try {
            return Double.parseDouble(raw);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    // Parse double co the null (dung cho max gia).
    private Double parseNullableDouble(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return null;
        }

        try {
            return Double.parseDouble(raw);
        } catch (Exception e) {
            return null;
        }
    }

    // Chuan hoa sort de chi chap nhan cac gia tri hop le.
    private String normalizeSort(String rawSort) {
        if (rawSort == null || rawSort.isBlank()) {
            return null;
        }

        switch (rawSort) {
            case "nameAsc":
            case "nameDesc":
            case "priceAsc":
            case "priceDesc":
                return rawSort;
            default:
                return null;
        }
    }

    // Tao query-string cho sort de giu trang thai khi loc + phan trang.
    private String buildSortQuery(String sort) {
        return sort == null ? "" : "&sort=" + sort;
    }

    private String normalizeGender(String rawGender) {
        if (rawGender == null || rawGender.isBlank()) {
            return null;
        }

        String normalized = rawGender.trim().toUpperCase();
        if ("MEN".equals(normalized) || "WOMEN".equals(normalized)) {
            return normalized;
        }

        return null;
    }
}
