<%-- 
    Document   : header
    Created on : Feb 10, 2026, 10:34:54 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- header-area-start -->
<header>
    <!-- main-menu-area-start -->
    <div class="main-menu-area d-md-none d-none d-lg-block sticky-header-1" id="header-sticky">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="menu-area">
                        <nav>
                            <ul>
                                <li class="active"><a href="index.html">Home<i class="fa fa-angle-down"></i></a>
                                    <div class="sub-menu">
                                        <ul>
                                            <li><a href="home?search=gender&gender=MEN">Men</a></li>
                                            <li><a href="home?search=gender&gender=WOMEN">Women</a></li>    
                                                <c:url var="saleProductsUrl" value="home">
                                                    <c:param name="viewMode" value="${viewMode}"/>
                                                    <c:param name="search" value="sale"/>
                                                    <c:if test="${not empty param.gender}">
                                                        <c:param name="gender" value="${param.gender}"/>
                                                    </c:if>
                                                    <c:if test="${not empty param.sort}">
                                                        <c:param name="sort" value="${param.sort}"/>
                                                    </c:if>
                                                </c:url>
                                            <li><a href="${saleProductsUrl}">Sale Products</a></li>
                                                <c:url var="hotProductsUrl" value="home">
                                                    <c:param name="viewMode" value="${viewMode}"/>
                                                    <c:param name="search" value="hot"/>
                                                    <c:if test="${not empty param.gender}">
                                                        <c:param name="gender" value="${param.gender}"/>
                                                    </c:if>
                                                    <c:if test="${not empty param.sort}">
                                                        <c:param name="sort" value="${param.sort}"/>
                                                    </c:if>
                                                </c:url>
                                            <li><a href="${hotProductsUrl}">Hot Products</a></li>
                                        </ul>
                                    </div>
                                </li>
                                <li><a href="product-details.html">Book<i class="fa fa-angle-down"></i></a>
                                    <div class="mega-menu">
                                        <c:forEach items="${listCollection}" var="collectionName">
                                            <span>
                                                <c:url var="collectionUrl" value="home">
                                                    <c:param name="viewMode" value="${viewMode}"/>
                                                    <c:param name="search" value="collection"/>
                                                    <c:param name="collection" value="${collectionName}"/>
                                                    <c:if test="${not empty param.gender}">
                                                        <c:param name="gender" value="${param.gender}"/>
                                                    </c:if>
                                                    <c:if test="${not empty param.sort}">
                                                        <c:param name="sort" value="${param.sort}"/>
                                                    </c:if>
                                                </c:url>
                                                <a href="${collectionUrl}">${collectionName}</a>
                                            </span>
                                        </c:forEach>
                                    </div>
                                </li>
                                <li><a href="product-details.html">Audio books<i class="fa fa-angle-down"></i></a>
                                    <div class="mega-menu">
                                        <span>
                                            <a href="#" class="title">Shirts</a>
                                            <a href="shop.html">Tops & Tees</a>
                                            <a href="shop.html">Sweaters </a>
                                            <a href="shop.html">Hoodies</a>
                                            <a href="shop.html">Jackets & Coats</a>
                                        </span>
                                        <span>
                                            <a href="#" class="title">Tops & Tees</a>
                                            <a href="shop.html">Long Sleeve </a>
                                            <a href="shop.html">Short Sleeve</a>
                                            <a href="shop.html">Polo Short Sleeve</a>
                                            <a href="shop.html">Sleeveless</a>
                                        </span>
                                        <span>
                                            <a href="#" class="title">Jackets</a>
                                            <a href="shop.html">Sweaters</a>
                                            <a href="shop.html">Hoodies</a>
                                            <a href="shop.html">Wedges</a>
                                            <a href="shop.html">Vests</a>
                                        </span>
                                        <span>
                                            <a href="#" class="title">Jeans Pants</a>
                                            <a href="shop.html">Polo Short Sleeve</a>
                                            <a href="shop.html">Sleeveless</a>
                                            <a href="shop.html">Graphic T-Shirts</a>
                                            <a href="shop.html">Hoodies</a>
                                        </span>
                                    </div>
                                </li>
                                <li><a href="product-details.html">children’s books<i class="fa fa-angle-down"></i></a>
                                    <div class="mega-menu mega-menu-2">
                                        <span>
                                            <a href="#" class="title">Tops</a>
                                            <a href="shop.html">Shirts</a>
                                            <a href="shop.html">Florals</a>
                                            <a href="shop.html">Crochet</a>
                                            <a href="shop.html">Stripes</a>
                                        </span>
                                        <span>
                                            <a href="#" class="title">Bottoms</a>
                                            <a href="shop.html">Shorts</a>
                                            <a href="shop.html">Dresses</a>
                                            <a href="shop.html">Trousers</a>
                                            <a href="shop.html">Jeans</a>
                                        </span>
                                        <span>
                                            <a href="#" class="title">Shoes</a>
                                            <a href="shop.html">Heeled sandals</a>
                                            <a href="shop.html">Flat sandals</a>
                                            <a href="shop.html">Wedges</a>
                                            <a href="shop.html">Ankle boots</a>
                                        </span>
                                    </div>
                                </li>
                                <li><a href="#">pages<i class="fa fa-angle-down"></i></a>
                                    <div class="sub-menu sub-menu-2">
                                        <ul>
                                            <li><a href="shop.html">shop</a></li>
                                            <li><a href="shop-list.html">shop list view</a></li>
                                            <li><a href="product-details.html">product-details</a></li>
                                            <li><a href="product-details-affiliate.html">product-affiliate</a></li>
                                            <li><a href="contact.html">contact</a></li>
                                            <li><a href="about.html">about</a></li>
                                            <li><a href="login.html">login</a></li>
                                            <li><a href="register.html">register</a></li>
                                            <li><a href="my-account.html">my-account</a></li>
                                            <li><a href="cart.html">cart</a></li>
                                            <li><a href="compare.html">compare</a></li>
                                            <li><a href="checkout.html">checkout</a></li>
                                            <li><a href="wishlist.html">wishlist</a></li>
                                            <li><a href="404.html">404 Page</a></li>
                                        </ul>
                                    </div>
                                </li>
                            </ul>
                        </nav>
                    </div>
                    <div class="safe-area">
                        <a href="product-details.html">sales off</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- main-menu-area-end -->
    <!-- header-top-area-start -->
    <div class="header-top-area">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-6 col-12">
                    <div class="language-area">
                        <ul>
                            <li><img src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/img/flag/1.jpg" alt="flag" /><a href="#">English<i class="fa fa-angle-down"></i></a>
                                <div class="header-sub">
                                    <ul>
                                        <li><a href="#"><img src="${pageContext.request.contextPath}/img/flag/2.jpg" alt="flag" />france</a></li>
                                        <li><a href="#"><img src="${pageContext.request.contextPath}/img/flag/3.jpg" alt="flag" />croatia</a></li>
                                    </ul>
                                </div>
                            </li>
                            <li><a href="#">USD $<i class="fa fa-angle-down"></i></a>
                                <div class="header-sub dolor">
                                    <ul>
                                        <li><a href="#">EUR €</a></li>
                                        <li><a href="#">USD $</a></li>
                                    </ul>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 col-12">
                    <div class="account-area text-end">
                        <ul>
                            <c:if test="${account != null}">
                                <!--Nguoi dung-->
                                <c:if test="${account.role.id == 2}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/dashboard">My Account: ${account.username}</a>
                                    </li>
                                </c:if>
                                <!--Admin-->
                                <c:if test="${account.role.id == 1}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">My Account: ${account.username}</a>
                                    </li>
                                </c:if>
                            </c:if>
                            <c:if test="${account == null}">
                                <li>
                                    <a href="authen?action=login">Sign in</a>
                                </li>
                                <li>
                                    <a href="authen?action=sign-up">Sign up</a>
                                </li>
                            </c:if>
                            <c:if test="${account != null}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/authen?action=logout">Sign Out</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-top-area-end -->
    <!-- header-mid-area-start -->
    <div class="header-mid-area ptb-40">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-3 col-md-5 col-12">
                    <div class="header-search">
                        <form action="home">
                            <input type="hidden" name="search" value="searchByKeyword">
                            <input type="text" placeholder="Search entire store here..." name="keyword"/>
                            <a href="#" onclick="return this.closest('form').submit()"><i class="fa fa-search"></i></a>
                        </form>
                    </div>
                </div>
                <div class="col-lg-6 col-md-4 col-12">
                    <div class="logo-area text-center logo-xs-mrg">
                        <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/img/logo/logo.png" alt="logo" /></a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-3 col-12">
                    <div class="my-cart">
                        <c:set var="cart" value="${sessionScope.cart}" />
                        <c:set var="cartCount" value="0" />
                        <c:if test="${not empty cart and not empty cart.orderDetails}">
                            <c:forEach items="${cart.orderDetails}" var="od">
                                <c:set var="cartCount" value="${cartCount + od.quantity}" />
                            </c:forEach>
                        </c:if>
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/payment">
                                    <i class="fa fa-shopping-cart"></i>My Cart
                                </a>
                                <span>${cartCount}</span>
                                <div class="mini-cart-sub">
                                    <div class="cart-product">
                                        <c:choose>
                                            <c:when test="${empty cart or empty cart.orderDetails}">
                                                <div class="single-cart">
                                                    <div class="cart-info">
                                                        <h5>Your cart is empty</h5>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach items="${cart.orderDetails}" var="od">
                                                    <div class="single-cart">
                                                        <div class="cart-img">
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${od.product.id}">
                                                                <img src="${pageContext.request.contextPath}/${od.product.mainImage}" alt="${od.product.name}" />
                                                            </a>
                                                        </div>
                                                        <div class="cart-info">
                                                            <h5>
                                                                <a href="${pageContext.request.contextPath}/product-details?id=${od.product.id}">
                                                                    ${od.product.name}
                                                                </a>
                                                            </h5>
                                                            <p>${od.quantity} x $${od.price} (Size ${od.size})</p>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="cart-totals">
                                        <h5>Total <span>$${empty cart ? 0 : cart.total}</span></h5>
                                    </div>
                                    <div class="cart-bottom">
                                        <a class="view-cart" href="${pageContext.request.contextPath}/payment">View cart</a>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-mid-area-end -->

</header>

<!-- header-area-end -->
