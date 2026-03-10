<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Order Management</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="${pageContext.request.contextPath}/css/sb-admin.css" rel="stylesheet">
    </head>
    <body id="page-top">
        <jsp:include page="../common/admin/navbar.jsp"></jsp:include>
            <div id="wrapper">
            <jsp:include page="../common/admin/sidebar.jsp"></jsp:include>
                <div id="content-wrapper">
                    <div class="container-fluid">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active">Order Management</li>
                            </ol>
                            <div>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-dark">Back To Home</a>
                            </div>
                        </div>

                        <c:if test="${not empty orderMessage}">
                            <c:choose>
                                <c:when test="${orderType == 'success'}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        ${orderMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        ${orderMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <div class="row">
                            <div class="col-xl-3 col-sm-6 mb-3">
                                <div class="card text-white bg-primary o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-shopping-bag"></i></div>
                                        <div class="mr-5">Total Orders</div>
                                        <h5 class="mb-0">${empty totalOrders ? 0 : totalOrders}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 mb-3">
                                <div class="card text-white bg-warning o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-hourglass-half"></i></div>
                                        <div class="mr-5">Pending Orders</div>
                                        <h5 class="mb-0">${empty pendingOrders ? 0 : pendingOrders}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 mb-3">
                                <div class="card text-white bg-info o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-truck"></i></div>
                                        <div class="mr-5">In Process</div>
                                        <h5 class="mb-0">${(empty confirmedOrders ? 0 : confirmedOrders) + (empty shippingOrders ? 0 : shippingOrders)}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-sm-6 mb-3">
                                <div class="card text-white bg-success o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-check-circle"></i></div>
                                        <div class="mr-5">Completed Orders</div>
                                        <h5 class="mb-0">${empty doneOrders ? 0 : doneOrders}</h5>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card mb-3">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-table"></i> Order Management</span>
                                <span class="badge badge-secondary">${empty totalOrders ? 0 : totalOrders} orders</span>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th>Contact</th>
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
                                                    <td colspan="9" class="text-center">No orders found</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${orders}" var="o">
                                                <tr>
                                                    <td>#${o.id}</td>
                                                    <td>${o.user.fullName}</td>
                                                    <td>
                                                        <div>${o.user.email}</div>
                                                        <small class="text-muted">${o.user.phone}</small>
                                                    </td>
                                                    <td>${o.user.address}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${o.status == 'PENDING'}">
                                                                <span class="badge badge-warning">PENDING</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'CONFIRMED'}">
                                                                <span class="badge badge-primary">CONFIRMED</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'SHIPPING'}">
                                                                <span class="badge badge-info">SHIPPING</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'DONE'}">
                                                                <span class="badge badge-success">DONE</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-secondary">${o.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${o.totalAmount}" type="number" minFractionDigits="0" maxFractionDigits="2"/> &#273;
                                                    </td>
                                                    <td>${o.createdDateDisplay}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${o.status == 'PENDING'}">
                                                                <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="update-status"/>
                                                                    <input type="hidden" name="orderId" value="${o.id}"/>
                                                                    <input type="hidden" name="status" value="CONFIRMED"/>
                                                                    <button type="submit" class="btn btn-sm btn-warning">Confirm</button>
                                                                </form>
                                                            </c:when>
                                                            <c:when test="${o.status == 'CONFIRMED'}">
                                                                <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="update-status"/>
                                                                    <input type="hidden" name="orderId" value="${o.id}"/>
                                                                    <input type="hidden" name="status" value="SHIPPING"/>
                                                                    <button type="submit" class="btn btn-sm btn-primary">Ship Order</button>
                                                                </form>
                                                            </c:when>
                                                            <c:when test="${o.status == 'SHIPPING'}">
                                                                <form action="${pageContext.request.contextPath}/admin/order" method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="update-status"/>
                                                                    <input type="hidden" name="orderId" value="${o.id}"/>
                                                                    <input type="hidden" name="status" value="DONE"/>
                                                                    <button type="submit" class="btn btn-sm btn-success">Mark Done</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted small">No action</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-info btn-sm"
                                                                type="button"
                                                                data-toggle="collapse"
                                                                data-target="#order-detail-${o.id}"
                                                                aria-expanded="false"
                                                                aria-controls="order-detail-${o.id}">
                                                            View
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="9" class="p-0 border-top-0">
                                                        <div class="collapse" id="order-detail-${o.id}">
                                                            <div class="p-3 bg-light border-top">
                                                                <h6 class="mb-3">Order Details</h6>
                                                                <div class="table-responsive">
                                                                    <table class="table table-sm table-bordered mb-0 bg-white">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Product</th>
                                                                                <th>Color</th>
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
                                                                                    <td>${od.color}</td>
                                                                                    <td>${od.size}</td>
                                                                                    <td>${od.quantity}</td>
                                                                                    <td><fmt:formatNumber value="${od.price}" type="number" minFractionDigits="0" maxFractionDigits="2"/> &#273;</td>
                                                                                    <td><fmt:formatNumber value="${od.price * od.quantity}" type="number" minFractionDigits="0" maxFractionDigits="2"/> &#273;</td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer small text-muted">Manage order flow from pending to completed.</div>
                        </div>
                    </div>
                    <jsp:include page="../common/admin/footer.jsp"></jsp:include>
                </div>
            </div>

            <a class="scroll-to-top rounded" href="#page-top">
                <i class="fas fa-angle-up"></i>
            </a>
            <jsp:include page="../common/admin/logoutmodel.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/sb-admin.min.js"></script>
    </body>
</html>
