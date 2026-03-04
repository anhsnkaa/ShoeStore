<%-- 
    Document   : cart
    Created on : Mar 1, 2026, 4:24:38 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <!-- Mirrored from htmldemo.net/koparion/koparion/cart.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:44 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Koparion – Book Shop HTML5 Template</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

        <!-- all css here -->
        <!-- bootstrap v3.3.6 css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <!-- animate css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animate.css">
        <!-- meanmenu css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meanmenu.min.css">
        <!-- owl.carousel css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.css">
        <!-- font-awesome css -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" integrity="sha512-+L4yy6FRcDGbXJ9mPG8MT/3UCDzwR9gPeyFNMCtInsol++5m3bk2bXWKdZjvybmohrAsn3Ua5x8gfLnbE1YkOg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <!-- flexslider.css-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flexslider.css">
        <!-- chosen.min.css-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chosen.min.css">
        <!-- style css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <!-- responsive css -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
        <!-- modernizr css -->
        <script src="${pageContext.request.contextPath}/js/vendor/modernizr-2.8.3.min.js"></script>
    </head>
    <body class="cart">
        <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!-- Add your site or application content here -->
        <!-- header-area-start -->
        <jsp:include page="../../common/homePage/header.jsp"></jsp:include>
            <!-- header-area-end -->
            <!-- breadcrumbs-area-start -->
        <jsp:include page="../../common/homePage/breadcrumbs-area.jsp"></jsp:include>
            <!-- breadcrumbs-area-end -->
            <!-- entry-header-area-start -->
            <div class="entry-header-area">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="entry-header-title">
                                <h2>Cart</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- entry-header-area-end -->
            <!-- cart-main-area-start -->
             <div class="cart-main-area mb-70">
                 <div class="container">
                    <c:if test="${not empty checkoutMessage}">
                        <div class="row" style="margin-bottom: 16px;">
                            <div class="col-lg-12">
                                <c:if test="${checkoutType == 'success'}">
                                    <div class="alert alert-success" role="alert">${checkoutMessage}</div>
                                </c:if>
                                <c:if test="${checkoutType != 'success'}">
                                    <div class="alert alert-danger" role="alert">${checkoutMessage}</div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="table-content table-responsive mb-15 border-1">
                                <table>
                                    <thead>
                                        <tr>
                                            <th class="product-thumbnail">Image</th>
                                            <th class="product-name">Product</th>
                                            <th class="product-price">Price</th>
                                            <th class="product-quantity">Quantity</th>
                                            <th class="product-subtotal">Total</th>
                                            <th class="product-remove">Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:if test="${empty cart or empty cart.orderDetails}">
                                        <tr>
                                            <td colspan="6" style="text-align:center;">
                                                Your cart is empty
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${cart.orderDetails}" var="od">
                                        <tr>
                                            <!-- IMAGE -->
                                            <td class="product-thumbnail">
                                                <a href="#">
                                                    <img src="${pageContext.request.contextPath}/${od.product.mainImage}" 
                                                         width="80">
                                                </a>
                                            </td>

                                            <!-- NAME -->
                                            <td class="product-name">
                                                ${od.product.name}
                                                <br>
                                                <small>Size: ${od.size}</small>
                                            </td>

                                            <!-- PRICE -->
                                            <td class="product-price">
                                                $${od.price}
                                            </td>

                                            <!-- QUANTITY -->
                                            <td class="product-quantity">
                                                <form action="${pageContext.request.contextPath}/payment?action=change-quantity" method="POST">
                                                    <input type="hidden" name="id" value="${od.product.id}"/>
                                                    <input type="hidden" name="size" value="${od.size}"/>
                                                    <input type="number"
                                                           class="qty-input"
                                                           data-price="${od.price}"
                                                           value="${od.quantity}"
                                                           min="1"
                                                           name="quantity"
                                                           onchange="this.form.submit()">
                                                </form>
                                            </td>
                                    <!-- TOTAL -->
                                    <td class="product-subtotal">
                                        $<span class="item-total">
                                            ${od.price * od.quantity}
                                        </span>
                                    </td>

                                    <!-- REMOVE -->
                                            <td class="product-remove">
                                                <form action="${pageContext.request.contextPath}/payment?action=delete-product" method="POST">
                                                    <input type="hidden" name="id" value="${od.product.id}"/>
                                                    <input type="hidden" name="size" value="${od.size}"/>
                                                    <button type="submit" style="background:none;border:none;padding:0;cursor:pointer;">
                                                        <i class="fa fa-times"></i>
                                                    </button>
                                                </form>
                                            </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 col-md-6 col-12">
                        <div class="buttons-cart mb-30">
                            <form action="action">
                                <ul>
                                    <li><a href="#">Continue Shopping</a></li>
                                </ul>
                            </form>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 col-12">
                        <div class="cart_totals">
                            <h2>Cart Totals</h2>
                            <table>
                                <tbody>
                                    <tr class="cart-subtotal">
                                        <th>Subtotal</th>
                                        <td>
                                            <span class="amount">£215.00</span>
                                        </td>
                                    </tr>
                                    <tr class="shipping">
                                        <th>Shipping</th>
                                        <td>
                                            <ul id="shipping_method">
                                                <li>
                                                    <label> Free Shipping </label>
                                                </li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr class="order-total">
                                        <th>Total</th>
                                        <td>
                                            <strong>
                                                <span class="amount">$<span id="cart-total">${cart.total}</span></span>
                                            </strong>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="wc-proceed-to-checkout">
                                <form action="${pageContext.request.contextPath}/payment?action=check-out" method="POST">
                                    <button type="submit">Proceed to Checkout</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- cart-main-area-end -->
        <!-- footer-area-start -->
        <jsp:include page="../../common/homePage/footer.jsp"></jsp:include>
            <!-- footer-area-end -->
            <script>
                document.addEventListener("DOMContentLoaded", function () {

                    const qtyInputs = document.querySelectorAll(".qty-input");

                    function updateCartTotal() {
                        let total = 0;

                        document.querySelectorAll("tbody tr").forEach(row => {
                            const qtyInput = row.querySelector(".qty-input");
                            if (!qtyInput)
                                return;
                            const price = parseFloat(qtyInput.dataset.price);
                            const quantity = parseInt(qtyInput.value);

                            const itemTotal = price * quantity;

                            row.querySelector(".item-total").innerText = itemTotal.toFixed(2);

                            total += itemTotal;
                        });

                        document.getElementById("cart-total").innerText = total.toFixed(2);
                    }

                    qtyInputs.forEach(input => {
                        input.addEventListener("input", updateCartTotal);
                    });

                });
            </script>

            <!-- all js here -->
            <!-- jquery latest version -->
            <script src="${pageContext.request.contextPath}/js/vendor/jquery-1.12.4.min.js"></script>


        <!-- bootstrap js -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <!-- owl.carousel js -->
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <!-- meanmenu js -->
        <script src="${pageContext.request.contextPath}/js/jquery.meanmenu.js"></script>
        <!-- wow js -->
        <script src="${pageContext.request.contextPath}/js/wow.min.js"></script>
        <!-- jquery.parallax-1.1.3.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.parallax-1.1.3.js"></script>
        <!-- jquery.countdown.min.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.countdown.min.js"></script>
        <!-- jquery.flexslider.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.flexslider.js"></script>
        <!-- chosen.jquery.min.js -->
        <script src="${pageContext.request.contextPath}/js/chosen.jquery.min.js"></script>
        <!-- jquery.counterup.min.js -->
        <script src="${pageContext.request.contextPath}/js/jquery.counterup.min.js"></script>
        <!-- waypoints.min.js -->
        <script src="${pageContext.request.contextPath}/js/waypoints.min.js"></script>
        <!-- plugins js -->
        <script src="${pageContext.request.contextPath}/js/plugins.js"></script>
        <!-- main js -->
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
    </body>

    <!-- Mirrored from htmldemo.net/koparion/koparion/cart.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:45 GMT -->
</html>
