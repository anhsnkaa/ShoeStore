<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Forgot Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.png">
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
    <body class="login">
        <%
            request.setAttribute("minimalHeader", Boolean.TRUE);
            request.setAttribute("authHeaderLabel", "Sign in");
            request.setAttribute("authHeaderHref", request.getContextPath() + "/authen?action=login");
        %>
        <jsp:include page="../common/homePage/header.jsp"></jsp:include>
        <jsp:include page="../common/homePage/breadcrumbs-area.jsp"></jsp:include>

        <div class="user-login-area auth-page-section mb-70">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                        <div class="login-title auth-page-title text-center mb-30">
                            <h2>Reset Password</h2>
                            <p>Enter your account details below and choose a new password for your ShoeStore account.</p>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-10 col-12 auth-card-column">
                        <div class="login-form auth-card">
                            <form action="${pageContext.request.contextPath}/authen?action=forgot-password" method="POST">
                                <c:if test="${not empty error}">
                                    <div class="auth-message error">${error}</div>
                                </c:if>
                                <div class="single-login auth-field">
                                    <label>Username <span>*</span></label>
                                    <input type="text" name="username" required />
                                </div>
                                <div class="single-login auth-field">
                                    <label>Email <span>*</span></label>
                                    <input type="email" name="email" required />
                                </div>
                                <div class="single-login auth-field">
                                    <label>New Password <span>*</span></label>
                                    <input type="password" name="newPassword" required />
                                </div>
                                <div class="single-login auth-field">
                                    <label>Confirm Password <span>*</span></label>
                                    <input type="password" name="confirmPassword" required />
                                </div>
                                <div class="single-login auth-submit-row">
                                    <input type="submit" value="Reset Password" />
                                </div>
                            </form>
                            <div class="auth-alt-link">
                                <span>Remember your password?</span>
                                <a href="${pageContext.request.contextPath}/authen?action=login">Back to Sign in</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/homePage/footer.jsp"></jsp:include>

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
