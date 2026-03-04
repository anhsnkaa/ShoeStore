<%-- 
    Document   : addProductModal
    Created on : Feb 24, 2026, 1:47:44 AM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Modal -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModal" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBookModalLabel">Add</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="addProductForm" action="${pageContext.request.contextPath}/admin/product?action=add" method="POST" enctype="multipart/form-data">
                    <!--Name-->
                    <div class="form-group">
                        <label for="name">Name:</label>
                        <input type="text" class="form-control" id="nameInput" name="name">
                        <div id="nameError" class="error"></div>
                    </div>
                    <!--Price-->
                    <div class="form-group">
                        <label for="price">Price:</label>
                        <input type="text" class="form-control" id="priceInput" name="price">
                        <div id="priceError" class="error"></div>
                    </div>
                    <!--Category-->
                    <div class="form-group">
                        <label for="category">Category: </label>
                        <div class="input-group">
                            <select class="custom-select" id="category" name="category">
                                <c:forEach items="${listCategory}" var="c">
                                    <option value="${c.id}">${c.name} <c:if test="${not empty c.gender and not empty c.gender.name}">(${c.gender.name})</c:if></option>
                                </c:forEach>
                            </select>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button">Category</button>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="collection">Collection: </label>
                        <input type="text" class="form-control" id="collection" name="collection" placeholder="Ex: Winter 2026, Limited Drop" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="discount">Discount (%)</label>
                            <input type="number" class="form-control" id="discount" name="discount" min="0" max="100" step="0.1" value="0">
                        </div>
                        <div class="form-group col-md-6 d-flex align-items-end">
                            <div class="form-check mb-2">
                                <input type="checkbox" class="form-check-input" id="featured" name="featured" value="true">
                                <label class="form-check-label" for="featured">Hot product</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="saleStartAt">Sale start</label>
                            <input type="datetime-local" class="form-control" id="saleStartAt" name="saleStartAt">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="saleEndAt">Sale end</label>
                            <input type="datetime-local" class="form-control" id="saleEndAt" name="saleEndAt">
                        </div>
                    </div>
                    <!--Image-->
                    <div class="form-group">
                        <label for="image">Image: </label>
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Upload</span>
                            </div>
                            <div class="custom-file">
                                <input type="file"
                                       class="custom-file-input"
                                       id="images"
                                       name="images"
                                       onchange="displayImages(this)"
                                       multiple>
                                <label class="custom-file-label" >Choose file</label>
                            </div>
                        </div>
                        <div id="previewContainer" class="row mt-2"></div>

                    </div>
                    <!--Description-->
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea class="form-control" name="description"></textarea>
                    </div>
                    <!-- Color / Size / Quantity -->
                    <div class="form-group">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label class="mb-0">Color / Size / Quantity</label>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="addVariantRow('addVariantTable')">Add variant</button>
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
                            <tbody id="addVariantTable"></tbody>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary" form="addProductForm" onclick="validateForm()">Add</button>
            </div>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        let name = $('#nameInput').val();
//        let author = $('#authorInput').val();
        let price = $('#priceInput').val();

        //xoá thông báo lỗi hiện tại
        $('.error').html('');

        if (name === '') {
            $('#nameError').html('Tên không được để trống');
        }

//        if (author === '') {
//            $('#authorError').html('Tên tác giả không được để trống');
//        }

        if (price === '') {
            $('#priceError').html('Giá của không được để trống');
        } else if (!$.isNumeric(price) || parseFloat(price) < 0) {
            $('#priceError').html('Giá của phải là số và không được nhỏ hơn 0');
        }
        // Kiểm tra nếu không có lỗi thì submit form
        let error = '';
        $('.error').each(function () {
            error += $(this).html();
        });
        if (error === '') {
            $('#addProductForm').submit();
        } else {
            event.preventDefault();
        }
    }

    function addVariantRow(tableId, colorValue, sizeValue, qtyValue) {
        let tbody = document.getElementById(tableId);
        if (!tbody) {
            return;
        }

        let safeColor = String(colorValue || "")
                .replace(/&/g, "&amp;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;");

        let tr = document.createElement("tr");
        tr.innerHTML = ""
                + "<td><input type='text' name='variantColor' class='form-control' value='" + safeColor + "' oninput='this.value = this.value.toUpperCase()' placeholder='EX: BLACK, INFERNO' required></td>"
                + "<td><input type='number' name='variantSize' class='form-control' min='1' value='" + (sizeValue || 36) + "' required></td>"
                + "<td><input type='number' name='variantQty' class='form-control' min='0' value='" + (qtyValue || 0) + "' required></td>"
                + "<td><button type='button' class='btn btn-sm btn-outline-danger' onclick='removeVariantRow(this)'>Remove</button></td>";

        tbody.appendChild(tr);
    }

    function removeVariantRow(button) {
        let row = button.closest("tr");
        if (!row) {
            return;
        }

        let tbody = row.parentElement;
        row.remove();

        if (tbody && tbody.children.length === 0) {
            addVariantRow(tbody.id);
        }
    }

    (function initVariantRows() {
        addVariantRow('addVariantTable', '', 36, 0);
    })();

    function displayImages(input) {

        let previewContainer = document.getElementById("previewContainer");
        previewContainer.innerHTML = ""; // clear ảnh cũ

        if (input.files) {

            for (let i = 0; i < input.files.length; i++) {

                let reader = new FileReader();

                reader.onload = function (e) {

                    let col = document.createElement("div");
                    col.className = "col-md-4 mb-2";

                    let img = document.createElement("img");
                    img.src = e.target.result;
                    img.className = "img-fluid img-thumbnail";

                    col.appendChild(img);
                    previewContainer.appendChild(col);
                };

                reader.readAsDataURL(input.files[i]);
            }
        }
    }


</script>
