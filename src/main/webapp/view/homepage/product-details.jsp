<%-- 
    Document   : product-details
    Created on : Feb 15, 2026, 2:57:26 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US" scope="page"/>
<!doctype html>
<html class="no-js" lang="en">

    <!-- Mirrored from htmldemo.net/koparion/koparion/product-details.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:50 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${product.name} | ShoeStore</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

        <!-- all css here -->
        <!-- bootstrap v3.3.6 css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <!-- animate css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animate.css">
        <!-- meanmenu css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meanmenu.min.css">
        <!-- owl.carousel css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.css">
        <!-- font-awesome css -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" integrity="sha512-+L4yy6FRcDGbXJ9mPG8MT/3UCDzwR9gPeyFNMCtInsol++5m3bk2bXWKdZjvybmohrAsn3Ua5x8gfLnbE1YkOg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <!-- flexslider.css-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flexslider.css">
        <!-- chosen.min.css-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chosen.min.css">
        <!-- style css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <!-- responsive css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
        <!-- modernizr css -->
        <script src="js/vendor/modernizr-2.8.3.min.js"></script>
    </head>
    <body class="product-details product-details-page">
        <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!-- Add your site or application content here -->
        <!-- header-area-start -->

        <jsp:include page="../common/homePage/header.jsp"></jsp:include>
            <!-- header-area-end -->
            <!-- product-main-area-start -->
            <div class="product-main-area mb-70 product-detail-shell">
                <div class="container-fluid product-detail-container">
                    <div class="row">
                        <div class="col-lg-9 col-md-12 col-12 order-lg-1 order-1">
                            <!-- product-main-area-start -->
                            <div class="product-main-area product-detail-card">
                                <div class="row">
                                    <div class="col-lg-5 col-md-6 col-12 product-gallery-column">
                                        <div class="product-gallery-main detail-gallery-frame mb-3 position-relative">
                                            <img id="mainProductImage" class="detail-gallery-image" src="${pageContext.request.contextPath}/${product.mainImage}" alt="${product.name}">
                                            <button type="button" id="galleryPrevBtn" class="btn btn-light border gallery-nav-btn gallery-nav-btn-prev" aria-label="Previous image">
                                                <i class="fa fa-angle-left"></i>
                                            </button>
                                            <button type="button" id="galleryNextBtn" class="btn btn-light border gallery-nav-btn gallery-nav-btn-next" aria-label="Next image">
                                                <i class="fa fa-angle-right"></i>
                                            </button>
                                        </div>
                                        <div class="mb-2 detail-gallery-counter-wrap">
                                            <small id="galleryCounter" class="text-muted"></small>
                                        </div>
                                        <div id="productThumbList" class="d-flex flex-wrap detail-thumb-list">
                                            <c:forEach items="${product.images}" var="img">
                                                <button type="button" class="btn p-0 mr-2 mb-2 border product-thumb-btn detail-thumb-btn" data-color="${img.color}" data-src="${pageContext.request.contextPath}/${img.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/${img.imageUrl}" alt="${product.name}" style="width:100%; height:100%; object-fit:cover;">
                                                </button>
                                            </c:forEach>
                                        </div>
                                    </div>
                                <div class="col-lg-7 col-md-6 col-12 product-summary-column">
                                    <div class="product-info-main product-summary-card">
                                        <div class="page-title">
                                            <h1>${product.name}</h1>
                                        </div>
                                        <div class="product-info-price">
                                            <div class="price-final">
                                                <c:choose>
                                                    <c:when test="${product.saleActive}">
                                                        <span><fmt:formatNumber value="${product.finalPrice}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;</span>
                                                        <span class="old-price"><fmt:formatNumber value="${product.price}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;</span>
                                                     </c:when>
                                                     <c:otherwise>
                                                        <span><fmt:formatNumber value="${product.price}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;</span>
                                                     </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <c:if test="${product.hot || product.saleActive}">
                                            <div class="product-flag mb-2">
                                                <ul>
                                                    <c:if test="${product.hot}">
                                                        <li><span class="sale"><i class="fa fa-bolt"></i> Hot</span></li>
                                                     </c:if>
                                                     <c:if test="${product.saleActive}">
                                                        <li><span class="discount-percentage"><i class="fa fa-tag"></i> Sale ${product.discountPercent}%</span></li>
                                                     </c:if>
                                                </ul>
                                            </div>
                                        </c:if>
                                        <div class="product-add-form">
                                            <form action="${pageContext.request.contextPath}/payment?action=add-product" method="POST" id="addToCartForm">

                                                <input type="hidden" name="productId" value="${product.id}">
                                                <input type="hidden" name="color" id="selectedColorInput">
                                                <input type="hidden" name="sizeId" id="selectedSizeIdInput">

                                                <!-- COLOR -->
                                                <div class="choose-color mb-3 detail-option-group">
                                                    <p>Color</p>
                                                    <div id="colorButtonGroup" class="d-flex flex-wrap">
                                                        <c:forEach items="${listColor}" var="colorName">
                                                            <button type="button" class="btn btn-outline-dark btn-sm mr-2 mb-2 color-option-btn" data-color="${colorName}">${colorName}</button>
                                                        </c:forEach>
                                                    </div>
                                                    <c:if test="${empty listColor}">
                                                        <small class="form-text text-danger">No color available.</small>
                                                    </c:if>
                                                </div>

                                                <!-- SIZE -->
                                                <div class="choose-size mb-3 detail-option-group">
                                                    <p>Size</p>
                                                    <select id="sizeSelect" class="form-control detail-select"></select>
                                                    <small id="stockHintText" class="form-text text-muted"></small>
                                                </div>


                                                <div class="detail-purchase-row">
                                                    <div class="quality-button detail-qty-wrap">
                                                        <input id="qtyInput" class="qty" type="number" value="" name="quantity" min="1" required>
                                                    </div>

                                                    <button type="submit" class="btn btn-dark detail-add-to-cart" id="addToCartButton">
                                                        Add to Cart
                                                    </button>
                                                </div>

                                                <div id="sizeStockData" class="d-none">
                                                    <c:forEach items="${listProductSize}" var="s">
                                                        <span class="size-stock-item" data-color="${s.color}" data-size="${s.size}" data-size-id="${s.id}" data-qty="${s.quantity}"></span>
                                                    </c:forEach>
                                                </div>

                                            </form>
                                            <div class="product-inline-description">
                                                <p class="detail-copy-kicker">Description</p>
                                                <div class="detail-copy-body">
                                                    ${product.description}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>	
                        </div>
                        <!-- product-main-area-end -->
                        <!-- product-info-area-start -->
                        <div class="product-info-area mt-80 detail-tab-section">
                            <!-- Nav tabs -->
                            <ul class="nav" id="product-tabs">
                                <!-- Tab mo ta san pham -->
                                <li><a class="active" href="#Details" data-bs-toggle="tab">Full Details</a></li>
                                <!-- Tab hoi dap moi -->
                                <li><a href="#Qna" data-bs-toggle="tab">Q&A</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane fade show active" id="Details">
                                    <div class="valu">
                                        ${product.description}
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="Qna">
                                    <div class="valu valu-2">
                                        <!-- Tieu de khu vuc hoi dap -->
                                        <div class="section-title mb-30 mt-30">
                                            <h2>Questions & Answers</h2>
                                        </div>

                                        <!-- Thong bao khi chua co cau hoi -->
                                        <c:if test="${empty qnaQuestions}">
                                            <p>Chưa có câu hỏi nào cho sản phẩm này.</p>
                                        </c:if>

                                        <!-- Lap danh sach cau hoi -->
                                        <c:forEach items="${qnaQuestions}" var="q">
                                            <div class="mb-3 qna-thread-card">
                                                <p>
                                                    <strong>
                                                        ${q.user.fullName}<c:if test="${q.user.role != null && q.user.role.id == 1}"> (Admin)</c:if>:
                                                    </strong>
                                                    ${q.content}
                                                </p>
                                                <p style="font-size:12px; color:#777;">
                                                    ${q.createdDateDisplay}
                                                </p>

                                                <!-- Lay danh sach cau tra loi cua cau hoi hien tai -->
                                                <c:set var="ansList" value="${answersByQuestion[q.id]}" />

                                                <!-- Thong bao khi cau hoi chua co cau tra loi -->
                                                <c:if test="${empty ansList}">
                                                    <p><em>Chưa có câu trả lời.</em></p>
                                                </c:if>

                                                <!-- Lap danh sach cau tra loi -->
                                                <c:forEach items="${ansList}" var="a">
                                                    <div class="qna-answer-card">
                                                        <p>
                                                            <strong>
                                                                ${a.user.fullName}<c:if test="${a.user.role != null && a.user.role.id == 1}"> (Admin)</c:if>:
                                                            </strong>
                                                            ${a.content}
                                                        </p>
                                                        <p style="font-size:12px; color:#777;">
                                                            ${a.createdDateDisplay}
                                                        </p>
                                                    </div>
                                                </c:forEach>

                                                <!-- Form tra loi (chi hien khi da dang nhap) -->
                                                <c:if test="${sessionScope.account != null}">
                                                    <form action="${pageContext.request.contextPath}/qna?action=answer" method="post" class="qna-reply-form">
                                                        <input type="hidden" name="productId" value="${product.id}">
                                                        <input type="hidden" name="questionId" value="${q.id}">
                                                        <textarea name="content" class="form-control" rows="2" placeholder="Viết câu trả lời..." required></textarea>
                                                        <button type="submit" class="btn btn-dark btn-sm mt-2">Trả lời</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </c:forEach>

                                        <hr class="qna-divider">

                                        <!-- Form dat cau hoi -->
                                        <c:choose>
                                            <c:when test="${sessionScope.account != null}">
                                                <h4>Đặt câu hỏi</h4>
                                                <form action="${pageContext.request.contextPath}/qna?action=ask" method="post" class="qna-ask-form">
                                                    <input type="hidden" name="productId" value="${product.id}">
                                                    <textarea name="content" class="form-control" rows="3" placeholder="Nhập câu hỏi..." required></textarea>
                                                    <button type="submit" class="btn btn-dark mt-2">Gửi câu hỏi</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <p>Vui lòng <a href="${pageContext.request.contextPath}/authen?action=login">đăng nhập</a> để đặt câu hỏi.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>	
                        </div>
                        <!-- product-info-area-end -->
                    </div>
                    <div class="col-lg-3 col-md-12 col-12 order-lg-2 order-2">
                        <div class="shop-left">
                            <div class="left-title mb-20">
                                <h4>Related Products</h4>
                            </div>
                            <div class="random-area mb-30">
                                <c:choose>
                                    <c:when test="${not empty relatedProducts}">
                                        <div class="product-active-2 owl-carousel">
                                            <c:forEach items="${relatedProducts}" var="relatedProduct" varStatus="status">
                                                <c:if test="${status.index % 3 == 0}">
                                                    <div class="product-total-2">
                                                </c:if>
                                                <div class="single-most-product bd mb-18">
                                                    <div class="most-product-img">
                                                        <a href="${pageContext.request.contextPath}/product-details?id=${relatedProduct.id}">
                                                            <img src="${pageContext.request.contextPath}/${relatedProduct.mainImage}" alt="${relatedProduct.name}" />
                                                        </a>
                                                    </div>
                                                    <div class="most-product-content">
                                                        <h4>
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${relatedProduct.id}">${relatedProduct.name}</a>
                                                        </h4>
                                                        <div class="product-price">
                                                            <ul>
                                                                <li>
                                                                    <fmt:formatNumber value="${relatedProduct.finalPrice}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;
                                                                </li>
                                                                <c:if test="${relatedProduct.saleActive}">
                                                                    <li class="old-price">
                                                                        <fmt:formatNumber value="${relatedProduct.price}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;
                                                                    </li>
                                                                </c:if>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <c:if test="${status.index % 3 == 2 || status.last}">
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p>No related products found.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- product-main-area-end -->
        <!-- footer-area-start -->
        <jsp:include page="../common/homePage/footer.jsp"></jsp:include>
            <!-- footer-area-end -->





        <!-- all js here -->
        <!-- jquery latest version -->
        <script src="${pageContext.request.contextPath}/js/vendor/jquery-1.12.4.min.js"></script>


        <!-- bootstrap js -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <!-- owl.carousel js -->
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <!-- meanmenu js -->
        <script src="${pageContext.request.contextPath}/js/jquery.meanmenu.js"></script>
        <!-- wow js -->
        <script src="${pageContext.request.contextPath}/js/wow.min.js"></script>
        <!-- jquery.parallax-1.1.3.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.parallax-1.1.3.js"></script>
        <!-- jquery.countdown.min.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.countdown.min.js"></script>
        <!-- jquery.flexslider.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.flexslider.js"></script>
        <!-- chosen.jquery.min.js -->
        <script src="${pageContext.request.contextPath}/js/chosen.jquery.min.js"></script>
        <!-- jquery.counterup.min.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.counterup.min.js"></script>
        <!-- waypoints.min.js -->
        <script src="${pageContext.request.contextPath}/js/waypoints.min.js"></script>
        <!-- plugins js -->
        <script src="${pageContext.request.contextPath}/js/plugins.js"></script>
        <!-- main js -->
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
        <script>
            (function () {
                if (window.location.hash === "#qna" || window.location.hash === "#Qna") {
                    var trigger = document.querySelector('a[href="#Qna"]');
                    if (trigger && window.bootstrap && bootstrap.Tab) {
                        bootstrap.Tab.getOrCreateInstance(trigger).show();
                    }
                }

                var addToCartForm = document.getElementById("addToCartForm");
                var mainImage = document.getElementById("mainProductImage");
                var galleryPrevBtn = document.getElementById("galleryPrevBtn");
                var galleryNextBtn = document.getElementById("galleryNextBtn");
                var galleryCounter = document.getElementById("galleryCounter");
                var qtyInput = document.getElementById("qtyInput");
                var addToCartButton = document.getElementById("addToCartButton");
                var selectedColorInput = document.getElementById("selectedColorInput");
                var selectedSizeIdInput = document.getElementById("selectedSizeIdInput");
                var stockHintText = document.getElementById("stockHintText");
                var sizeSelect = document.getElementById("sizeSelect");
                var colorButtons = document.querySelectorAll(".color-option-btn");
                var thumbButtons = document.querySelectorAll(".product-thumb-btn");
                var sizeStockItems = document.querySelectorAll("#sizeStockData .size-stock-item");
                var requestedColor = normalizeColor("${selectedColor}");

                var selectedColor = "";
                var stockByColor = {};
                var currentVisibleThumbs = [];
                var currentThumbIndex = -1;

                function normalizeColor(value) {
                    if (!value) {
                        return "";
                    }

                    return String(value).trim().toUpperCase();
                }

                for (var i = 0; i < sizeStockItems.length; i++) {
                    var stockItem = sizeStockItems[i];
                    var color = normalizeColor(stockItem.getAttribute("data-color"));
                    var size = parseInt(stockItem.getAttribute("data-size") || "0", 10);
                    var sizeId = parseInt(stockItem.getAttribute("data-size-id") || "0", 10);
                    var qty = parseInt(stockItem.getAttribute("data-qty") || "0", 10);

                    if (!color || isNaN(size) || size <= 0 || isNaN(sizeId) || sizeId <= 0 || isNaN(qty) || qty < 0) {
                        continue;
                    }

                    if (!stockByColor[color]) {
                        stockByColor[color] = {};
                    }

                    stockByColor[color][size] = {
                        sizeId: sizeId,
                        qty: qty
                    };
                }

                function setMainImage(src) {
                    if (mainImage && src) {
                        mainImage.src = src;
                    }
                }

                function refreshVisibleThumbs() {
                    currentVisibleThumbs = [];

                    for (var i = 0; i < thumbButtons.length; i++) {
                        if (thumbButtons[i].style.display !== "none") {
                            currentVisibleThumbs.push(thumbButtons[i]);
                        }
                    }
                }

                function findVisibleThumbIndex(targetThumb) {
                    for (var i = 0; i < currentVisibleThumbs.length; i++) {
                        if (currentVisibleThumbs[i] === targetThumb) {
                            return i;
                        }
                    }

                    return -1;
                }

                function updateGalleryControls() {
                    var totalVisible = currentVisibleThumbs.length;

                    if (galleryCounter) {
                        if (totalVisible === 0) {
                            galleryCounter.textContent = "No image available";
                        } else {
                            galleryCounter.textContent = "Image " + (currentThumbIndex + 1) + " / " + totalVisible;
                        }
                    }

                    var disableNavigation = totalVisible <= 1;
                    if (galleryPrevBtn) {
                        galleryPrevBtn.disabled = disableNavigation;
                    }
                    if (galleryNextBtn) {
                        galleryNextBtn.disabled = disableNavigation;
                    }
                }

                function setActiveThumb(activeButton) {
                    for (var i = 0; i < thumbButtons.length; i++) {
                        thumbButtons[i].classList.remove("border-dark");
                    }

                    if (activeButton) {
                        activeButton.classList.add("border-dark");
                        setMainImage(activeButton.getAttribute("data-src"));
                    }

                    refreshVisibleThumbs();
                    currentThumbIndex = findVisibleThumbIndex(activeButton);
                    if (currentThumbIndex < 0 && currentVisibleThumbs.length > 0) {
                        currentThumbIndex = 0;
                    }

                    updateGalleryControls();
                }

                function navigateGallery(step) {
                    refreshVisibleThumbs();
                    if (currentVisibleThumbs.length <= 1) {
                        updateGalleryControls();
                        return;
                    }

                    if (currentThumbIndex < 0) {
                        currentThumbIndex = 0;
                    }

                    var nextIndex = currentThumbIndex + step;
                    if (nextIndex < 0) {
                        nextIndex = currentVisibleThumbs.length - 1;
                    }

                    if (nextIndex >= currentVisibleThumbs.length) {
                        nextIndex = 0;
                    }

                    setActiveThumb(currentVisibleThumbs[nextIndex]);
                }

                function filterImagesByColor(color) {
                    var firstMatchedThumb = null;
                    var matchedCount = 0;

                    for (var i = 0; i < thumbButtons.length; i++) {
                        var thumbButton = thumbButtons[i];
                        var thumbColor = normalizeColor(thumbButton.getAttribute("data-color"));
                        var matched = !color || !thumbColor || thumbColor === color;

                        thumbButton.style.display = matched ? "" : "none";

                        if (matched && !firstMatchedThumb) {
                            firstMatchedThumb = thumbButton;
                        }

                        if (matched) {
                            matchedCount++;
                        }
                    }

                    if (matchedCount === 0) {
                        for (var j = 0; j < thumbButtons.length; j++) {
                            thumbButtons[j].style.display = "";
                        }

                        if (thumbButtons.length > 0) {
                            firstMatchedThumb = thumbButtons[0];
                        }
                    }

                    if (!firstMatchedThumb && thumbButtons.length > 0) {
                        firstMatchedThumb = thumbButtons[0];
                    }

                    if (firstMatchedThumb) {
                        setActiveThumb(firstMatchedThumb);
                    } else {
                        refreshVisibleThumbs();
                        currentThumbIndex = -1;
                        updateGalleryControls();
                    }
                }

                function setActiveColorButton(color) {
                    for (var i = 0; i < colorButtons.length; i++) {
                        var button = colorButtons[i];
                        var buttonColor = normalizeColor(button.getAttribute("data-color"));

                        if (buttonColor === color) {
                            button.classList.remove("btn-outline-dark");
                            button.classList.add("btn-dark", "active");
                        } else {
                            button.classList.remove("btn-dark", "active");
                            button.classList.add("btn-outline-dark");
                        }
                    }
                }

                function clampQuantityByMax() {
                    if (!qtyInput) {
                        return;
                    }

                    if (qtyInput.disabled) {
                        return;
                    }

                    var maxQty = parseInt(qtyInput.getAttribute("max") || "1", 10);
                    if (isNaN(maxQty) || maxQty < 1) {
                        maxQty = 1;
                    }

                    var currentQty = parseInt(qtyInput.value || "1", 10);
                    if (isNaN(currentQty) || currentQty < 1) {
                        qtyInput.value = "1";
                    } else if (currentQty > maxQty) {
                        qtyInput.value = String(maxQty);
                    }
                }

                function setSizeSelection(option) {
                    if (!option || option.disabled) {
                        if (qtyInput) {
                            qtyInput.value = "";
                            qtyInput.setAttribute("min", "0");
                            qtyInput.setAttribute("max", "0");
                            qtyInput.disabled = true;
                        }

                        if (selectedSizeIdInput) {
                            selectedSizeIdInput.value = "";
                        }

                        if (addToCartButton) {
                            addToCartButton.disabled = true;
                        }

                        if (stockHintText) {
                            stockHintText.textContent = "Size đã chọn đang hết hàng.";
                        }

                        return;
                    }

                    var availableQty = parseInt(option.getAttribute("data-qty") || "0", 10);
                    if (isNaN(availableQty) || availableQty < 1) {
                        availableQty = 1;
                    }

                    if (selectedSizeIdInput) {
                        selectedSizeIdInput.value = option.getAttribute("data-size-id") || option.value || "";
                    }

                    if (qtyInput) {
                        qtyInput.disabled = false;
                        qtyInput.setAttribute("min", "1");
                        qtyInput.setAttribute("max", String(availableQty));
                        if (!qtyInput.value || parseInt(qtyInput.value, 10) < 1) {
                            qtyInput.value = "1";
                        }
                        clampQuantityByMax();
                    }

                    if (addToCartButton) {
                        addToCartButton.disabled = false;
                    }

                    if (stockHintText) {
                        stockHintText.textContent = "Size " + option.getAttribute("data-size") + " còn " + availableQty + " sản phẩm.";
                    }
                }

                function renderSizesByColor(color) {
                    if (!sizeSelect) {
                        return;
                    }

                    sizeSelect.innerHTML = "";

                    var stockMap = stockByColor[color] || {};
                    var firstAvailableOption = null;

                    for (var size = 35; size <= 45; size++) {
                        var stock = stockMap[size];
                        var option = document.createElement("option");
                        option.setAttribute("data-size", String(size));

                        if (stock && stock.sizeId > 0 && stock.qty > 0) {
                            option.value = String(stock.sizeId);
                            option.setAttribute("data-size-id", String(stock.sizeId));
                            option.setAttribute("data-qty", String(stock.qty));
                            option.textContent = "Size " + size + " (Còn " + stock.qty + ")";
                            if (!firstAvailableOption) {
                                firstAvailableOption = option;
                            }
                        } else {
                            option.value = "";
                            option.disabled = true;
                            option.setAttribute("data-size-id", "");
                            option.setAttribute("data-qty", "0");
                            option.textContent = "Size " + size + " (Hết hàng)";
                        }

                        sizeSelect.appendChild(option);
                    }

                    if (firstAvailableOption) {
                        firstAvailableOption.selected = true;
                        setSizeSelection(firstAvailableOption);
                    } else {
                        if (sizeSelect.options.length > 0) {
                            sizeSelect.selectedIndex = 0;
                        }
                        setSizeSelection(null);
                    }
                }

                function selectColor(color) {
                    selectedColor = normalizeColor(color);

                    if (selectedColorInput) {
                        selectedColorInput.value = selectedColor;
                    }

                    setActiveColorButton(selectedColor);
                    filterImagesByColor(selectedColor);
                    renderSizesByColor(selectedColor);
                }

                for (var i = 0; i < colorButtons.length; i++) {
                    colorButtons[i].addEventListener("click", function () {
                        selectColor(this.getAttribute("data-color"));
                    });
                }

                for (var j = 0; j < thumbButtons.length; j++) {
                    thumbButtons[j].addEventListener("click", function () {
                        if (this.style.display === "none") {
                            return;
                        }

                        setActiveThumb(this);
                    });
                }

                if (galleryPrevBtn) {
                    galleryPrevBtn.addEventListener("click", function () {
                        navigateGallery(-1);
                    });
                }

                if (galleryNextBtn) {
                    galleryNextBtn.addEventListener("click", function () {
                        navigateGallery(1);
                    });
                }

                if (sizeSelect) {
                    sizeSelect.addEventListener("change", function () {
                        var option = sizeSelect.options[sizeSelect.selectedIndex];
                        setSizeSelection(option || null);
                    });
                }

                if (qtyInput) {
                    qtyInput.addEventListener("input", clampQuantityByMax);
                }

                if (colorButtons.length > 0) {
                    var initialColor = colorButtons[0].getAttribute("data-color");

                    if (requestedColor) {
                        for (var k = 0; k < colorButtons.length; k++) {
                            if (normalizeColor(colorButtons[k].getAttribute("data-color")) === requestedColor) {
                                initialColor = colorButtons[k].getAttribute("data-color");
                                break;
                            }
                        }
                    }

                    selectColor(initialColor);
                } else {
                    filterImagesByColor("");

                    if (qtyInput) {
                        qtyInput.disabled = true;
                        qtyInput.value = "";
                        qtyInput.setAttribute("min", "0");
                        qtyInput.setAttribute("max", "0");
                    }

                    if (addToCartButton) {
                        addToCartButton.disabled = true;
                    }

                    if (stockHintText) {
                        stockHintText.textContent = "Sản phẩm chưa có màu hoặc size khả dụng.";
                    }
                }

                if (addToCartForm) {
                    addToCartForm.addEventListener("submit", function (event) {
                        if (!selectedColorInput || !selectedColorInput.value) {
                            event.preventDefault();
                            alert("Please choose a color.");
                            return;
                        }

                        if (!selectedSizeIdInput || !selectedSizeIdInput.value) {
                            event.preventDefault();
                            alert("Please choose an available size.");
                            return;
                        }

                        var maxQty = parseInt(qtyInput.getAttribute("max") || "1", 10);
                        var enteredQty = parseInt(qtyInput.value || "1", 10);

                        if (isNaN(enteredQty) || enteredQty < 1) {
                            event.preventDefault();
                            qtyInput.value = "1";
                            alert("Quantity must be at least 1.");
                            return;
                        }

                        if (enteredQty > maxQty) {
                            event.preventDefault();
                            qtyInput.value = String(maxQty);
                            alert("Quantity exceeds stock. Maximum available quantity is " + maxQty + ".");
                        }
                    });
                }
            })();
        </script>
    </body>

    <!-- Mirrored from htmldemo.net/koparion/koparion/product-details.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:51 GMT -->
</html>
