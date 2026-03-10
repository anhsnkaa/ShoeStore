<%-- 
    Document   : navbar
    Created on : Feb 23, 2026, 11:40:36 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<nav class="navbar navbar-expand static-top minimal-topbar">
    <button class="btn btn-link btn-sm order-1 order-sm-0 mr-2" id="sidebarToggle" href="#">
        <i class="fas fa-bars"></i>
    </button>
    <a class="navbar-brand font-weight-bold mb-0" href="${pageContext.request.contextPath}/admin/dashboard">
        ShoeStore Admin
    </a>
</nav>

  <div class="modal fade" id="updateProfileModalAdmin" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/authen?action=update-profile" method="post">
          <input type="hidden" name="target" value="admin"/>
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

  <div class="modal fade" id="changePasswordModalAdmin" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/authen?action=change-password" method="post">
          <input type="hidden" name="target" value="admin"/>
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
    function openUpdateProfileAdmin(event) {
      event.preventDefault();
      $("#updateProfileModalAdmin").modal("show");
    }

    function openChangePasswordAdmin(event) {
      event.preventDefault();
      $("#changePasswordModalAdmin").modal("show");
    }
  </script>
