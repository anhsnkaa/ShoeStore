<%-- 
    Document   : breadcrumbs-area
    Created on : Feb 10, 2026, 10:44:57 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="breadcrumbs-area mb-70">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumbs-menu">
                    <c:choose>
                        <c:when test="${isHomePage}">
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

                            <ul class="d-flex align-items-center">
                                <li>
                                    <a href="${productModeUrl}" class="btn btn-sm ${viewMode == 'variant' ? 'btn-outline-dark' : 'btn-dark'}" style="margin-right:8px; border-radius:3px;">
                                        PRODUCT
                                    </a>
                                </li>
                                <li>
                                    <a href="${variantModeUrl}" class="btn btn-sm ${viewMode == 'variant' ? 'btn-dark' : 'btn-outline-dark'}" style="border-radius:3px;">
                                        VARIANT
                                    </a>
                                </li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <ul>
                                <li><a href="#">Home</a></li>
                                <li><a href="#" class="active">shop</a></li>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
