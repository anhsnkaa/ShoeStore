<%-- 
    Document   : order
    Created on : Mar 3, 2026, 2:28:02 PM
    Author     : FPTShop
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>SB User - Dashboard</title>

        <!-- Custom fonts for this template-->
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

        <!-- Page level plugin CSS-->
        <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="${pageContext.request.contextPath}/css/sb-admin.css" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/colReorder-bootstrap4.css">

    </head>
    <div class="card mb-3">
        <div class="card-header">
            <i class="fas fa-table"></i>
            Order Management
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-secondary float-right">
                Back To Dashboard
            </a>
        </div>
        <div class="card-body">
            <c:if test="${not empty orderMessage}">
                <c:choose>
                    <c:when test="${orderType == 'success'}">
                        <div class="alert alert-success" role="alert">${orderMessage}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger" role="alert">${orderMessage}</div>
                    </c:otherwise>
                </c:choose>
            </c:if>
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Created Date</th>
                            <th>Action</th>
                            <th>View Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="10" class="text-center">No orders found</td>
                            </tr>
                        </c:if>
                        <c:forEach items="${orders}" var="o">
                            <tr>
                                <td>#${o.id}</td>
                                <td>${o.user.fullName}</td>
                                <td>${o.user.email}</td>
                                <td>${o.user.phone}</td>
                                <td>${o.user.address}</td>
                                <td>${o.status}</td>
                                <td>$${o.totalAmount}</td>
                                <td>${o.createdDateDisplay}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="update-status"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <input type="hidden" name="status" value="CONFIRMED"/>
                                                <button type="submit" class="btn btn-sm btn-warning">Chấp nhận</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.status == 'CONFIRMED'}">
                                            <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="update-status"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <input type="hidden" name="status" value="SHIPPING"/>
                                                <button type="submit" class="btn btn-sm btn-primary">Đã gửi hàng</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.status == 'SHIPPING'}">
                                            <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="update-status"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <input type="hidden" name="status" value="DONE"/>
                                                <button type="submit" class="btn btn-sm btn-success">Đã nhận hàng</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.status == 'DONE'}">
                                            <span class="badge badge-success">Đã nhận hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">${o.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-info btn-sm"
                                            type="button"
                                            data-toggle="collapse"
                                            data-target="#order-detail-${o.id}">
                                        View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="10">
                                    <div class="collapse" id="order-detail-${o.id}">
                                        <table class="table table-sm table-bordered mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Size</th>
                                                    <th>Qty</th>
                                                    <th>Price</th>
                                                    <th>Line Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${o.orderDetails}" var="od">
                                                    <tr>
                                                        <td>${od.product.name}</td>
                                                        <td>${od.size}</td>
                                                        <td>${od.quantity}</td>
                                                        <td>$${od.price}</td>
                                                        <td>$${od.price * od.quantity}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Bootstrap core JavaScript-->
    <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Page level plugin JavaScript-->
    <script src="${pageContext.request.contextPath}/vendor/chart.js/Chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/datatables/jquery.dataTables.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="${pageContext.request.contextPath}/js/sb-admin.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/colReorder-bootstrap4-min.js"></script>
    <script src="${pageContext.request.contextPath}/js/colReorder-dataTables-min.js"></script>

    <!-- Demo scripts for this page-->
    <script src="${pageContext.request.contextPath}/js/demo/datatables-demo.js"></script>
    <script src="${pageContext.request.contextPath}/js/demo/chart-area-demo.js"></script>
    <script src="${pageContext.request.contextPath}/js/colReorder-dataTables-min.js"></script>
    <script src="${pageContext.request.contextPath}/js/colReorder-bootstrap4-min.js"></script>


</body>

</html>
