<%--
    Document   : cart
    Created on : Mar 1, 2026, 4:24:38 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US" scope="page"/>
<c:set var="cartHasItems" value="${not empty cart and not empty cart.orderDetails}"/>
<c:set var="cartLineCount" value="0"/>
<c:set var="cartQuantityCount" value="0"/>
<c:set var="cartTotalValue" value="${empty cart ? 0 : cart.total}"/>
<c:if test="${cartHasItems}">
    <c:set var="cartLineCount" value="${fn:length(cart.orderDetails)}"/>
    <c:forEach items="${cart.orderDetails}" var="lineItem">
        <c:set var="cartQuantityCount" value="${cartQuantityCount + lineItem.quantity}"/>
    </c:forEach>
</c:if>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Checkout | ShoeStore</title>
        <meta name="description" content="Review your cart and complete checkout at ShoeStore.">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animate.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meanmenu.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" integrity="sha512-+L4yy6FRcDGbXJ9mPG8MT/3UCDzwR9gPeyFNMCtInsol++5m3bk2bXWKdZjvybmohrAsn3Ua5x8gfLnbE1YkOg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flexslider.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chosen.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
        <script src="${pageContext.request.contextPath}/js/vendor/modernizr-2.8.3.min.js"></script>
    </head>
    <body class="cart payment-page">
        <jsp:include page="../../common/homePage/header.jsp"></jsp:include>

            <section class="payment-main">
                <div class="container-fluid payment-container">
                    <c:if test="${not empty checkoutMessage}">
                        <div class="payment-alert alert ${checkoutType == 'success' ? 'alert-success' : 'alert-danger'}" role="alert">
                            ${checkoutMessage}
                        </div>
                    </c:if>
                        
                    <div class="row payment-grid">
                        <div class="col-xl-8 col-lg-7 col-12">
                            <div class="payment-cart-card">
                                <div class="payment-card-head">
                                    <div>
                                        <p class="payment-kicker">Bag overview</p>
                                        <h2>Your cart</h2>
                                        <p class="payment-card-copy">Everything here stays synced with live stock before checkout is confirmed.</p>
                                    </div>
                                    <div class="payment-badge-group">
                                        <span>${cartLineCount} styles</span>
                                        <span>${cartQuantityCount} total items</span>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${cartHasItems}">
                                        <div class="payment-item-list">
                                            <c:forEach items="${cart.orderDetails}" var="od">
                                                <article class="payment-item-card">
                                                    <a class="payment-item-media" href="${pageContext.request.contextPath}/product-details?id=${od.product.id}">
                                                        <img src="${pageContext.request.contextPath}/${od.product.mainImage}" alt="${od.product.name}" loading="lazy" decoding="async">
                                                    </a>
                                                    <div class="payment-item-content">
                                                        <div class="payment-item-top">
                                                            <div class="payment-item-heading">
                                                                <p class="payment-item-tag">Curated pair</p>
                                                                <h3>
                                                                    <a href="${pageContext.request.contextPath}/product-details?id=${od.product.id}">${od.product.name}</a>
                                                                </h3>
                                                                <div class="payment-item-meta">
                                                                    <span>Color ${od.color}</span>
                                                                    <span>Size ${od.size}</span>
                                                                </div>
                                                            </div>
                                                            <form action="${pageContext.request.contextPath}/payment?action=delete-product" method="POST" class="payment-remove-form">
                                                                <input type="hidden" name="id" value="${od.product.id}">
                                                                <input type="hidden" name="size" value="${od.size}">
                                                                <input type="hidden" name="color" value="${od.color}">
                                                                <button type="submit" class="payment-remove-btn" aria-label="Remove ${od.product.name}">
                                                                    <i class="fa fa-times"></i>
                                                                    <span>Remove</span>
                                                                </button>
                                                            </form>
                                                        </div>

                                                        <div class="payment-item-bottom">
                                                            <div class="payment-info-panel">
                                                                <span class="payment-label">Unit price</span>
                                                                <strong>
                                                                    <fmt:formatNumber value="${od.price}" type="number" minFractionDigits="0" maxFractionDigits="2" groupingUsed="true"/> &#273;
                                                                </strong>
                                                            </div>

                                                            <div class="payment-info-panel payment-info-panel-qty">
                                                                <span class="payment-label">Quantity</span>
                                                                <form action="${pageContext.request.contextPath}/payment?action=change-quantity" method="POST" class="payment-qty-form">
                                                                    <input type="hidden" name="id" value="${od.product.id}">
                                                                    <input type="hidden" name="size" value="${od.size}">
                                                                    <input type="hidden" name="color" value="${od.color}">
                                                                    <input type="number"
                                                                           class="qty-input payment-qty-input"
                                                                           data-price="${od.price}"
                                                                           value="${od.quantity}"
                                                                           min="1"
                                                                           name="quantity"
                                                                           onchange="this.form.submit()">
                                                                </form>
                                                                <small>Change quantity and leave the field to save.</small>
                                                            </div>

                                                            <div class="payment-info-panel payment-info-panel-total">
                                                                <span class="payment-label">Line total</span>
                                                                <strong>
                                                                    <span class="item-total"><fmt:formatNumber value="${od.price * od.quantity}" type="number" minFractionDigits="0" maxFractionDigits="2" groupingUsed="true"/></span> &#273;
                                                                </strong>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </article>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="payment-empty-state">
                                            <div class="payment-empty-icon">
                                                <i class="fa fa-shopping-basket"></i>
                                            </div>
                                            <h3>Your cart is waiting for the first pair.</h3>
                                            <p>Browse the latest drops, discover a new colorway, and build a checkout that feels complete.</p>
                                            <a href="${pageContext.request.contextPath}/home#products-section" class="payment-primary-btn">Explore products</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-5 col-12">
                            <aside class="payment-summary-card">
                                <h2>Order summary</h2>
                                
                                <div class="payment-summary-list">
                                    <div class="payment-summary-row">
                                        <span>Subtotal</span>
                                        <strong><span id="cart-subtotal"><fmt:formatNumber value="${cartTotalValue}" type="number" minFractionDigits="0" maxFractionDigits="2" groupingUsed="true"/></span> &#273;</strong>
                                    </div>
                                    <div class="payment-summary-row">
                                        <span>Shipping</span>
                                        <strong>Free</strong>
                                    </div>
                                    <div class="payment-summary-row">
                                        <span>Styles</span>
                                        <strong>${cartLineCount}</strong>
                                    </div>
                                    <div class="payment-summary-row total">
                                        <span>Total</span>
                                        <strong><span id="cart-total"><fmt:formatNumber value="${cartTotalValue}" type="number" minFractionDigits="0" maxFractionDigits="2" groupingUsed="true"/></span> &#273;</strong>
                                    </div>
                                </div>


                                <c:choose>
                                    <c:when test="${cartHasItems}">
                                        <form action="${pageContext.request.contextPath}/payment?action=check-out" method="POST" class="payment-checkout-form">
                                            <button type="submit" class="payment-primary-btn">Proceed to checkout</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/home#products-section" class="payment-primary-btn">Start shopping</a>
                                    </c:otherwise>
                                </c:choose>

                                <a href="${pageContext.request.contextPath}/home#products-section" class="payment-secondary-btn">Continue shopping</a>
                            </aside>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <jsp:include page="../../common/homePage/footer.jsp"></jsp:include>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const qtyInputs = document.querySelectorAll(".qty-input");

                function formatCurrency(value) {
                    return Number(value).toLocaleString("en-US", {
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 2
                    });
                }

                function updateCartTotal() {
                    let total = 0;
                    let itemCount = 0;

                    document.querySelectorAll(".payment-item-card").forEach(card => {
                        const qtyInput = card.querySelector(".qty-input");
                        if (!qtyInput) {
                            return;
                        }

                        const price = parseFloat(qtyInput.dataset.price || "0");
                        const quantity = parseInt(qtyInput.value || "0", 10);
                        const safeQuantity = Number.isNaN(quantity) ? 0 : quantity;
                        const itemTotal = price * safeQuantity;

                        const itemTotalNode = card.querySelector(".item-total");
                        if (itemTotalNode) {
                            itemTotalNode.innerText = formatCurrency(itemTotal);
                        }

                        itemCount += safeQuantity;
                        total += itemTotal;
                    });

                    const subtotalNode = document.getElementById("cart-subtotal");
                    const totalNode = document.getElementById("cart-total");
                    const quantityNode = document.getElementById("cart-quantity-total");

                    if (subtotalNode) {
                        subtotalNode.innerText = formatCurrency(total);
                    }

                    if (totalNode) {
                        totalNode.innerText = formatCurrency(total);
                    }

                    if (quantityNode) {
                        quantityNode.innerText = itemCount;
                    }
                }

                qtyInputs.forEach(input => {
                    input.addEventListener("input", updateCartTotal);
                });
            });
        </script>

        <script src="${pageContext.request.contextPath}/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.meanmenu.js"></script>
        <script src="${pageContext.request.contextPath}/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.parallax-1.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.flexslider.js"></script>
        <script src="${pageContext.request.contextPath}/js/chosen.jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
    </body>
</html>
