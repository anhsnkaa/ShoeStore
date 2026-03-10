<%-- 
    Document   : dashboard
    Created on : Mar 1, 2026, 2:54:35 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

    <body id="page-top">
        <jsp:include page="../../common/user/navbar.jsp"></jsp:include>
            <div id="wrapper">

                <!-- Sidebar -->
            <jsp:include page="../../common/user/sidebar.jsp"></jsp:include>
                <div id="content-wrapper">
                    <div class="container-fluid">
                        <c:if test="${not empty sessionScope.authMessage}">
                            <c:choose>
                                <c:when test="${sessionScope.authType == 'success'}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        ${sessionScope.authMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        ${sessionScope.authMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <c:remove var="authType" scope="session"/>
                            <c:remove var="authMessage" scope="session"/>
                        </c:if>

                        <jsp:include page="../../common/user/breadcrumbs.jsp"></jsp:include>

                          <c:choose>
                             <c:when test="${not empty orders}">
                                <!-- Orders Table -->
                                <div class="card mb-3">
                                    <div class="card-header">
                                        <i class="fas fa-table"></i>
                                        My Orders
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                                <thead>
                                                    <tr>
                                                        <th>Order Id</th>
                                                        <th>Created Date</th>
                                                        <th>Status</th>
                                                        <th>Total amount</th>
                                                        <th>View Details</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${orders}" var="o">
                                                        <tr>
                                                            <td>#${o.id}</td>
                                                            <td>${o.createdDateDisplay}</td>
                                                            <td>${o.status}</td>
                                                            <td>${o.totalAmount} &#273;</td>
                                                            <td>
                                                                <button class="btn btn-info btn-sm"
                                                                        type="button"
                                                                        data-toggle="collapse"
                                                                        data-target="#order-detail-${o.id}"
                                                                        aria-expanded="false"
                                                                        aria-controls="order-detail-${o.id}">
                                                                    View Details
                                                                </button>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="5">
                                                                <div class="collapse" id="order-detail-${o.id}">
                                                                    <table class="table table-sm table-bordered mb-0">
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
                                                                            <c:if test="${empty o.orderDetails}">
                                                                                <tr>
                                                                                    <td colspan="6" class="text-center">No items in this order</td>
                                                                                </tr>
                                                                            </c:if>
                                                                            <c:forEach items="${o.orderDetails}" var="od">
                                                                                <tr>
                                                                                    <td>${od.product.name}</td>
                                                                                    <td>${od.color}</td>
                                                                                    <td>${od.size}</td>
                                                                                    <td>${od.quantity}</td>
                                                                                    <td>${od.price} &#273;</td>
                                                                                    <td>${od.price * od.quantity} &#273;</td>
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
                        </c:when>
                        <c:otherwise>
                            <div class="card mb-3">
                                <div class="card-body text-center">
                                    <h5 class="mb-0">No orders found</h5>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- /.container-fluid -->

                <!-- Sticky Footer -->
                <jsp:include page="../../common/user/footer.jsp"></jsp:include>

                </div>
                <!-- /.content-wrapper -->

            </div>
            <!-- /#wrapper -->

            <!-- Scroll to Top Button-->
            <a class="scroll-to-top rounded" href="#page-top">
                <i class="fas fa-angle-up"></i>
            </a>
            <div class="modal fade" id="sizeModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h5 class="modal-title">Available Sizes</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                &times;
                            </button>
                        </div>

                        <div class="modal-body">
                            <div id="sizeContent">
                                Loading...
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <script>
                function loadSizes(productId) {

                    $.ajax({
                        url: "<%= request.getContextPath() %>/admin/dashboard",
                        type: "GET",
                        data: {
                            action: "getSizes",
                            id: productId
                        },
                        success: function (data) {

                            var html = "";
                            html += "<table class='table table-bordered'>";
                            html += "<tr>";
                            html += "<th>Size</th>";
                            html += "<th>Quantity</th>";
                            html += "</tr>";

                            for (var i = 0; i < data.length; i++) {
                                html += "<tr>";
                                html += "<td>" + data[i].size + "</td>";
                                html += "<td>" + data[i].quantity + "</td>";
                                html += "</tr>";
                            }

                            html += "</table>";

                            $("#sizeContent").html(html);
                        },
                        error: function (xhr) {
                            $("#sizeContent").html("Error loading sizes");
                            console.log(xhr.responseText);
                        }
                    });

                }

                function setDeleteId(id, name) {
                    document.getElementById("deleteForm").action =
                            "${pageContext.request.contextPath}/admin/product?action=delete&id=" + id;

                    document.getElementById("deleteProductName").innerText =
                            "Delete product: " + name + "?";
                }
                function loadEditProduct(button) {

                    let id = button.dataset.id;

                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/product",
                        type: "GET",
                        dataType: "json",
                        data: {
                            action: "getProduct",
                            id: id
                        },
                        success: function (data) {

                            console.log(data); // test

                            $("#editId").val(data.id);
                            $("#editName").val(data.name);
                            $("#editPrice").val(data.price);
                            $("#editDescription").val(data.description);
                            $("#editCategory").val(data.categoryId);

                            let html = "";

                            for (let s = 36; s <= 44; s++) {

                                let qty = 0;

                                if (data.sizes) {
                                    data.sizes.forEach(function (item) {
                                        if (parseInt(item.size) == s) {
                                            qty = item.quantity;
                                        }
                                    });
                                }

                                html +=
                                        "<tr>" +
                                        "<td>" + s + "</td>" +
                                        "<td><input type='number' name='sizeQty_" + s +
                                        "' value='" + qty +
                                        "' class='form-control'></td>" +
                                        "</tr>";
                            }

                            $("#editSizeTable").html(html);
                        }
                    });
                }
                function previewEditImage(input) {

                    var preview = document.getElementById("editPreviewImage");

                    if (input.files && input.files[0]) {

                        var reader = new FileReader();

                        reader.onload = function (e) {
                            preview.src = e.target.result;
                            preview.style.display = "block";
                        };

                        reader.readAsDataURL(input.files[0]);
                    }
                }
        </script>

        <!-- Logout Modal-->
        <jsp:include page="../../common/user/logoutmodel.jsp"></jsp:include>
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
