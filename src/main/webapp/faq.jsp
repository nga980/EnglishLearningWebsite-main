<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Câu Hỏi Thường Gặp (FAQ) - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Main content area */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* Footer positioning */
        .footer {
            margin-top: auto;
        }

        .faq-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
        }

        .faq-title {
            color: #2c3e50;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
            font-size: 2.5rem;
        }

        .faq-title::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #007bff, #28a745, #ffc107);
            border-radius: 2px;
        }

        .faq-title i {
            margin-right: 0.5rem;
            color: #007bff;
        }

        .faq-intro {
            text-align: center;
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
            padding: 0 1rem;
        }

        .custom-accordion {
            border: none;
        }

        .custom-accordion-item {
            border: none;
            margin-bottom: 1rem;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .custom-accordion-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .custom-accordion-header {
            margin-bottom: 0;
        }

        .custom-accordion-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            width: 100%;
            text-align: left;
            cursor: pointer;
        }

        .custom-accordion-button:not(.collapsed) {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            box-shadow: none;
        }

        .custom-accordion-button:focus {
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
            border: none;
            outline: none;
        }

        .custom-accordion-button::after {
            content: '\f107';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            font-size: 1.2rem;
            transition: transform 0.3s ease;
            float: right;
            margin-top: 2px;
        }

        .custom-accordion-button:not(.collapsed)::after {
            transform: rotate(180deg);
        }

        .custom-accordion-button .question-icon {
            margin-right: 0.75rem;
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .custom-accordion-body {
            padding: 1.5rem;
            background: #f8f9fa;
            color: #495057;
            font-size: 1rem;
            line-height: 1.6;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .answer-content {
            position: relative;
            padding-left: 2rem;
        }

        .answer-content::before {
            content: '\f0da';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            left: 0;
            top: 0;
            color: #007bff;
            font-size: 1.1rem;
        }

        /* Different colors for each FAQ item */
        .faq-item-1 .custom-accordion-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .faq-item-1 .custom-accordion-button:not(.collapsed) {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .faq-item-2 .custom-accordion-button {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .faq-item-2 .custom-accordion-button:not(.collapsed) {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
        }

        .faq-item-3 .custom-accordion-button {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #2c3e50;
        }

        .faq-item-3 .custom-accordion-button:not(.collapsed) {
            background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%);
            color: #2c3e50;
        }

        /* Contact section */
        .contact-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-top: 2rem;
            text-align: center;
        }

        .contact-section h4 {
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .contact-section p {
            margin-bottom: 1.5rem;
            opacity: 0.9;
        }

        .contact-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .contact-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container-fluid {
                max-width: 95%;
            }
        }

        @media (max-width: 992px) {
            .faq-container {
                margin: 1.5rem;
                padding: 2rem;
            }
            
            .faq-title {
                font-size: 2.2rem;
            }
        }

        @media (max-width: 768px) {
            .faq-container {
                margin: 1rem;
                padding: 1.5rem;
                border-radius: 10px;
            }
            
            .faq-title {
                font-size: 1.8rem;
                margin-bottom: 1.5rem;
            }
            
            .faq-title::after {
                width: 80px;
                height: 3px;
                bottom: -10px;
            }
            
            .faq-intro {
                font-size: 1rem;
                margin-bottom: 2rem;
            }
            
            .custom-accordion-button {
                padding: 1rem 1.25rem;
                font-size: 1rem;
            }
            
            .custom-accordion-body {
                padding: 1.25rem;
            }
            
            .answer-content {
                padding-left: 1.5rem;
            }
            
            .contact-section {
                padding: 1.5rem;
                margin-top: 1.5rem;
            }
        }

        @media (max-width: 576px) {
            body {
                font-size: 14px;
            }
            
            .faq-container {
                margin: 0.5rem;
                padding: 1.2rem;
                border-radius: 8px;
            }
            
            .faq-title {
                font-size: 1.6rem;
                line-height: 1.3;
            }
            
            .faq-title::after {
                width: 60px;
                height: 2px;
            }
            
            .faq-intro {
                font-size: 0.95rem;
                margin-bottom: 1.5rem;
                padding: 0;
            }
            
            .custom-accordion-item {
                margin-bottom: 0.8rem;
                border-radius: 8px;
            }
            
            .custom-accordion-button {
                padding: 0.9rem 1rem;
                font-size: 0.95rem;
                line-height: 1.4;
            }
            
            .custom-accordion-button .question-icon {
                margin-right: 0.5rem;
                font-size: 1rem;
            }
            
            .custom-accordion-button::after {
                font-size: 1rem;
            }
            
            .custom-accordion-body {
                padding: 1rem;
                font-size: 0.9rem;
            }
            
            .answer-content {
                padding-left: 1.2rem;
            }
            
            .answer-content::before {
                font-size: 1rem;
            }
            
            .contact-section {
                padding: 1.2rem;
                margin-top: 1.2rem;
            }
            
            .contact-section h4 {
                font-size: 1.1rem;
            }
            
            .contact-btn {
                padding: 0.6rem 1.5rem;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 400px) {
            .faq-container {
                margin: 0.25rem;
                padding: 1rem;
            }
            
            .faq-title {
                font-size: 1.4rem;
            }
            
            .custom-accordion-button {
                padding: 0.8rem;
                font-size: 0.9rem;
            }
            
            .custom-accordion-body {
                padding: 0.8rem;
                font-size: 0.85rem;
            }
            
            .contact-section {
                padding: 1rem;
            }
        }

        /* Animation for smooth transitions */
        .custom-accordion-collapse {
            transition: all 0.3s ease;
        }

        /* Loading animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .custom-accordion-item {
            animation: fadeInUp 0.6s ease forwards;
        }

        .custom-accordion-item:nth-child(2) {
            animation-delay: 0.1s;
        }

        .custom-accordion-item:nth-child(3) {
            animation-delay: 0.2s;
        }

        .contact-section {
            animation: fadeInUp 0.6s ease 0.3s forwards;
            opacity: 0;
        }
    </style>
    <%-- Include header --%>
    <jsp:include page="/common/header.jsp"/>
</head>
<body>
    <div class="main-content">
        <div class="container-fluid px-2 px-md-3">
            <div class="row justify-content-center">
                <div class="col-12 col-lg-10 col-xl-8">
                    <div class="faq-container">
                        <h1 class="faq-title">
                            <i class="fas fa-question-circle"></i>
                            Câu Hỏi Thường Gặp
                        </h1>
                        
                        <div class="faq-intro">
                            Tìm hiểu các câu hỏi phổ biến và câu trả lời hữu ích về English Learning
                        </div>

                        <div class="accordion custom-accordion" id="faqAccordion">
                            <div class="accordion-item custom-accordion-item faq-item-1">
                                <h2 class="accordion-header custom-accordion-header" id="headingOne">
                                    <button class="accordion-button custom-accordion-button" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        <i class="fas fa-user-plus question-icon"></i>
                                        Làm thế nào để đăng ký tài khoản?
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse show custom-accordion-collapse" aria-labelledby="headingOne" data-parent="#faqAccordion">
                                    <div class="accordion-body custom-accordion-body">
                                        <div class="answer-content">
                                            Bạn có thể đăng ký tài khoản bằng cách nhấp vào nút "Đăng ký" ở góc trên bên phải màn hình và điền vào các thông tin cần thiết như email, tên đăng nhập và mật khẩu. Quá trình đăng ký chỉ mất vài phút và hoàn toàn miễn phí.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item custom-accordion-item faq-item-2">
                                <h2 class="accordion-header custom-accordion-header" id="headingTwo">
                                    <button class="accordion-button custom-accordion-button collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        <i class="fas fa-key question-icon"></i>
                                        Làm thế nào để lấy lại mật khẩu?
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse custom-accordion-collapse" aria-labelledby="headingTwo" data-parent="#faqAccordion">
                                    <div class="accordion-body custom-accordion-body">
                                        <div class="answer-content">
                                            Nếu bạn đã truy cập trang quên mật khẩu nhưng vẫn không thể lấy lại mật khẩu của mình vui lòng liên hệ với quản trị viên qua email hoặc số điện thoại hỗ trợ để được hỗ trợ đặt lại mật khẩu. Chúng tôi sẽ xử lý yêu cầu của bạn trong vòng 24 giờ.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item custom-accordion-item faq-item-3">
                                <h2 class="accordion-header custom-accordion-header" id="headingThree">
                                    <button class="accordion-button custom-accordion-button collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        <i class="fas fa-dollar-sign question-icon"></i>
                                        Trang web này có miễn phí không?
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse custom-accordion-collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                                    <div class="accordion-body custom-accordion-body">
                                        <div class="answer-content">
                                            Có, tất cả các chức năng và nội dung học tập trên trang web hiện tại đều hoàn toàn miễn phí. Bạn có thể truy cập các bài học, từ vựng, ngữ pháp và làm bài tập mà không cần trả bất kỳ khoản phí nào. Chúng tôi cam kết mang đến giáo dục chất lượng cho mọi người.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="contact-section">
                            <h4><i class="fas fa-headset"></i> Cần hỗ trợ thêm?</h4>
                            <p>Nếu bạn không tìm thấy câu trả lời cho câu hỏi của mình, đừng ngại liên hệ với chúng tôi!</p>
                            <a href="mailto:contact@englishlearning.com" class="contact-btn">
                                <i class="fas fa-envelope"></i> Liên hệ ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="mt-auto">
        <jsp:include page="/common/footer.jsp"/>
    </footer>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>