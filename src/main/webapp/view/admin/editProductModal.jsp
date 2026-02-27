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