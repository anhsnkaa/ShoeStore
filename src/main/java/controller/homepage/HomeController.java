/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import controller.common.HeaderDataSupport;
import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
import java.io.IOException;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Category;
import model.HomeVariantItem;
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
        // tạo đối tượng phân trang
        PageControl pageControl = new PageControl();
        
        // các hàm normalize làm sạch dữ liệu đầu vào(nếu như viết trên url)
        String selectedGender = normalizeGender(request.getParameter("gender"));
        String viewMode = normalizeViewMode(request.getParameter("viewMode"));
        String sort = normalizeSort(request.getParameter("sort"));

        // lấy danh sách sản phẩm theo bộ lọc + sort
        List<Product> listProduct = "variant".equals(viewMode) ? List.of() : findProductDoGet(request, pageControl, sort, viewMode);
        List<HomeVariantItem> listVariantItems = "variant".equals(viewMode) ? findVariantItems(request, pageControl, sort, viewMode) : List.of();
        // lấy danh sách category để hiển thị ở side bar
        List<Category> listCategory = selectedGender == null
                ? categoryDAO.getDistinctCategoriesByName()
                : categoryDAO.getCategoriesByGender(selectedGender);
        // Đếm số sản phẩm của mỗi category
        Map<Integer, Integer> categoryProductCountMap = buildCategoryProductCountMap(listCategory, selectedGender);
        
        // lấy collection theo từng gender
        List<String> listCollection = selectedGender == null
                ? productDAO.getAllCollections()
                : productDAO.getCollectionsByGender(selectedGender);

        request.setAttribute("listProduct", listProduct);
        request.setAttribute("listVariantItems", listVariantItems);
        request.setAttribute("listCategory", listCategory);
        request.setAttribute("categoryProductCountMap", categoryProductCountMap);
        request.setAttribute("listCollection", listCollection);
        request.setAttribute("pageControl", pageControl);
        request.setAttribute("selectedGender", selectedGender);
        request.setAttribute("viewMode", viewMode);
        request.setAttribute("isHomePage", true);
        request.setAttribute("menCategories", categoryDAO.getCategoriesByGender("MEN"));
        request.setAttribute("womenCategories", categoryDAO.getCategoriesByGender("WOMEN"));
        //
        HeaderDataSupport.populate(request);
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

    // lấy danh sách các sản phẩm + phân trang + sort
    private List<Product> findProductDoGet(HttpServletRequest request, PageControl pageControl, String sort, String viewMode) {
        int page = parsePage(request.getParameter("page"));
        int pageSize = 12;
        
        //xác định kiểu lọc đang dùng
        String actionSearch = resolveActionSearch(request);
        
        //lấy đúng sản phẩm (lọc) cho trang đó
        List<Product> product = fetchProductsByAction(request, actionSearch, sort, page);
        int totalRecord = resolveTotalRecord(request, actionSearch);
        
        //lấy tổng số trang
        int totalPage = (int) Math.ceil(totalRecord * 1.0 / pageSize);
        if (totalPage <= 0) {
            totalPage = 1;
        }
        
        //nếu nhập page lớn hơn tổng trang thì sẽ là ở trang cuối
        if (page > totalPage) {
            page = totalPage;
            product = fetchProductsByAction(request, actionSearch, sort, page);
        }

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setUrlPattern(buildPageUrlPattern(request, viewMode, sort));
        return product;
    }

    //lấy danh sách các biến thể của sản phẩm + phân trang + sort
    private List<HomeVariantItem> findVariantItems(HttpServletRequest request, PageControl pageControl, String sort, String viewMode) {
        int page = parsePage(request.getParameter("page"));
        int pageSize = 12;
        
        //xác định kiểu lọc đang dùng
        String actionSearch = resolveActionSearch(request);
        
        //lấy đúng sản phẩm (lọc) cho trang đó
        List<Product> allProducts = fetchAllProductsByAction(request, actionSearch, sort);
        
        //lấy các sản phẩm được lọc để phân ra từng biến thể rồi add vào list mới
        List<HomeVariantItem> allVariantItems = buildVariantItems(allProducts);
        int totalRecord = allVariantItems.size();
        int totalPage = (int) Math.ceil(totalRecord * 1.0 / pageSize);

        if (totalPage <= 0) {
            totalPage = 1;
        }

        if (page > totalPage) {
            page = totalPage;
        }

        int fromIndex = Math.max(0, (page - 1) * pageSize);
        int toIndex = Math.min(allVariantItems.size(), fromIndex + pageSize);
        List<HomeVariantItem> pagedItems = fromIndex >= toIndex ? List.of() : allVariantItems.subList(fromIndex, toIndex);

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setUrlPattern(buildPageUrlPattern(request, viewMode, sort));
        return pagedItems;
    }

    //hàm trả về list phân ra từng biến thể
    private List<HomeVariantItem> buildVariantItems(List<Product> products) {
        List<HomeVariantItem> items = new ArrayList<>();

        if (products == null || products.isEmpty()) {
            return items;
        }

        for (Product product : products) {
            if (product == null) {
                continue;
            }

            List<String> colors = product.getAvailableColors();
            if (colors == null || colors.isEmpty()) {
                items.add(new HomeVariantItem(product, null, product.getMainImage()));
                continue;
            }

            for (String color : colors) {
                items.add(new HomeVariantItem(product, color, product.getImageByColor(color)));
            }
        }

        return items;
    }
    
    //hàm lấy tất cả các sản phẩm dựa trên action cho variant items
    private List<Product> fetchAllProductsByAction(HttpServletRequest request, String actionSearch, String sort) {
        List<Product> products = new ArrayList<>();

        for (int page = 1; page <= 500; page++) {
            List<Product> batch = fetchProductsByAction(request, actionSearch, sort, page);
            if (batch == null || batch.isEmpty()) {
                break;
            }

            products.addAll(batch);

            if (batch.size() < 12) {
                break;
            }
        }

        return products;
    }

    
    //hàm tìm sản phẩm dựa trên action cho một trang
    private List<Product> fetchProductsByAction(HttpServletRequest request, String actionSearch, String sort, int page) {
        switch (actionSearch) {
            case "category":
                Integer categoryId = parseNullableInt(request.getParameter("categoryId"));
                String selectedGender = normalizeGender(request.getParameter("gender"));
                if (categoryId == null) {
                    return List.of();
                }

                if (selectedGender == null) {
                    Category category = categoryDAO.findById(categoryId);
                    if (category == null || category.getName() == null || category.getName().isBlank()) {
                        return List.of();
                    }
                    return productDAO.getProductByCategoryName(category.getName(), page, sort);
                }

                return productDAO.getProductByCategoryAndGender(categoryId, selectedGender, page, sort);
            case "searchByKeyword":
                return productDAO.getProductByKeyword(request.getParameter("keyword"), page, sort);
            case "gender":
                String gender = normalizeGender(request.getParameter("gender"));
                return gender == null ? productDAO.getAllProductsPaging(page, sort) : productDAO.getProductByGender(gender, page, sort);
            case "collection":
                String collection = normalizeCollection(request.getParameter("collection"));
                String genderInCollection = normalizeGender(request.getParameter("gender"));
                if (collection == null) {
                    return productDAO.getAllProductsPaging(page, sort);
                }

                return genderInCollection == null
                        ? productDAO.getProductByCollection(collection, page, sort)
                        : productDAO.getProductByCollectionAndGender(collection, genderInCollection, page, sort);
            case "hot":
                String genderInHot = normalizeGender(request.getParameter("gender"));
                return genderInHot == null
                        ? productDAO.getHotProducts(page, sort)
                        : productDAO.getHotProductsByGender(genderInHot, page, sort);
            case "sale":
                String genderInSale = normalizeGender(request.getParameter("gender"));
                return genderInSale == null
                        ? productDAO.getSaleProducts(page, sort)
                        : productDAO.getSaleProductsByGender(genderInSale, page, sort);
            case "price":
                double min = parseDoubleOrDefault(request.getParameter("min"), 0);
                Double max = parseNullableDouble(request.getParameter("max"));
                if (max != null && max < min) {
                    double temp = min;
                    min = max;
                    max = temp;
                }
                return productDAO.getProductByPriceRange(min, max, page, sort);
            default:
                return productDAO.getAllProductsPaging(page, sort);
        }
    }

    //hàm dùng để đếm tổng sản phẩm tùy điều kiện lọc để phân trang
    private int resolveTotalRecord(HttpServletRequest request, String actionSearch) {
        switch (actionSearch) {
            case "category":
                Integer categoryId = parseNullableInt(request.getParameter("categoryId"));
                String selectedGender = normalizeGender(request.getParameter("gender"));
                if (categoryId == null) {
                    return 0;
                }

                if (selectedGender == null) {
                    Category category = categoryDAO.findById(categoryId);
                    if (category == null || category.getName() == null || category.getName().isBlank()) {
                        return 0;
                    }
                    return productDAO.getTotalRecordByCategoryName(category.getName());
                }

                return productDAO.getTotalRecordByCategoryAndGender(categoryId, selectedGender);
            case "searchByKeyword":
                return productDAO.getTotalRecordByKeyword(request.getParameter("keyword"));
            case "gender":
                String gender = normalizeGender(request.getParameter("gender"));
                return gender == null ? productDAO.getTotalProducts() : productDAO.getTotalRecordByGender(gender);
            case "collection":
                String collection = normalizeCollection(request.getParameter("collection"));
                String genderInCollection = normalizeGender(request.getParameter("gender"));
                if (collection == null) {
                    return productDAO.getTotalProducts();
                }
                return genderInCollection == null
                        ? productDAO.getTotalRecordByCollection(collection)
                        : productDAO.getTotalRecordByCollectionAndGender(collection, genderInCollection);
            case "hot":
                String genderInHot = normalizeGender(request.getParameter("gender"));
                return genderInHot == null
                        ? productDAO.getTotalHotProducts()
                        : productDAO.getTotalHotProductsByGender(genderInHot);
            case "sale":
                String genderInSale = normalizeGender(request.getParameter("gender"));
                return genderInSale == null
                        ? productDAO.getTotalSaleProducts()
                        : productDAO.getTotalSaleProductsByGender(genderInSale);
            case "price":
                double min = parseDoubleOrDefault(request.getParameter("min"), 0);
                Double max = parseNullableDouble(request.getParameter("max"));
                if (max != null && max < min) {
                    double temp = min;
                    min = max;
                    max = temp;
                }
                return productDAO.getTotalRecordByPriceRange(min, max);
            default:
                return productDAO.getTotalProducts();
        }
    }

        private String resolveActionSearch(HttpServletRequest request) {
        String actionSearch = request.getParameter("search");
        return actionSearch == null || actionSearch.isBlank() ? "default" : actionSearch;
    }

        //hàm lấy url để lọc dữ liệu
    private String buildPageUrlPattern(HttpServletRequest request, String viewMode, String sort) {
        StringBuilder pattern = new StringBuilder(request.getRequestURL().toString()).append("?");
        appendQueryParam(pattern, "viewMode", viewMode);
        appendQueryParam(pattern, "search", request.getParameter("search"));
        appendQueryParam(pattern, "categoryId", request.getParameter("categoryId"));
        appendQueryParam(pattern, "keyword", request.getParameter("keyword"));
        appendQueryParam(pattern, "gender", request.getParameter("gender"));
        appendQueryParam(pattern, "collection", request.getParameter("collection"));
        appendQueryParam(pattern, "min", request.getParameter("min"));
        appendQueryParam(pattern, "max", request.getParameter("max"));
        appendQueryParam(pattern, "sort", sort);
        return pattern.toString();
    }

    //hàm để gắn url
    private void appendQueryParam(StringBuilder builder, String key, String value) {
        if (value == null || value.isBlank()) {
            return;
        }

        builder.append(key)
                .append("=")
                .append(encodeQueryParam(value))
                .append("&");
    }

    //lấy dữ liệu phân trang hợp lệ
    private int parsePage(String pageRaw) {
        try {
            int page = Integer.parseInt(pageRaw);
            return page <= 0 ? 1 : page;
        } catch (Exception e) {
            return 1;
        }
    }

    //chuyển chuỗi từ request để không bị lỗi(categoryid)
    private Integer parseNullableInt(String raw) {
        try {
            return raw == null || raw.isBlank() ? null : Integer.parseInt(raw);
        } catch (Exception e) {
            return null;
        }
    }

    //tạo map lưu số lượng sản phẩm của category
    private Map<Integer, Integer> buildCategoryProductCountMap(List<Category> categories, String selectedGender) {
        Map<Integer, Integer> countMap = new LinkedHashMap<>();

        if (categories == null || categories.isEmpty()) {
            return countMap;
        }

        for (Category category : categories) {
            if (category == null) {
                continue;
            }

            int count;
            if (selectedGender == null) {
                count = productDAO.getTotalRecordByCategoryName(category.getName());
            } else {
                count = productDAO.getTotalRecordByCategoryAndGender(category.getId(), selectedGender);
            }

            countMap.put(category.getId(), Math.max(0, count));
        }

        return countMap;
    }

    // chuyển chuỗi từ request để không bị lỗi(giá tiền)
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

    private String normalizeCollection(String rawCollection) {
        if (rawCollection == null || rawCollection.isBlank()) {
            return null;
        }

        return rawCollection.trim();
    }

    private String normalizeViewMode(String rawViewMode) {
        return "variant".equalsIgnoreCase(rawViewMode) ? "variant" : "product";
    }

    private String encodeQueryParam(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
