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
                        <label>Category</label>
                        <select class="form-control" name="category" id="editCategory">
                            <c:forEach items="${listCategory}" var="c">
                                <option value="${c.id}">${c.name} <c:if test="${not empty c.gender and not empty c.gender.name}">(${c.gender.name})</c:if></option>
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
                    <!--Image-->
                    <div class="form-group">
                        <label>Images:</label>

                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Upload</span>
                            </div>
                            <div class="custom-file">
                                <input type="file"
                                       class="custom-file-input"
                                       id="editImages"
                                       name="images"
                                       multiple
                                       onchange="previewEditImages(this)">
                                <label class="custom-file-label">
                                    Choose files
                                </label>
                            </div>
                        </div>
                        <small class="form-text text-muted">Upload ảnh mới sẽ thay toàn bộ ảnh cũ của sản phẩm.</small>

                        <!-- Preview nhiều ảnh -->
                        <div id="editPreviewContainer" class="row mt-2"></div>
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
                        <label class="mb-0">Color / Size / Quantity</label>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="addVariantRow('editSizeTable')">Add variant</button>
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
        function previewEditImages(input) {

            let previewContainer = document.getElementById("editPreviewContainer");
            previewContainer.innerHTML = "";

            if (input.files.length > 0) {

                for (let i = 0; i < input.files.length; i++) {

                    let reader = new FileReader();

                    reader.onload = function (e) {

                        let col = document.createElement("div");
                        col.className = "col-md-4 mb-2";

                        let img = document.createElement("img");
                        img.src = e.target.result;
                        img.className = "img-fluid img-thumbnail";
                        img.style.height = "150px";
                        img.style.objectFit = "cover";

                        col.appendChild(img);
                        previewContainer.appendChild(col);
                    };

                    reader.readAsDataURL(input.files[i]);
                }
            }
        }
        </script>
</div>
