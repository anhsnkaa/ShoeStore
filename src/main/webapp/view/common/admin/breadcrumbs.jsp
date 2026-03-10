<%-- 
    Document   : breadcrumbs
    Created on : Feb 23, 2026, 11:42:03 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="d-flex justify-content-between align-items-center mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        </li>
        <li class="breadcrumb-item active">Overview</li>
    </ol>

    <div>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-dark">
            Back To Home
        </a>
    </div>
</div>
