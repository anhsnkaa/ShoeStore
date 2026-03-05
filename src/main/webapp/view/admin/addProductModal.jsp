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
                        <label for="addGender">Gender: </label>
                        <select class="custom-select" id="addGender" onchange="filterCategoryByGender('addGender', 'category')"></select>
                    </div>
                    <div class="form-group">
                        <label for="category">Category: </label>
                        <div class="input-group">
                            <select class="custom-select" id="category" name="category">
                                <c:forEach items="${listCategory}" var="c">
                                    <option value="${c.id}" data-gender="${c.gender.name}">${c.name}</option>
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
                    <!--Description-->
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea class="form-control" name="description"></textarea>
                    </div>
                    <!-- Color / Size / Quantity -->
                    <div class="form-group">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label class="mb-0">Color / Size (35-45) / Quantity</label>
                        </div>
                        <div class="form-row align-items-end mb-2">
                            <div class="col-md-8">
                                <input type="text" id="addVariantColorInput" class="form-control" placeholder="Enter color (EX: BLACK, WHITE)">
                            </div>
                            <div class="col-md-4 mt-2 mt-md-0">
                                <button type="button" class="btn btn-sm btn-outline-primary btn-block" onclick="addColorWithDefaultSizes('addVariantTable', 'addVariantColorInput')">Add color (35-45)</button>
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
                            <tbody id="addVariantTable"></tbody>
                        </table>
                    </div>

                    <!-- Images by color -->
                    <div class="form-group">
                        <div class="mb-2">
                            <label class="mb-0">Images by Color</label>
                        </div>
                        <small class="form-text text-muted mb-2">Add variants first, then upload images for each color. Upload at least 1 image per color.</small>
                        <div id="addImageByColorContainer"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary" form="addProductForm" onclick="validateForm(event)">Add</button>
            </div>
        </div>
    </div>
</div>

<script>
    function validateForm(event) {
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

        let variantValidation = validateVariantRows('addVariantTable');
        if (!variantValidation.valid) {
            event.preventDefault();
            alert(variantValidation.message);
            return;
        }

        let syncValidation = validateColorSectionSync('addImageByColorContainer', variantValidation.colors);
        if (!syncValidation.valid) {
            event.preventDefault();
            alert(syncValidation.message);
            return;
        }

        let imageValidation = validateColorImageSelection('addImageByColorContainer', variantValidation.colors, true);
        if (!imageValidation.valid) {
            event.preventDefault();
            alert(imageValidation.message);
            return;
        }

        // Kiểm tra nếu không có lỗi thì submit form
        let error = '';
        $('.error').each(function () {
            error += $(this).html();
        });
        if (error !== '') {
            event.preventDefault();
        }
    }

    function addVariantRow(tableId, colorValue, sizeValue, qtyValue, readOnlyColor) {
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

        let targetImageContainer = tableId === "addVariantTable"
                ? "addImageByColorContainer"
                : "editImageByColorContainer";

        let colorReadonlyAttr = readOnlyColor ? "readonly" : "";
        let parsedQty = parseInt(qtyValue, 10);
        if (isNaN(parsedQty) || parsedQty < 0) {
            parsedQty = 0;
        }

        let tr = document.createElement("tr");
        tr.innerHTML = ""
                + "<td><input type='text' name='variantColor' class='form-control' value='" + safeColor + "' oninput='this.value = this.value.toUpperCase()' onchange='syncColorImageSections(\"" + tableId + "\", \"" + targetImageContainer + "\")' placeholder='EX: BLACK, INFERNO' " + colorReadonlyAttr + " required></td>"
                + "<td><input type='number' name='variantSize' class='form-control' min='1' value='" + (sizeValue || 36) + "' required></td>"
                + "<td><input type='number' name='variantQty' class='form-control' min='0' value='" + parsedQty + "' required></td>"
                + "<td><button type='button' class='btn btn-sm btn-outline-danger' onclick='removeVariantRow(this)'>Remove</button></td>";

        tbody.appendChild(tr);

        if (tableId === 'addVariantTable') {
            syncColorImageSections('addVariantTable', 'addImageByColorContainer');
        } else if (tableId === 'editSizeTable') {
            syncColorImageSections('editSizeTable', 'editImageByColorContainer');
        }
    }

    function removeVariantRow(button) {
        let row = button.closest("tr");
        if (!row) {
            return;
        }

        let tbody = row.parentElement;
        row.remove();

        if (tbody && tbody.id === 'addVariantTable') {
            syncColorImageSections('addVariantTable', 'addImageByColorContainer');
        }

        if (tbody && tbody.id === 'editSizeTable') {
            syncColorImageSections('editSizeTable', 'editImageByColorContainer');
        }
    }

    function addColorWithDefaultSizes(tableId, colorInputId) {
        let colorInput = document.getElementById(colorInputId);
        let color = normalizeColorValue(colorInput ? colorInput.value : "");

        if (!color) {
            alert("Please enter a color name before adding sizes.");
            return;
        }

        let existingColors = collectVariantColors(tableId);
        if (existingColors.indexOf(color) !== -1) {
            alert("Color " + color + " already exists.");
            return;
        }

        for (let size = 35; size <= 45; size++) {
            addVariantRow(tableId, color, size, 0, true);
        }

        if (colorInput) {
            colorInput.value = "";
        }

        if (tableId === 'addVariantTable') {
            syncColorImageSections('addVariantTable', 'addImageByColorContainer');
        }
    }

    (function initVariantRows() {
        syncColorImageSections('addVariantTable', 'addImageByColorContainer');
    })();

    (function initAddGenderCategory() {
        if (typeof initGenderCategoryFilter === "function") {
            initGenderCategoryFilter('addGender', 'category');
        }
    })();

    function normalizeColorValue(rawColor) {
        if (!rawColor) {
            return "";
        }

        return String(rawColor).trim().toUpperCase();
    }

    function collectVariantColors(tableId) {
        let tbody = document.getElementById(tableId);
        if (!tbody) {
            return [];
        }

        let colors = [];
        let seen = {};
        let colorInputs = tbody.querySelectorAll("input[name='variantColor']");

        for (let i = 0; i < colorInputs.length; i++) {
            let color = normalizeColorValue(colorInputs[i].value);
            colorInputs[i].value = color;
            if (!color || seen[color]) {
                continue;
            }
            seen[color] = true;
            colors.push(color);
        }

        return colors;
    }

    function createColorImageSection(index, color) {
        let section = document.createElement("div");
        section.className = "border rounded p-2 mb-2";
        section.innerHTML = ""
                + "<div class='font-weight-bold mb-1'>" + color + "</div>"
                + "<input type='hidden' name='imageColorKey' value='" + index + "'>"
                + "<input type='hidden' name='imageColorValue' value='" + color + "'>"
                + "<input type='file' class='form-control-file' name='imagesByColor_" + index + "' multiple accept='image/*'>";

        return section;
    }

    function syncColorImageSections(tableId, containerId) {
        let container = document.getElementById(containerId);
        if (!container) {
            return;
        }

        let colors = collectVariantColors(tableId);
        container.innerHTML = "";

        if (colors.length === 0) {
            container.innerHTML = "<div class='text-muted small'>No colors yet. Add variants first.</div>";
            return;
        }

        for (let i = 0; i < colors.length; i++) {
            container.appendChild(createColorImageSection(i + 1, colors[i]));
        }
    }

    function validateVariantRows(tableId) {
        let tbody = document.getElementById(tableId);
        if (!tbody) {
            return {valid: false, message: "Variant table not found.", colors: []};
        }

        let rows = tbody.querySelectorAll("tr");
        let keys = {};
        let colors = [];
        let colorSet = {};

        for (let i = 0; i < rows.length; i++) {
            let colorInput = rows[i].querySelector("input[name='variantColor']");
            let sizeInput = rows[i].querySelector("input[name='variantSize']");
            let qtyInput = rows[i].querySelector("input[name='variantQty']");

            let color = normalizeColorValue(colorInput ? colorInput.value : "");
            let size = parseInt(sizeInput ? sizeInput.value : "", 10);
            let qtyRaw = qtyInput ? String(qtyInput.value || "").trim() : "";
            let qty = qtyRaw === "" ? 0 : parseInt(qtyRaw, 10);

            if (colorInput) {
                colorInput.value = color;
            }

            if (!color || isNaN(size) || size <= 0 || isNaN(qty) || qty < 0) {
                continue;
            }

            if (qtyInput && qtyRaw === "") {
                qtyInput.value = "0";
            }

            if (!colorSet[color]) {
                colorSet[color] = true;
                colors.push(color);
            }

            let key = color + "#" + size;
            if (keys[key]) {
                return {
                    valid: false,
                    message: "Duplicate variant found: " + color + " - size " + size + ".",
                    colors: colors
                };
            }

            keys[key] = true;
        }

        if (Object.keys(keys).length === 0) {
            return {valid: false, message: "Please add at least one valid variant.", colors: colors};
        }

        return {valid: true, message: "", colors: colors};
    }

    function validateColorSectionSync(containerId, colors) {
        let container = document.getElementById(containerId);
        if (!container) {
            return {valid: false, message: "Image container not found."};
        }

        let hiddenColorInputs = container.querySelectorAll("input[name='imageColorValue']");
        let mappedColors = [];
        let seen = {};

        for (let i = 0; i < hiddenColorInputs.length; i++) {
            let color = normalizeColorValue(hiddenColorInputs[i].value);
            if (!color || seen[color]) {
                continue;
            }
            seen[color] = true;
            mappedColors.push(color);
        }

        if (mappedColors.length !== colors.length) {
            return {
                valid: false,
                message: "Variant colors changed. Please update variant rows again before submitting."
            };
        }

        for (let j = 0; j < colors.length; j++) {
            if (mappedColors.indexOf(colors[j]) === -1) {
                return {
                    valid: false,
                    message: "Variant colors changed. Please update variant rows again before submitting."
                };
            }
        }

        return {valid: true, message: ""};
    }

    function validateColorImageSelection(containerId, colors, requireAll) {
        let container = document.getElementById(containerId);
        if (!container) {
            return {valid: false, message: "Image container not found."};
        }

        let fileInputs = container.querySelectorAll("input[type='file'][name^='imagesByColor_']");
        if (fileInputs.length === 0) {
            return {
                valid: !requireAll,
                message: requireAll ? "Please upload image(s) by color." : ""
            };
        }

        if (!requireAll) {
            return {valid: true, message: ""};
        }

        for (let i = 0; i < fileInputs.length; i++) {
            let fileInput = fileInputs[i];
            if (!fileInput.files || fileInput.files.length === 0) {
                let wrapper = fileInput.closest(".border");
                let colorTitle = wrapper ? wrapper.querySelector(".font-weight-bold") : null;
                let colorName = colorTitle ? colorTitle.textContent : "";
                return {
                    valid: false,
                    message: "Please upload image(s) for color " + colorName + "."
                };
            }
        }

        return {valid: true, message: ""};
    }

    function renderExistingImagesByColor(images, containerId) {
        let container = document.getElementById(containerId);
        if (!container) {
            return;
        }

        container.innerHTML = "";
        if (!images || images.length === 0) {
            container.innerHTML = "<div class='text-muted small'>No existing images.</div>";
            return;
        }

        let grouped = {};
        for (let i = 0; i < images.length; i++) {
            let color = normalizeColorValue(images[i].color) || "UNKNOWN";
            if (!grouped[color]) {
                grouped[color] = [];
            }
            grouped[color].push(images[i]);
        }

        Object.keys(grouped).sort().forEach(function (color) {
            let block = document.createElement("div");
            block.className = "mb-2";
            block.innerHTML = "<div class='font-weight-bold small mb-1'>Current " + color + " images</div>";

            let row = document.createElement("div");
            row.className = "row";

            grouped[color].forEach(function (img) {
                let col = document.createElement("div");
                col.className = "col-md-3 mb-2";
                col.innerHTML = "<img class='img-fluid img-thumbnail' src='${pageContext.request.contextPath}/" + img.imageUrl + "'>";
                row.appendChild(col);
            });

            block.appendChild(row);
            container.appendChild(block);
        });
    }


</script>
