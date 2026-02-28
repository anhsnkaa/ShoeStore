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
                    <!--Image-->
                    <div class="form-group">
                        <label>Image:</label>
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Upload</span>
                            </div>
                            <div class="custom-file">
                                <input type="file"
                                       class="custom-file-input"
                                       id="editImage"
                                       name="image"
                                       onchange="previewEditImage(this)">
                                <label class="custom-file-label">
                                    Choose file
                                </label>
                            </div>
                        </div>
                        <img id="editPreviewImage"
                             src="#"
                             alt="Preview"
                             style="display:none; max-width:300px; max-height:300px;">
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
</div>