<%-- 
    Document   : sign-up
    Created on : Mar 1, 2026, 3:28:20 AM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">


    <!-- Mirrored from htmldemo.net/koparion/koparion/register.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:57 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>ShoeStore</title>
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

    <body class="register">
        <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!-- Add your site or application content here -->
        <!-- header-area-start -->
        <%
            request.setAttribute("minimalHeader", Boolean.TRUE);
            request.setAttribute("authHeaderLabel", "Sign in");
            request.setAttribute("authHeaderHref", request.getContextPath() + "/authen?action=login");
        %>
        <jsp:include page="../common/homePage/header.jsp"></jsp:include>
            <!-- header-area-end -->
            <!-- breadcrumbs-area-start -->
        <jsp:include page="../common/homePage/breadcrumbs-area.jsp"></jsp:include>
            <!-- breadcrumbs-area-end -->
            <!-- user-login-area-start -->
            <div class="user-login-area auth-page-section mb-70">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="login-title auth-page-title text-center mb-30">
                                <h2>Create Account</h2>
                                <p>Create your ShoeStore account to save favorites, manage orders, and checkout faster.</p>
                            </div>
                        </div>
                        <div class="col-lg-8 col-md-10 col-12 auth-card-column">
                            <div class="login-form auth-card auth-card-wide">
                                <form action="${pageContext.request.contextPath}/authen?action=sign-up" method="POST">
                                    <c:if test="${not empty error}">
                                        <div class="auth-message error">${error}</div>
                                    </c:if>
                                    <div class="row auth-grid-row">
                                        <div class="col-lg-6 col-md-6 col-12">
                                            <div class="single-login auth-field">
                                                <label>Full Name<span>*</span></label>
                                                <input type="text" name="fullName" required />
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-12">
                                            <div class="single-login auth-field">
                                                <label>Username<span>*</span></label>
                                                <input type="text" name="username" required />
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-12">
                                            <div class="single-login auth-field">
                                                <label>Email<span>*</span></label>
                                                <input type="email" name="email" required />
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-12">
                                            <div class="single-login auth-field">
                                                <label>Phone<span>*</span></label>
                                                <input type="text" name="phone" required />
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="single-login auth-field">
                                                <label>Address<span>*</span></label>
                                                <input type="text" name="address" required />
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="single-login auth-field">
                                                <label>Password<span>*</span></label>
                                                <input type="password" name="password" required />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="single-login auth-submit-row">
                                        <input type="submit" value="Create account" class="btn btn-primary">
                                    </div>
                                </form>
                                <div class="auth-alt-link">
                                    <span>Already have an account?</span>
                                    <a href="${pageContext.request.contextPath}/authen?action=login">Sign in</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- user-login-area-end -->


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


    <!-- Mirrored from htmldemo.net/koparion/koparion/register.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:57 GMT -->
</html>
