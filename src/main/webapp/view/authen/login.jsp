<%-- 
    Document   : login
    Created on : Feb 28, 2026, 7:31:11 PM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <!-- Mirrored from htmldemo.net/koparion/koparion/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:39 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Koparion – Book Shop HTML5 Template</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.png">

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
    <body class="login">
        <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!-- Add your site or application content here -->
        <!-- header-area-start -->
        <%
            request.setAttribute("minimalHeader", Boolean.TRUE);
            request.setAttribute("authHeaderLabel", "Sign up");
            request.setAttribute("authHeaderHref", request.getContextPath() + "/authen?action=sign-up");
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
                                <h2>Login</h2>
                                <p>Welcome back. Sign in to continue shopping, check your cart, and manage your orders.</p>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-10 col-12 auth-card-column">
                            <div class="login-form auth-card">
                                <form action="${pageContext.request.contextPath}/authen?action=login" method="POST">
                                    <c:if test="${not empty error}">
                                        <div class="auth-message error">${error}</div>
                                    </c:if>
                                    <c:if test="${not empty message}">
                                        <div class="auth-message success">${message}</div>
                                    </c:if>
                                    <div class="single-login auth-field">
                                        <label>Username or email<span>*</span></label>
                                        <input type="text" name="username"/>
                                    </div>
                                    <div class="single-login auth-field">
                                        <label>Password <span>*</span></label>
                                        <input type="password" name="password"/>
                                    </div>
                                    <div class="single-login auth-meta-row">
                                        <label class="auth-checkbox">
                                            <input id="rememberme" type="checkbox" name="rememberme" value="forever">
                                            <span>Remember me</span>
                                        </label>
                                        <a class="auth-text-link" href="${pageContext.request.contextPath}/authen?action=forgot-password">Forgot password?</a>
                                    </div>
                                    <div class="single-login auth-submit-row">
                                        <input type="submit" value="Login"></input>
                                    </div>
                                </form>
                                <div class="auth-alt-link">
                                    <span>New to ShoeStore?</span>
                                    <a href="${pageContext.request.contextPath}/authen?action=sign-up">Create an account</a>
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

    <!-- Mirrored from htmldemo.net/koparion/koparion/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:39 GMT -->
</html>
