<%-- 
    Document   : header
    Created on : Feb 10, 2026, 10:34:54 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US" scope="page"/>
<%@page import="dal.implement.CategoryDAO"%>
<%@page import="dal.implement.ProductDAO"%>
<%
    if (request.getAttribute("menCategories") == null || request.getAttribute("womenCategories") == null) {
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("menCategories", categoryDAO.getCategoriesByGender("MEN"));
        request.setAttribute("womenCategories", categoryDAO.getCategoriesByGender("WOMEN"));
    }

    if (request.getAttribute("listCollection") == null) {
        ProductDAO productDAO = new ProductDAO();
        request.setAttribute("listCollection", productDAO.getAllCollections());
    }

    if (request.getAttribute("viewMode") == null) {
        request.setAttribute("viewMode", "product");
    }
%>
<c:set var="cart" value="${sessionScope.cart}" />
<c:set var="cartCount" value="0" />
<c:if test="${not empty cart and not empty cart.orderDetails}">
    <c:forEach items="${cart.orderDetails}" var="od">
        <c:set var="cartCount" value="${cartCount + od.quantity}" />
    </c:forEach>
</c:if>
<!-- header-area-start -->
<header>
    <!-- main-menu-area-start -->
    <div class="main-menu-area d-md-none d-none d-lg-block sticky-header-1 ${isHomePage ? 'home-navbar' : ''}" id="header-sticky">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <c:url var="homeUrl" value="home">
                        <c:param name="viewMode" value="${viewMode}"/>
                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}"/>
                        </c:if>
                    </c:url>
                    <div class="main-menu-inner ${minimalHeader ? 'home-header-minimal' : ''}">
                        <c:if test="${not minimalHeader}">
                        <div class="menu-left-group">
                            <div class="menu-area">
                                <nav>
                                    <ul>
                                    <c:url var="menUrl" value="home">
                                        <c:param name="viewMode" value="${viewMode}"/>
                                        <c:param name="search" value="gender"/>
                                        <c:param name="gender" value="MEN"/>
                                        <c:if test="${not empty param.sort}">
                                            <c:param name="sort" value="${param.sort}"/>
                                        </c:if>
                                    </c:url>
                                    <c:url var="womenUrl" value="home">
                                        <c:param name="viewMode" value="${viewMode}"/>
                                        <c:param name="search" value="gender"/>
                                        <c:param name="gender" value="WOMEN"/>
                                        <c:if test="${not empty param.sort}">
                                            <c:param name="sort" value="${param.sort}"/>
                                        </c:if>
                                    </c:url>
                                    <li class="active"><a href="${homeUrl}">Home<i class="fa fa-angle-down"></i></a>
                                        <div class="sub-menu home-sub-menu">
                                            <ul>
                                                <li class="has-flyout">
                                                    <a href="${menUrl}#products-section">Men<i class="fa fa-angle-right"></i></a>
                                                    <div class="sub-menu-flyout">
                                                        <ul>
                                                            <c:forEach items="${menCategories}" var="category">
                                                                <c:url var="menCategoryUrl" value="home">
                                                                    <c:param name="viewMode" value="${viewMode}"/>
                                                                    <c:param name="search" value="category"/>
                                                                    <c:param name="categoryId" value="${category.id}"/>
                                                                    <c:param name="gender" value="MEN"/>
                                                                    <c:if test="${not empty param.sort}">
                                                                        <c:param name="sort" value="${param.sort}"/>
                                                                    </c:if>
                                                                </c:url>
                                                                <li><a href="${menCategoryUrl}#products-section">${category.name}</a></li>
                                                                </c:forEach>
                                                        </ul>
                                                    </div>
                                                </li>
                                                <li class="has-flyout">
                                                    <a href="${womenUrl}#products-section">Women<i class="fa fa-angle-right"></i></a>
                                                    <div class="sub-menu-flyout">
                                                        <ul>
                                                            <c:forEach items="${womenCategories}" var="category">
                                                                <c:url var="womenCategoryUrl" value="home">
                                                                    <c:param name="viewMode" value="${viewMode}"/>
                                                                    <c:param name="search" value="category"/>
                                                                    <c:param name="categoryId" value="${category.id}"/>
                                                                    <c:param name="gender" value="WOMEN"/>
                                                                    <c:if test="${not empty param.sort}">
                                                                        <c:param name="sort" value="${param.sort}"/>
                                                                    </c:if>
                                                                </c:url>
                                                                <li><a href="${womenCategoryUrl}#products-section">${category.name}</a></li>
                                                                </c:forEach>
                                                        </ul>
                                                    </div>
                                                </li>
                                                <li class="has-flyout">
                                                    <a href="${homeUrl}#products-section">Collections<i class="fa fa-angle-right"></i></a>
                                                    <div class="sub-menu-flyout collection-flyout">
                                                        <ul>
                                                            <c:forEach items="${listCollection}" var="collectionName">
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
                                                                <li><a href="${collectionUrl}#products-section">${collectionName}</a></li>
                                                                </c:forEach>
                                                        </ul>
                                                    </div>
                                                </li>
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
                                                <li><a href="${saleProductsUrl}#products-section">Sale Products</a></li>
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
                                                <li><a href="${hotProductsUrl}#products-section">Hot Products</a></li>
                                            </ul>
                                        </div>
                                    </li>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-search-wrap">
                                <div class="header-search">
                                    <form action="home#products-section">
                                        <input type="hidden" name="search" value="searchByKeyword">
                                        <input type="text" placeholder="Search" name="keyword"/>
                                        <a href="#" onclick="return this.closest('form').submit()"><i class="fa fa-search"></i></a>
                                    </form>
                                </div>
                            </div>
                        </div>
                        </c:if>
                        <div class="header-brand">
                            <a href="${homeUrl}">
                                ShoeStore
                            </a>
                        </div>
                        <div class="main-menu-auth">
                            <ul>
                                <c:if test="${account != null}">
                                    <c:if test="${account.role.id == 2}">
                                        <li><a href="${pageContext.request.contextPath}/dashboard">${account.username}</a></li>
                                        </c:if>
                                    <c:if test="${account.role.id == 1}">
                                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">${account.username}</a></li>
                                         </c:if>
                                </c:if>
                                <c:if test="${not minimalHeader}">
                                <li class="nav-cart">
                                    <a href="${pageContext.request.contextPath}/payment">
                                        <i class="fa fa-shopping-cart"></i>
                                        <span class="cart-link-label">Cart</span>
                                        <span class="nav-cart-count">${cartCount}</span>
                                    </a>
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
                                                                <p>${od.quantity} x <fmt:formatNumber value="${od.price}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273; (Size ${od.size})</p>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="cart-totals">
                                            <h5>Total <span><fmt:formatNumber value="${empty cart ? 0 : cart.total}" type="number" minFractionDigits="0" maxFractionDigits="0" groupingUsed="true"/> &#273;</span></h5>
                                        </div>
                                        <div class="cart-bottom">
                                            <a class="view-cart" href="${pageContext.request.contextPath}/payment">View cart</a>
                                        </div>
                                    </div>
                                </li>
                                </c:if>
                                <c:if test="${account != null}">
                                    <li><a href="${pageContext.request.contextPath}/authen?action=logout">Sign Out</a></li>
                                </c:if>
                                <c:if test="${account == null}">
                                    <c:choose>
                                        <c:when test="${minimalHeader}">
                                            <li class="auth-cta"><a href="${authHeaderHref}">${authHeaderLabel}</a></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li><a href="${pageContext.request.contextPath}/authen?action=login">Sign in</a></li>
                                            <li><a href="${pageContext.request.contextPath}/authen?action=sign-up">Sign up</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                             </ul>
                         </div>
                     </div>
                </div>
            </div>
        </div>
    </div>
    <!-- main-menu-area-end -->
    <!-- header-top-area-start -->
    <div class="header-top-area d-lg-none">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-6 col-12">
                    <div class="account-area text-end">
                        <ul>
                            <c:if test="${account != null}">
                                <!--Nguoi dung-->
                                <c:if test="${account.role.id == 2}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/dashboard">${account.username}</a>
                                    </li>
                                </c:if>
                                <!--Admin-->
                                <c:if test="${account.role.id == 1}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">${account.username}</a>
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
                            <li>
                                <a href="${pageContext.request.contextPath}/payment">Cart (${cartCount})</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-top-area-end -->
</header>

<!-- header-area-end -->
