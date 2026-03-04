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
                                    <option value="${c.id}">${c.name}</option>
                                </c:forEach>
                            </select>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button">Category</button>
                            </div>
                        </div>
                    </div>
                    <!--Gender-->
                    <div class="form-group">
                        <label for="gender">Gender: </label>
                        <select class="custom-select" id="gender" name="gender" required>
                            <option value="MEN">Men</option>
                            <option value="WOMEN">Women</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="collection">Collection: </label>
                        <select class="custom-select" id="collection" name="collection" required>
                            <option value="SPRING">Spring</option>
                            <option value="SUMMER">Summer</option>
                            <option value="AUTUMN">Autumn</option>
                            <option value="WINTER">Winter</option>
                        </select>
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
                    <!-- Size & Quantity -->
                    <div class="form-group">
                        <label>Size & Quantity</label>

                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Size</th>
                                    <th>Quantity</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach begin="36" end="44" var="s">
                                    <tr>
                                        <td>${s}</td>
                                        <td>
                                            <input type="number"
                                                   name="sizeQty_${s}"
                                                   class="form-control"
                                                   min="0"
                                                   value="0">
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
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
        let quantity = $('#quantityInput').val();

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
