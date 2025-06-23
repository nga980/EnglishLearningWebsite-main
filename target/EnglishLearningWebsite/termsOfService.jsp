<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điều Khoản Dịch Vụ - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <%-- Sử dụng đường dẫn tuyệt đối để include header --%>
    <jsp:include page="/common/header.jsp"/>
    
    <!-- Custom CSS cho trang điều khoản -->
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #f8fafc;
            --text-color: #334155;
            --border-color: #e2e8f0;
            --accent-color: #3b82f6;
        }

        .terms-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }

        .terms-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .terms-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            padding: 3rem 2rem 2rem;
            position: relative;
            overflow: hidden;
        }

        .terms-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .terms-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 2;
        }

        .terms-header .update-date {
            font-size: 1rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .terms-content {
            padding: 2.5rem;
            line-height: 1.8;
            color: var(--text-color);
        }

        .terms-section {
            margin-bottom: 2.5rem;
            padding: 1.5rem;
            border-left: 4px solid var(--primary-color);
            background: var(--secondary-color);
            border-radius: 0 10px 10px 0;
            transition: all 0.3s ease;
            position: relative;
        }

        .terms-section:hover {
            transform: translateX(5px);
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.1);
        }

        .terms-section h2 {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .terms-section h2::before {
            content: '';
            width: 8px;
            height: 8px;
            background: var(--primary-color);
            border-radius: 50%;
            display: inline-block;
        }

        .terms-section p {
            font-size: 1rem;
            line-height: 1.7;
            margin: 0;
            text-align: justify;
        }

        .highlight-box {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #f59e0b;
            border-radius: 12px;
            padding: 1.5rem;
            margin: 2rem 0;
            position: relative;
        }

        .highlight-box::before {
            content: '⚠️';
            font-size: 1.5rem;
            position: absolute;
            top: -10px;
            left: 20px;
            background: #fbbf24;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .highlight-box h3 {
            color: #92400e;
            font-weight: 600;
            margin-bottom: 0.5rem;
            margin-top: 0.5rem;
        }

        .highlight-box p {
            color: #78350f;
            margin: 0;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .terms-container {
                padding: 1rem 0;
            }
            
            .terms-content {
                padding: 1.5rem;
            }
            
            .terms-header {
                padding: 2rem 1.5rem 1.5rem;
            }
            
            .terms-header h1 {
                font-size: 2rem;
            }
            
            .terms-section {
                padding: 1rem;
                margin-bottom: 1.5rem;
            }
        }

        /* Smooth scroll behavior */
        html {
            scroll-behavior: smooth;
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f5f9;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--accent-color);
        }
    </style>
</head>
<body>
    <div class="terms-container">
        <div class="container">
            <div class="terms-card">
                <!-- Header Section -->
                <div class="terms-header">
                    <h1>Điều Khoản Dịch Vụ</h1>
                    <p class="update-date">📅 Cập nhật lần cuối: 21 tháng 6, 2025</p>
                </div>

                <!-- Content Section -->
                <div class="terms-content">
                    <!-- Important Notice -->
                    <div class="highlight-box">
                        <h3>Thông Báo Quan Trọng</h3>
                        <p>Vui lòng đọc kỹ các điều khoản này trước khi sử dụng dịch vụ. Việc tiếp tục sử dụng đồng nghĩa với việc bạn đã chấp nhận toàn bộ điều khoản.</p>
                    </div>

                    <!-- Terms Sections -->
                    <div class="terms-section">
                        <h2>1. Chấp Nhận Điều Khoản</h2>
                        <p>Bằng việc truy cập và sử dụng trang web English Learning, bạn đồng ý tuân thủ các điều khoản và điều kiện này. Nếu bạn không đồng ý với bất kỳ phần nào của các điều khoản này, vui lòng không sử dụng trang web của chúng tôi. Các điều khoản này có hiệu lực ngay khi bạn bắt đầu sử dụng dịch vụ.</p>
                    </div>

                    <div class="terms-section">
                        <h2>2. Sử Dụng Tài Khoản</h2>
                        <p>Bạn chịu trách nhiệm hoàn toàn trong việc bảo mật thông tin tài khoản của mình, bao gồm tên đăng nhập và mật khẩu. Bạn cam kết chịu trách nhiệm cho tất cả các hoạt động xảy ra dưới tài khoản của bạn. Trong trường hợp phát hiện có hành vi sử dụng trái phép tài khoản, bạn có nghĩa vụ thông báo ngay lập tức cho chúng tôi để được hỗ trợ kịp thời.</p>
                    </div>

                    <div class="terms-section">
                        <h2>3. Nội Dung Người Dùng</h2>
                        <p>Người dùng cam kết không đăng tải bất kỳ nội dung nào vi phạm pháp luật, có tính chất bôi nhọ, xúc phạm, hoặc gây tổn hại đến danh tiếng của cá nhân, tổ chức khác. Chúng tôi có quyền xem xét, chỉnh sửa hoặc xóa bỏ bất kỳ nội dung nào mà chúng tôi cho rằng vi phạm các điều khoản này mà không cần thông báo trước.</p>
                    </div>

                    <div class="terms-section">
                        <h2>4. Quyền Sở Hữu Trí Tuệ</h2>
                        <p>Toàn bộ nội dung hiển thị trên trang web này, bao gồm nhưng không giới hạn ở các bài học, câu hỏi, hình ảnh, video, thiết kế giao diện, và mã nguồn, đều là tài sản độc quyền của English Learning. Mọi nội dung này được bảo vệ nghiêm ngặt bởi luật sở hữu trí tuệ và bản quyền. Việc sao chép, phân phối hoặc sử dụng không được phép là vi phạm pháp luật.</p>
                    </div>

                    <div class="terms-section">
                        <h2>5. Giới Hạn Trách Nhiệm</h2>
                        <p>English Learning không chịu trách nhiệm đối với bất kỳ thiệt hại trực tiếp, gián tiếp, ngẫu nhiên, đặc biệt hoặc mang tính hậu quả nào phát sinh từ việc sử dụng hoặc không thể sử dụng dịch vụ của chúng tôi. Điều này bao gồm nhưng không giới hạn ở việc mất dữ liệu, gián đoạn hoạt động kinh doanh, hoặc bất kỳ tổn thất thương mại nào khác.</p>
                    </div>

                    <div class="terms-section">
                        <h2>6. Thay Đổi Điều Khoản</h2>
                        <p>Chúng tôi có quyền cập nhật và thay đổi các điều khoản này bất kỳ lúc nào để phù hợp với sự phát triển của dịch vụ và tuân thủ các quy định pháp luật hiện hành. Mọi thay đổi sẽ được thông báo trên trang web và có hiệu lực ngay sau khi được đăng tải. Việc tiếp tục sử dụng dịch vụ sau các thay đổi đồng nghĩa với việc bạn chấp nhận các điều khoản mới.</p>
                    </div>

                    <div class="terms-section">
                        <h2>7. Liên Hệ</h2>
                        <p>Nếu bạn có bất kỳ câu hỏi nào về các điều khoản này hoặc cần hỗ trợ, vui lòng liên hệ với chúng tôi qua email: <strong>support@englishlearning.com</strong> hoặc số điện thoại: <strong>(+84) 123-456-789</strong>. Đội ngũ hỗ trợ khách hàng của chúng tôi sẽ phản hồi trong vòng 24 giờ làm việc.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Sử dụng đường dẫn tuyệt đối để include footer --%>
    <jsp:include page="/common/footer.jsp"/>

    <!-- Smooth scroll script -->
    <script>
        // Add smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Add fade-in animation on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all terms sections
        document.querySelectorAll('.terms-section').forEach(section => {
            section.style.opacity = '0';
            section.style.transform = 'translateY(20px)';
            section.style.transition = 'all 0.6s ease';
            observer.observe(section);
        });
    </script>
</body>
</html>