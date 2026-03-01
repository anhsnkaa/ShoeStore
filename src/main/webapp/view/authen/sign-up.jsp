<%-- 
    Document   : sign-up
    Created on : Mar 1, 2026, 3:28:20 AM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">


    <!-- Mirrored from htmldemo.net/koparion/koparion/register.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 23 Feb 2024 17:30:57 GMT -->
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
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
        <jsp:include page="../common/homePage/header.jsp"></jsp:include>
            <!-- header-area-end -->
            <!-- breadcrumbs-area-start -->
        <jsp:include page="../common/homePage/breadcrumbs-area.jsp"></jsp:include>
            <!-- breadcrumbs-area-end -->
            <!-- user-login-area-start -->
            <div class="user-login-area mb-70">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="login-title text-center mb-30">
                                <h2>Sign Up</h2>
                                <p>doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo<br>inventore veritatis et quasi architecto beat</p>
                            </div>
                        </div>
                        <div class="offset-lg-2 col-lg-8 col-md-12 col-12">
                            <div class="billing-fields">

                                <form action="authen?action=sign-up" method="POST">
                                    <div class="offset-lg-2 col-lg-8 col-md-12 col-12">
                                        <div class="billing-fields">
                                            <!-- Error Message -->
                                            <div class="text-center mt-2">
                                                <span style="color:red">${error}</span>
                                        </div>
                                        <div class="row">

                                            <!-- Full Name -->
                                            <div class="col-lg-6 col-md-6 col-12">
                                                <div class="single-register">
                                                    <label>Full Name<span>*</span></label>
                                                    <input type="text" name="fullName" required />
                                                </div>
                                            </div>

                                            <!-- Username -->
                                            <div class="col-lg-6 col-md-6 col-12">
                                                <div class="single-register">
                                                    <label>Username<span>*</span></label>
                                                    <input type="text" name="username" required />
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row">

                                            <!-- Email -->
                                            <div class="col-lg-6 col-md-6 col-12">
                                                <div class="single-register">
                                                    <label>Email<span>*</span></label>
                                                    <input type="email" name="email" required />
                                                </div>
                                            </div>

                                            <!-- Phone -->
                                            <div class="col-lg-6 col-md-6 col-12">
                                                <div class="single-register">
                                                    <label>Phone<span>*</span></label>
                                                    <input type="text" name="phone" required />
                                                </div>
                                            </div>

                                        </div>

                                        <!-- Address -->
                                        <div class="single-register">
                                            <label>Address<span>*</span></label>
                                            <input type="text" name="address" required />
                                        </div>

                                        <!-- Password -->
                                        <div class="single-register">
                                            <label>Password<span>*</span></label>
                                            <input type="password" name="password" required />
                                        </div>
                                        <!-- Submit Button -->
                                        <div class="single-register text-center">
                                            <input type="submit" value="Register"
                                                   class="btn btn-primary">
                                        </div>



                                    </div>

                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- user-login-area-end -->
            <!-- footer-area-start -->
            <jsp:include page="../common/homePage/footer.jsp"></jsp:include>
                <!-- footer-area-end -->


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