<%-- 
    Document   : home
    Created on : Feb 8, 2026, 9:17:07 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">


    <!-- Mirrored from htmldemo.net/koparion/koparion/shop.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:51 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>ShoeStore</title>
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
        <script src="${pageContext.request.contextPath}/js/vendor/modernizr-2.8.3.min.js"></script>
    </head>

    <body class="shop">
        <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!-- Add your site or application content here -->

        <!-- header-area-start -->
        <jsp:include page="../common/homePage/header.jsp"></jsp:include>
            <!-- header-area-end -->

            <section class="hero-video-section">
                <video class="hero-video-bg" autoplay muted loop playsinline preload="metadata">
                <source src="${pageContext.request.contextPath}/video/26102006.mov" type="video/mp4">
            </video>
            <div class="hero-video-overlay"></div>
            <div class="hero-video-content">
                <p class="hero-store-name">ShoeStore</p>
                <a href="#products-section">Explore products</a>
            </div>
        </section>

        <!-- shop-main-area-start -->
        <div class="shop-main-area home-product-section mb-70" id="products-section">
            <div class="container-fluid">
                <div class="shop-content-full">
                    <c:url var="productModeUrl" value="home">
                        <c:param name="viewMode" value="product"/>
                        <c:if test="${not empty param.search}">
                            <c:param name="search" value="${param.search}"/>
                        </c:if>
                        <c:if test="${not empty param.categoryId}">
                            <c:param name="categoryId" value="${param.categoryId}"/>
                        </c:if>
                        <c:if test="${not empty param.keyword}">
                            <c:param name="keyword" value="${param.keyword}"/>
                        </c:if>
                        <c:if test="${not empty param.gender}">
                            <c:param name="gender" value="${param.gender}"/>
                        </c:if>
                        <c:if test="${not empty param.collection}">
                            <c:param name="collection" value="${param.collection}"/>
                        </c:if>
                        <c:if test="${not empty param.min}">
                            <c:param name="min" value="${param.min}"/>
                        </c:if>
                        <c:if test="${not empty param.max}">
                            <c:param name="max" value="${param.max}"/>
                        </c:if>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="variantModeUrl" value="home">
                        <c:param name="viewMode" value="variant"/>
                        <c:if test="${not empty param.search}">
                            <c:param name="search" value="${param.search}"/>
                        </c:if>
                        <c:if test="${not empty param.categoryId}">
                            <c:param name="categoryId" value="${param.categoryId}"/>
                        </c:if>
                        <c:if test="${not empty param.keyword}">
                            <c:param name="keyword" value="${param.keyword}"/>
                        </c:if>
                        <c:if test="${not empty param.gender}">
                            <c:param name="gender" value="${param.gender}"/>
                        </c:if>
                        <c:if test="${not empty param.collection}">
                            <c:param name="collection" value="${param.collection}"/>
                        </c:if>
                        <c:if test="${not empty param.min}">
                            <c:param name="min" value="${param.min}"/>
                        </c:if>
                        <c:if test="${not empty param.max}">
                            <c:param name="max" value="${param.max}"/>
                        </c:if>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="allPriceUrl" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="priceRange1Url" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:param name="search" value="price"/>
                        <c:param name="min" value="0"/>
                        <c:param name="max" value="9.99"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="priceRange2Url" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:param name="search" value="price"/>
                        <c:param name="min" value="30"/>
                        <c:param name="max" value="39.99"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="priceRange3Url" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:param name="search" value="price"/>
                        <c:param name="min" value="40"/>
                        <c:param name="max" value="49.99"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="priceRange4Url" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:param name="search" value="price"/>
                        <c:param name="min" value="50"/>
                        <c:param name="max" value="59.99"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <c:url var="priceRange5Url" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:param name="search" value="price"/>
                        <c:param name="min" value="70"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <div class="products-header mb-30">
                        <div class="products-header-left">
                            <div class="section-title-5">
                                <h2>${viewMode == 'variant' ? 'Product Variants' : 'Products'}</h2>
                            </div>
                            <div class="view-mode-switch">
                                <a href="${productModeUrl}#products-section" class="${viewMode == 'variant' ? '' : 'active'}">Product</a>
                                <a href="${variantModeUrl}#products-section" class="${viewMode == 'variant' ? 'active' : ''}">Variant</a>
                            </div>
                        </div>
                        <div class="toolbar">
                            <div class="toolbar-actions">
                                <div class="toolbar-price-filter">
                                    <span>Price</span>
                                    <select class="price-filter-options" onchange="if (this.value) {
                                                window.location.href = this.value;
                                            }">
                                        <option value="${allPriceUrl}#products-section" ${param.search != 'price' ? 'selected="selected"' : ''}>All Prices</option>
                                        <option value="${priceRange1Url}#products-section" ${param.search == 'price' and param.min == '0' and param.max == '9.99' ? 'selected="selected"' : ''}>0.00 &#273; - 9.99 &#273;</option>
                                        <option value="${priceRange2Url}#products-section" ${param.search == 'price' and param.min == '30' and param.max == '39.99' ? 'selected="selected"' : ''}>30.00 &#273; - 39.99 &#273;</option>
                                        <option value="${priceRange3Url}#products-section" ${param.search == 'price' and param.min == '40' and param.max == '49.99' ? 'selected="selected"' : ''}>40.00 &#273; - 49.99 &#273;</option>
                                        <option value="${priceRange4Url}#products-section" ${param.search == 'price' and param.min == '50' and param.max == '59.99' ? 'selected="selected"' : ''}>50.00 &#273; - 59.99 &#273;</option>
                                        <option value="${priceRange5Url}#products-section" ${param.search == 'price' and param.min == '70' and empty param.max ? 'selected="selected"' : ''}>70.00 &#273; and above</option>
                                    </select>
                                </div>
                                <div class="toolbar-sorter">
                                    <span>Sort By</span>
                                    <form action="home#products-section" method="get" class="d-inline">
                                        <input type="hidden" name="viewMode" value="${viewMode}"/>
                                        <c:if test="${not empty param.search}">
                                            <input type="hidden" name="search" value="${param.search}"/>
                                        </c:if>
                                        <c:if test="${not empty param.categoryId}">
                                            <input type="hidden" name="categoryId" value="${param.categoryId}"/>
                                        </c:if>
                                        <c:if test="${not empty param.keyword}">
                                            <input type="hidden" name="keyword" value="${param.keyword}"/>
                                        </c:if>
                                        <c:if test="${not empty param.gender}">
                                            <input type="hidden" name="gender" value="${param.gender}"/>
                                        </c:if>
                                        <c:if test="${not empty param.collection}">
                                            <input type="hidden" name="collection" value="${param.collection}"/>
                                        </c:if>
                                        <c:if test="${not empty param.min}">
                                            <input type="hidden" name="min" value="${param.min}"/>
                                        </c:if>
                                        <c:if test="${not empty param.max}">
                                            <input type="hidden" name="max" value="${param.max}"/>
                                        </c:if>

                                        <select id="sorter" name="sort" class="sorter-options" data-role="sorter" onchange="this.form.submit()">
                                            <option value="" ${empty param.sort ? 'selected="selected"' : ''}>Position</option>
                                            <option value="nameAsc" ${param.sort == 'nameAsc' ? 'selected="selected"' : ''}>Product Name A-Z</option>
                                            <option value="nameDesc" ${param.sort == 'nameDesc' ? 'selected="selected"' : ''}>Product Name Z-A</option>
                                            <option value="priceAsc" ${param.sort == 'priceAsc' ? 'selected="selected"' : ''}>Price Low To High</option>
                                            <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected="selected"' : ''}>Price High To Low</option>
                                        </select>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab-area-start -->
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="th">
                            <div class="row products-grid">
                                <c:choose>
                                    <c:when test="${viewMode == 'variant'}">
                                        <c:forEach items="${listVariantItems}" var="item">
                                            <c:url var="variantDetailUrl" value="product-details">
                                                <c:param name="id" value="${item.product.id}"/>
                                                <c:if test="${not empty item.color}">
                                                    <c:param name="color" value="${item.color}"/>
                                                </c:if>
                                            </c:url>
                                            <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6 product-card-col">
                                                <div class="product-card">
                                                    <div class="product-img">
                                                        <a href="${variantDetailUrl}">
                                                            <img src="${pageContext.request.contextPath}/${item.imageUrl}" loading="lazy" decoding="async" alt="${item.displayName}" />
                                                        </a>
                                                        <c:if test="${item.product.hot || item.product.saleActive}">
                                                            <div class="product-flag">
                                                                <ul>
                                                                    <c:if test="${item.product.hot}">
                                                                        <li><span class="sale"><i class="fa fa-bolt"></i> Hot</span></li>
                                                                        </c:if>
                                                                        <c:if test="${item.product.saleActive}">
                                                                        <li><span class="discount-percentage"><i class="fa fa-tag"></i> Sale ${item.product.discountPercent}%</span></li>
                                                                        </c:if>
                                                                </ul>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="product-details text-center">
                                                        <h4><a href="${variantDetailUrl}">${item.displayName}</a></h4>
                                                        <div class="product-price">
                                                            <ul>
                                                                <a href="${variantDetailUrl}">
                                                                    <li>${item.product.finalPrice} &#273;</li>
                                                                        <c:if test="${item.product.saleActive}">
                                                                        <li class="old-price">${item.product.price} &#273;</li>
                                                                        </c:if>
                                                                </a>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${listProduct}" var="p">
                                            <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6 product-card-col">
                                                <div class="product-card">
                                                    <div class="product-img">
                                                        <a href="product-details?id=${p.id}">
                                                            <img src="${pageContext.request.contextPath}/${p.mainImage}" loading="lazy" decoding="async" alt="${p.name}" />
                                                        </a>
                                                        <c:if test="${p.hot || p.saleActive}">
                                                            <div class="product-flag">
                                                                <ul>
                                                                    <c:if test="${p.hot}">
                                                                        <li><span class="sale"><i class="fa fa-bolt"></i> Hot</span></li>
                                                                        </c:if>
                                                                        <c:if test="${p.saleActive}">
                                                                        <li><span class="discount-percentage"><i class="fa fa-tag"></i> Sale ${p.discountPercent}%</span></li>
                                                                        </c:if>
                                                                </ul>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="product-details text-center">
                                                        <h4><a href="product-details?id=${p.id}">${p.name}</a></h4>
                                                            <c:if test="${not empty p.availableColors}">
                                                            <div class="product-color-list">
                                                                <c:forEach items="${p.availableColors}" var="colorName">
                                                                    <span class="product-color-chip">${colorName}</span>
                                                                </c:forEach>
                                                            </div>
                                                        </c:if>
                                                        <div class="product-price">
                                                            <ul>
                                                                <a href="product-details?id=${p.id}">
                                                                    <li>${p.finalPrice} &#273;</li>
                                                                        <c:if test="${p.saleActive}">
                                                                        <li class="old-price">${p.price} &#273;</li>
                                                                        </c:if>
                                                                </a>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <!-- tab-area-end -->
                    <!-- pagination-area-start -->
                    <div class="pagination-area mt-50">
                        <div class="page-number">
                            <ul>
                                <c:set var="currentPage" value="${pageControl.page lt 1 ? 1 : pageControl.page}"/>
                                <c:set var="totalPage" value="${pageControl.totalPage lt 1 ? 1 : pageControl.totalPage}"/>
                                <c:set var="startPage" value="${currentPage - 2}"/>
                                <c:if test="${startPage lt 1}">
                                    <c:set var="startPage" value="1"/>
                                </c:if>

                                <c:set var="endPage" value="${startPage + 4}"/>
                                <c:if test="${endPage gt totalPage}">
                                    <c:set var="endPage" value="${totalPage}"/>
                                </c:if>

                                <c:if test="${endPage - startPage lt 4}">
                                    <c:set var="startPage" value="${endPage - 4}"/>
                                </c:if>
                                <c:if test="${startPage lt 1}">
                                    <c:set var="startPage" value="1"/>
                                </c:if>

                                <c:if test="${currentPage gt 1}">
                                    <li>
                                        <a href="${pageControl.urlPattern}page=${currentPage - 1}#products-section" class="angle">
                                            <i class="fa fa-angle-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="pageNumber">
                                    <li>
                                        <a href="${pageControl.urlPattern}page=${pageNumber}#products-section" class="${pageNumber == currentPage ? 'active' : ''}">${pageNumber}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage lt totalPage}">
                                    <li>
                                        <a href="${pageControl.urlPattern}page=${currentPage + 1}#products-section" class="angle">
                                            <i class="fa fa-angle-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                    <!-- pagination-area-end -->
                </div>
            </div>
        </div>
        <!-- shop-main-area-end -->
        <!-- footer-area-start -->
        <jsp:include page="../common/homePage/footer.jsp"></jsp:include>
            <!-- footer-area-end -->
            <!-- Modal -->
            <!-- Modal end -->






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
    </body>


    <!-- Mirrored from htmldemo.net/koparion/koparion/shop.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:52 GMT -->
</html>
