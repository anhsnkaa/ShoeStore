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
                                <option value="${c.id}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select class="form-control" name="gender" id="editGender" required>
                            <option value="MEN">Men</option>
                            <option value="WOMEN">Women</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Collection</label>
                        <select class="form-control" name="collection" id="editCollection" required>
                            <option value="SPRING">Spring</option>
                            <option value="SUMMER">Summer</option>
                            <option value="AUTUMN">Autumn</option>
                            <option value="WINTER">Winter</option>
                        </select>
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
                    <!-- Size table -->
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Size</th>
                                <th>Quantity</th>
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
