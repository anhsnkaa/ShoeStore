<%-- 
    Document   : sidebar
    Created on : Feb 23, 2026, 10:56:37 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<ul class="sidebar navbar-nav">
    <li class="nav-item${fn:endsWith(currentUri, '/dashboard') ? ' active' : ''}">
        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
    </li>
    <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="userAccountDropdown" role="button" data-toggle="dropdown"
           aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-fw fa-user-circle"></i>
            <span>Account</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="userAccountDropdown">
            <h6 class="dropdown-header">${empty sessionScope.account.fullName ? 'My Account' : sessionScope.account.fullName}</h6>
            <a class="dropdown-item" href="#" onclick="openUpdateProfileUser(event)">Update Profile</a>
            <a class="dropdown-item" href="#" onclick="openChangePasswordUser(event)">Change Password</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">Logout</a>
        </div>
    </li>
    <li class="nav-item${fn:endsWith(currentUri, '/payment') ? ' active' : ''}">
        <a class="nav-link" href="${pageContext.request.contextPath}/payment">
            <i class="fas fa-fw fa-shopping-cart"></i>
            <span>Cart</span>
        </a>
    </li>
    <li class="nav-item${fn:endsWith(currentUri, '/home') ? ' active' : ''}">
        <a class="nav-link" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-fw fa-home"></i>
            <span>Home</span>
        </a>
    </li>
</ul>
