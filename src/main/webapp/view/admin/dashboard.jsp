<%-- 
    Document   : dashboard
    Created on : Feb 23, 2026, 10:36:07 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>SB Admin - Dashboard</title>

        <!-- Custom fonts for this template-->
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

        <!-- Page level plugin CSS-->
        <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="${pageContext.request.contextPath}/css/sb-admin.css" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/colReorder-bootstrap4.css">

    </head>

    <body id="page-top">
        <jsp:include page="../common/admin/navbar.jsp"></jsp:include>
            <div id="wrapper">

                <!-- Sidebar -->
            <jsp:include page="../common/admin/sidebar.jsp"></jsp:include>
                <div id="content-wrapper">

                     <div class="container-fluid">

                         <!-- Breadcrumbs-->
                     <jsp:include page="../common/admin/breadcrumbs.jsp"></jsp:include>

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

                          <!-- Icon Cards-->
                      <jsp:include page="../common/admin/iconcard.jsp"></jsp:include>
                        <!-- Area Chart Example-->
                        <div class="card mb-3">
                            <div class="card-header">
                                <i class="fas fa-chart-area"></i>
                                Area Chart Example
                            </div>
                            <div class="card-body">
                                <canvas id="myAreaChart" width="100%" height="30"></canvas>
                            </div>
                            <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
                        </div>

                        <!-- DataTables Example -->
                        <div class="card mb-3">
                            <div class="card-header">
                                <i class="fas fa-table"></i>
                                Data Table Example
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Image</th>
                                                <th>Price</th>
                                                <th>Category</th>
                                                <th>Variant/Image</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${listProduct}" var="p">
                                            <tr>
                                                <td>
                                                    ${p.name}
                                                    <c:if test="${p.hot}">
                                                        <span class="badge badge-danger ml-1">HOT</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty p.images}">
                                                            <img src="${pageContext.request.contextPath}/${p.images[0].imageUrl}"
                                                                 width="80"
                                                                 height="80"
                                                                 style="object-fit: cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            No Image
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>$${p.price}</td>
                                                <td>
                                                    ${p.category.name}
                                                    <c:if test="${not empty p.category.gender and not empty p.category.gender.name}">
                                                        (${p.category.gender.name})
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="d-flex flex-column align-items-start">
                                                        <button class="btn btn-info btn-sm mb-1"
                                                                data-toggle="modal"
                                                                data-target="#sizeModal"
                                                                onclick="loadSizes(${p.id})">
                                                            View Variants
                                                        </button>
                                                        <button class="btn btn-secondary btn-sm"
                                                                data-toggle="modal"
                                                                data-target="#imageModal"
                                                                onclick="loadImages(${p.id})">
                                                            View Images
                                                        </button>
                                                    </div>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm"
                                                            data-toggle="modal"
                                                            data-target="#editModal"
                                                            data-id="${p.id}"
                                                            data-name="${p.name}"
                                                            data-price="${p.price}"
                                                            data-description="${p.description}"
                                                            onclick="loadEditProduct(this)">
                                                        Edit
                                                    </button>
                                                    <button class="btn btn-danger btn-sm"
                                                            data-toggle="modal"
                                                            data-target="#deleteModal"
                                                            onclick="setDeleteId(${p.id}, '${p.name}')">
                                                        Delete
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
                    </div>

                </div>
                <!-- /.container-fluid -->

                <!-- Sticky Footer -->
                <jsp:include page="../common/admin/footer.jsp"></jsp:include>

                </div>
                <!-- /.content-wrapper -->

            </div>

            <!-- /#wrapper -->
            <!-- size modal-->
            <a class="scroll-to-top rounded" href="#page-top">
                <i class="fas fa-angle-up"></i>
            </a>
            <div class="modal fade" id="sizeModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h5 class="modal-title">Available Variants</h5>
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
            <!-- image modal-->
             <div class="modal fade" id="imageModal" tabindex="-1">
                 <div class="modal-dialog modal-lg">
                     <div class="modal-content">

                        <div class="modal-header">
                            <h5 class="modal-title">Product Images</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                &times;
                            </button>
                        </div>

                        <div class="modal-body">
                            <div id="imageContent">
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
                        dataType: "json",
                        data: {
                            action: "getSizes",
                            id: productId
                        },
                        success: function (data) {

                            var html = "";
                            html += "<table class='table table-bordered'>";
                            html += "<tr>";
                            html += "<th>Color</th>";
                            html += "<th>Size</th>";
                            html += "<th>Quantity</th>";
                            html += "</tr>";

                            for (var i = 0; i < data.length; i++) {
                                html += "<tr>";
                                html += "<td>" + (data[i].color || "") + "</td>";
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
                            $("#editCollection").val(data.collection || "");
                            $("#editFeatured").prop("checked", !!data.featured);
                            $("#editDiscount").val(data.discount || 0);
                            $("#editSaleStartAt").val(data.saleStartAt || "");
                            $("#editSaleEndAt").val(data.saleEndAt || "");

                            $("#editSizeTable").html("");

                            if (data.sizes && data.sizes.length > 0) {
                                data.sizes.forEach(function (item) {
                                    addVariantRow("editSizeTable", item.color || "", item.size || 36, item.quantity || 0);
                                });
                            } else {
                                addVariantRow("editSizeTable", "", 36, 0);
                            }
                        }
                    });
                }
                function loadImages(productId) {

                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/dashboard",
                        type: "GET",
                        dataType: "json",
                        data: {
                            action: "getImages",
                            id: productId
                        },
                        success: function (data) {

                            console.log(data);

                            if (!data || data.length === 0) {
                                $("#imageContent").html("No images found");
                                return;
                            }

                            var html = "<div class='row'>";

                            for (var i = 0; i < data.length; i++) {

                                html += "<div class='col-md-3 mb-3'>";
                                html += "<img src='${pageContext.request.contextPath}/" + data[i].imageUrl +
                                        "' class='img-fluid img-thumbnail'>";
                                html += "</div>";
                            }

                            html += "</div>";

                            $("#imageContent").html(html);
                        },
                        error: function (xhr) {
                            console.log(xhr);
                            $("#imageContent").html("Error loading images");
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
        <jsp:include page="../common/admin/logoutmodel.jsp"></jsp:include>

        <jsp:include page="../admin/addProductModal.jsp"></jsp:include>
        <jsp:include page="../admin/deleteProductModal.jsp"/>
        <jsp:include page="../admin/editProductModal.jsp"/>
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
