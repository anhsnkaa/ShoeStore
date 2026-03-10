<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="site-footer">
    <div class="site-footer-top">
        <div class="container">
            <div class="row align-items-start">
                <div class="col-lg-5 col-md-12 mb-4 mb-lg-0">
                    <div class="site-footer-brand-block">
                        <a class="site-footer-brand" href="${pageContext.request.contextPath}/home">ShoeStore</a>
                        <p class="site-footer-copy">
                            Curated footwear with a clean everyday aesthetic, built for comfort,
                            movement, and a wardrobe that feels easy to wear.
                        </p>
                        <div class="site-footer-tags">
                            <span>Minimal</span>
                            <span>Comfort</span>
                            <span>Everyday Wear</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6 mb-4 mb-lg-0">
                    <div class="site-footer-column">
                        <h3>Explore</h3>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/home?search=gender&gender=MEN#products-section">Men</a></li>
                            <li><a href="${pageContext.request.contextPath}/home?search=gender&gender=WOMEN#products-section">Women</a></li>
                            <li><a href="${pageContext.request.contextPath}/home?search=sale#products-section">Sale</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6 mb-4 mb-lg-0">
                    <div class="site-footer-column">
                        <h3>Support</h3>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/payment">Cart</a></li>
                            <li><a href="${pageContext.request.contextPath}/authen?action=login">Sign In</a></li>
                            <li><a href="${pageContext.request.contextPath}/authen?action=sign-up">Create Account</a></li>
                            <li><a href="${pageContext.request.contextPath}/home?search=hot#products-section">Hot Items</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-12">
                    <div class="site-footer-contact-card">
                        <h3>Contact</h3>
                        <p>FPT University, Hoa Lac, Hanoi</p>
                        <p><a href="tel:0123456789">0123 456 789</a></p>
                        <p><a href="mailto:shoestore.team@example.com">shoestore.team@example.com</a></p>
                        <div class="site-footer-socials">
                            <a href="#" aria-label="Facebook"><i class="fa fa-facebook"></i></a>
                            <a href="#" aria-label="Instagram"><i class="fa fa-instagram"></i></a>
                            <a href="#" aria-label="Pinterest"><i class="fa fa-pinterest-p"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="site-footer-bottom">
        <div class="container">
            <div class="site-footer-bottom-inner">
                <p>2026 ShoeStore. Clean essentials for daily rotation.</p>
                <div class="site-footer-payments">
                    <span>Visa</span>
                    <span>Mastercard</span>
                    <span>COD</span>
                </div>
            </div>
        </div>
    </div>
</footer>
