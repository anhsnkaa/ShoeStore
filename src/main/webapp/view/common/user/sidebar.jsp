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
    <li class="nav-item sidebar-toggle-item">
        <button class="nav-link sidebar-extend-toggle" id="sidebarToggle" type="button" aria-label="Toggle sidebar">
            <i class="fas fa-fw fa-bars"></i>
            <span>Extend</span>
        </button>
    </li>
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

<div class="modal fade" id="updateProfileModalUser" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/authen?action=update-profile" method="post">
                <input type="hidden" name="target" value="user"/>
                <div class="modal-header">
                    <h5 class="modal-title">Update Profile</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" class="form-control" value="${sessionScope.account.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" value="${sessionScope.account.email}" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" class="form-control" value="${sessionScope.account.phone}">
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" class="form-control" value="${sessionScope.account.address}">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="changePasswordModalUser" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/authen?action=change-password" method="post">
                <input type="hidden" name="target" value="user"/>
                <div class="modal-header">
                    <h5 class="modal-title">Change Password</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openUpdateProfileUser(event) {
        event.preventDefault();
        $("#updateProfileModalUser").modal("show");
    }

    function openChangePasswordUser(event) {
        event.preventDefault();
        $("#changePasswordModalUser").modal("show");
    }
</script>
