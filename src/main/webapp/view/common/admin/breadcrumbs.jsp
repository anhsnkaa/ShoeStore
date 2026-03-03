<%-- 
    Document   : breadcrumbs
    Created on : Feb 23, 2026, 11:42:03 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="d-flex justify-content-between align-items-center mb-3">

    <!-- Breadcrumb -->
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item">
            <a href="#">Dashboard</a>
        </li>
        <li class="breadcrumb-item active">Overview</li>
    </ol>
    <!-- quay về trang chủ -->
    <div class="d-flex justify-content-end mb-3">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-secondary">
            Back To Home
        </a>
    </div>
    <!-- Nút Add -->
    <button class="btn btn-primary"
            data-toggle="modal"
            data-target="#addModal">
        <i class="fas fa-plus"></i> Add Product
    </button>

</div>