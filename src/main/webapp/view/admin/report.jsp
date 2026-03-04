<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Admin Report</title>
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
                            <li class="breadcrumb-item active">Report</li>
                        </ol>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-secondary">Back To Dashboard</a>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-dark">Back To Home</a>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-3 col-sm-6 mb-3">
                            <div class="card text-white bg-primary o-hidden h-100">
                                <div class="card-body">
                                    <div class="card-body-icon"><i class="fas fa-list"></i></div>
                                    <div class="mr-5">COUNT Orders</div>
                                    <h5 class="mb-0">${empty totalOrderCount ? 0 : totalOrderCount}</h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6 mb-3">
                            <div class="card text-white bg-success o-hidden h-100">
                                <div class="card-body">
                                    <div class="card-body-icon"><i class="fas fa-dollar-sign"></i></div>
                                    <div class="mr-5">SUM Revenue</div>
                                    <h5 class="mb-0">
                                        $<fmt:formatNumber value="${empty totalRevenue ? 0 : totalRevenue}" type="number" minFractionDigits="0" maxFractionDigits="2"/>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6 mb-3">
                            <div class="card text-white bg-info o-hidden h-100">
                                <div class="card-body">
                                    <div class="card-body-icon"><i class="fas fa-calculator"></i></div>
                                    <div class="mr-5">AVG Order Value</div>
                                    <h5 class="mb-0">
                                        $<fmt:formatNumber value="${empty avgOrderValue ? 0 : avgOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-sm-6 mb-3">
                            <div class="card text-white bg-warning o-hidden h-100">
                                <div class="card-body">
                                    <div class="card-body-icon"><i class="fas fa-arrow-up"></i></div>
                                    <div class="mr-5">MAX Order Value</div>
                                    <h5 class="mb-0">
                                        $<fmt:formatNumber value="${empty maxOrderValue ? 0 : maxOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/>
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-3 col-sm-6 mb-3">
                            <div class="card text-white bg-danger o-hidden h-100">
                                <div class="card-body">
                                    <div class="card-body-icon"><i class="fas fa-arrow-down"></i></div>
                                    <div class="mr-5">MIN Order Value</div>
                                    <h5 class="mb-0">
                                        $<fmt:formatNumber value="${empty minOrderValue ? 0 : minOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/>
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card mb-3">
                        <div class="card-header">
                            <i class="fas fa-table"></i> Report Summary
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" width="100%" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th>Metric</th>
                                            <th>Value</th>
                                            <th>Note</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>COUNT</td>
                                            <td>${empty totalOrderCount ? 0 : totalOrderCount}</td>
                                            <td>Total number of orders</td>
                                        </tr>
                                        <tr>
                                            <td>SUM</td>
                                            <td>$<fmt:formatNumber value="${empty totalRevenue ? 0 : totalRevenue}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                                    <td>Total revenue (CONFIRMED/SHIPPING/DONE)</td>
                                    </tr>
                                    <tr>
                                        <td>AVG</td>
                                        <td>$<fmt:formatNumber value="${empty avgOrderValue ? 0 : avgOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                                    <td>Average order value</td>
                                    </tr>
                                    <tr>
                                        <td>MAX</td>
                                        <td>$<fmt:formatNumber value="${empty maxOrderValue ? 0 : maxOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                                    <td>Highest order value</td>
                                    </tr>
                                    <tr>
                                        <td>MIN</td>
                                        <td>$<fmt:formatNumber value="${empty minOrderValue ? 0 : minOrderValue}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                                    <td>Lowest order value</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../common/admin/footer.jsp"></jsp:include>
                </div>
            </div>
            <jsp:include page="../common/admin/logoutmodel.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sb-admin.min.js"></script>
    </body>
</html>
