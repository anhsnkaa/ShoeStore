package controller.common;

import dal.implement.CategoryDAO;
import dal.implement.ProductDAO;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import model.Category;

public final class HeaderDataSupport {

    private HeaderDataSupport() {
    }

    public static void populate(HttpServletRequest request) {
        CategoryDAO categoryDAO = new CategoryDAO();
        ProductDAO productDAO = new ProductDAO();

        if (request.getAttribute("menCategories") == null) {
            List<Category> menCategories = categoryDAO.getCategoriesByGender("MEN");
            request.setAttribute("menCategories", menCategories);
        }

        if (request.getAttribute("womenCategories") == null) {
            List<Category> womenCategories = categoryDAO.getCategoriesByGender("WOMEN");
            request.setAttribute("womenCategories", womenCategories);
        }

        if (request.getAttribute("listCollection") == null) {
            request.setAttribute("listCollection", productDAO.getAllCollections());
        }

        Object viewMode = request.getAttribute("viewMode");
        if (viewMode == null || String.valueOf(viewMode).isBlank()) {
            request.setAttribute("viewMode", "product");
        }
    }
}
