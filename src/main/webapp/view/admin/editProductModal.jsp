<%-- 
    Document   : editProductModal
    Created on : Feb 28, 2026, 4:34:02 AM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5>Edit Product</h5>
                <button type="button" class="close" data-dismiss="modal">
                    &times;
                </button>
            </div>

            <div class="modal-body">

                <form id="editForm"
                      method="POST"
                      action="${pageContext.request.contextPath}/admin/product?action=update"
                      enctype="multipart/form-data">

                    <input type="hidden" name="id" id="editId">

                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" class="form-control" name="name" id="editName">
                    </div>

                    <div class="form-group">
                        <label>Price</label>
                        <input type="number" class="form-control" name="price" id="editPrice">
                    </div>
                    <!-- Category -->
                    <div class="form-group">
                        <label>Gender</label>
                        <select class="form-control" id="editGender" onchange="filterCategoryByGender('editGender', 'editCategory')"></select>
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select class="form-control" name="category" id="editCategory">
                            <c:forEach items="${listCategory}" var="c">
                                <option value="${c.id}" data-gender="${c.gender.name}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Collection</label>
                        <input type="text" class="form-control" name="collection" id="editCollection" placeholder="Ex: Winter 2026, Limited Drop" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Discount (%)</label>
                            <input type="number" class="form-control" name="discount" id="editDiscount" min="0" max="100" step="0.1" value="0">
                        </div>
                        <div class="form-group col-md-6 d-flex align-items-end">
                            <div class="form-check mb-2">
                                <input type="checkbox" class="form-check-input" name="featured" id="editFeatured" value="true">
                                <label class="form-check-label" for="editFeatured">Hot product</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Sale start</label>
                            <input type="datetime-local" class="form-control" name="saleStartAt" id="editSaleStartAt">
                        </div>
                        <div class="form-group col-md-6">
                            <label>Sale end</label>
                            <input type="datetime-local" class="form-control" name="saleEndAt" id="editSaleEndAt">
                        </div>
                    </div>
                    <!-- Description -->
                    <div class="form-group">
                        <label>Description</label>
                        <textarea class="form-control"
                                  name="description"
                                  id="editDescription"></textarea>
                    </div>
                    <!-- Variant table -->
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="mb-0">Color / Size (35-45) / Quantity</label>
                    </div>
                    <div class="form-row align-items-end mb-2">
                        <div class="col-md-6">
                            <input type="text" id="editVariantColorInput" class="form-control" placeholder="Enter color (EX: BLACK, WHITE)">
                        </div>
                        <div class="col-md-3 mt-2 mt-md-0">
                            <button type="button" class="btn btn-sm btn-outline-primary btn-block" onclick="addColorWithDefaultSizes('editSizeTable', 'editVariantColorInput')">Add color (35-45)</button>
                        </div>
                        <div class="col-md-3 mt-2 mt-md-0">
                            <button type="button" class="btn btn-sm btn-outline-secondary btn-block" onclick="addVariantFromColorInput('editSizeTable', 'editVariantColorInput')">Add variant</button>
                        </div>
                    </div>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Color</th>
                                <th>Size</th>
                                <th>Quantity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="editSizeTable"></tbody>
                    </table>

                    <!-- Images by color -->
                    <div class="form-group">
                        <div class="mb-2">
                            <label class="mb-0">Replace Images by Color</label>
                        </div>
                        <small class="form-text text-muted mb-2">After updating variants, upload image(s) for a color to replace that color only. Leave empty to keep existing images of that color.</small>
                        <div id="editImageByColorContainer"></div>
                        <div id="editImagePreviewByColor" class="mt-2"></div>
                    </div>

                </form>

            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" form="editForm" class="btn btn-primary">
                    Save
                </button>
            </div>

        </div>
    </div>
    <script>
        (function initEditGenderCategory() {
            if (typeof initGenderCategoryFilter === "function") {
                initGenderCategoryFilter('editGender', 'editCategory');
            }
        })();

        (function initEditFormValidation() {
            let editForm = document.getElementById("editForm");
            if (!editForm) {
                return;
            }

            editForm.addEventListener("submit", function (event) {
                if (typeof validateVariantRows === "function") {
                    let variantValidation = validateVariantRows("editSizeTable");
                    if (!variantValidation.valid) {
                        event.preventDefault();
                        alert(variantValidation.message);
                        return;
                    }

                    if (typeof validateColorSectionSync === "function") {
                        let syncValidation = validateColorSectionSync("editImageByColorContainer", variantValidation.colors);
                        if (!syncValidation.valid) {
                            event.preventDefault();
                            alert(syncValidation.message);
                            return;
                        }
                    }
                }
            });
        })();
        </script>
</div>
