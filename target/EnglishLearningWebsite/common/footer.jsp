<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">


<style>
    .footer-horizontal {
        background-color: #2c3e50;
        color: #bdc3c7;
        padding-top: 2.5rem;
        padding-bottom: 0.5rem;
        font-size: 0.9rem;
        border-top: 3px solid #667eea;
    }

    .footer-horizontal .footer-col {
        margin-bottom: 2rem;
    }

    .footer-horizontal .footer-brand {
        font-weight: 700;
        font-size: 1.4rem;
        color: #ffffff;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        margin-bottom: 0.5rem;
    }

    .footer-horizontal .footer-brand i {
        color: #667eea;
        margin-right: 0.5rem;
    }

    .footer-horizontal p.about-text {
        color: #95a5a6;
        font-size: 0.85rem;
        margin-bottom: 1rem;
    }

    .footer-horizontal h5 {
        color: #ffffff;
        font-weight: 600;
        margin-bottom: 1rem;
        font-size: 1rem;
        text-transform: uppercase;
    }

    .footer-horizontal .footer-links {
        list-style: none;
        padding-left: 0;
    }

    .footer-horizontal .footer-links li {
        margin-bottom: 0.6rem;
    }

    .footer-horizontal .footer-links a {
        color: #bdc3c7;
        text-decoration: none;
        transition: all 0.2s ease-in-out;
        display: flex;
        align-items: center;
    }

    .footer-horizontal .footer-links a:hover {
        color: #ffffff;
        transform: translateX(3px);
    }

    .footer-horizontal .footer-links .link-icon {
        width: 20px;
        margin-right: 0.5rem;
        color: #667eea;
    }

    .footer-horizontal .social-icons a {
        display: inline-flex;
        justify-content: center;
        align-items: center;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.1);
        color: #ffffff;
        text-decoration: none;
        margin-right: 0.5rem;
        transition: all 0.3s ease;
        font-size: 1.2rem;
    }

    .footer-horizontal .social-icons a:hover {
        background-color: #667eea;
        transform: translateY(-2px);
    }

    .footer-horizontal .footer-bottom {
        border-top: 1px solid #34495e;
        padding: 1rem 0;
        margin-top: 1.5rem;
        text-align: center;
        font-size: 0.85rem;
        color: #7f8c8d;
    }

    /* Custom flex layout for footer links on larger screens */
    @media (min-width: 768px) {
        .footer-horizontal .footer-links-row {
            display: flex;
            justify-content: space-between;
        }

        .footer-horizontal .footer-col {
            flex: 1;
            padding: 0 1rem;
        }
    }
</style>

<footer class="footer-horizontal">
    <div class="container">
        <div class="row">
            <!-- Cột 1: Giới thiệu -->
            <div class="col-lg-3 col-md-12 footer-col">
                <a class="footer-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-graduation-cap"></i>
                    <span>English Learning</span>
                </a>
                <p class="about-text">Nền tảng nâng cao kỹ năng tiếng Anh mỗi ngày.</p>
                <div class="social-icons">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                </div>
            </div>

            <!-- Cột 2,3,4 gom thành hàng ngang -->
            <div class="col-lg-9 col-md-12">
                <div class="footer-links-row">
                    <!-- Liên kết -->
                    <div class="footer-col">
                        <h5>Liên kết</h5>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home link-icon"></i>Trang Chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/lessons"><i class="fas fa-book-open link-icon"></i>Bài Học</a></li>
                            <li><a href="${pageContext.request.contextPath}/vocabulary"><i class="fas fa-spell-check link-icon"></i>Từ Vựng</a></li>
                            <li><a href="${pageContext.request.contextPath}/grammar"><i class="fas fa-language link-icon"></i>Ngữ Pháp</a></li>
                        </ul>
                    </div>

                    <!-- Hỗ trợ -->
                    <div class="footer-col">
                        <h5>Hỗ trợ</h5>
                        <ul class="footer-links">
                            <li><a href="#"><i class="fas fa-question-circle link-icon"></i>FAQ</a></li>
                            <li><a href="#"><i class="fas fa-shield-alt link-icon"></i>Chính sách bảo mật</a></li>
                            <li><a href="#"><i class="fas fa-file-contract link-icon"></i>Điều khoản dịch vụ</a></li>
                        </ul>
                    </div>

                    <!-- Liên hệ -->
                    <div class="footer-col">
                        <h5>Liên hệ</h5>
                        <ul class="footer-links">
                            <li><a href="#"><i class="fas fa-map-marker-alt link-icon"></i>Hà Nội, Việt Nam</a></li>
                            <li><a href="mailto:contact@english.com"><i class="fas fa-envelope link-icon"></i>contact@english.com</a></li>
                            <li><a href="tel:+84123456789"><i class="fas fa-phone link-icon"></i>+84 123 456 789</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <i class="far fa-copyright"></i> <%= new java.util.Date().getYear() + 1900 %> English Learning. All Rights Reserved.
        </div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
