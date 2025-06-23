<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chính Sách Bảo Mật - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            color: #333;
            line-height: 1.7;
        }

        .privacy-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            margin: 3rem auto;
            max-width: 900px;
            overflow: hidden;
            position: relative;
        }

        .privacy-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .privacy-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .privacy-title {
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .privacy-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .shield-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .privacy-content {
            padding: 3rem 2.5rem;
        }

        .section {
            margin-bottom: 2.5rem;
            padding: 1.5rem;
            border-radius: 15px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2px;
        }

        .section:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.15);
        }

        .section-title {
            color: #2c3e50;
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .section-content {
            color: #495057;
            font-size: 1rem;
            line-height: 1.7;
        }

        .info-list {
            list-style: none;
            padding: 0;
            margin: 1rem 0;
        }

        .info-list li {
            padding: 0.8rem 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            display: flex;
            align-items: flex-start;
            gap: 1rem;
        }

        .info-list li:last-child {
            border-bottom: none;
        }

        .list-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
            flex-shrink: 0;
            margin-top: 0.2rem;
        }

        .update-badge {
            background: linear-gradient(135deg, #17a2b8 0%, #007bff 100%);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
        }

        .highlight-box {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeeba 100%);
            border: 1px solid #ffeaa7;
            border-radius: 12px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            position: relative;
        }

        .highlight-box::before {
            content: '\f06a';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            top: -10px;
            left: 20px;
            background: #ffc107;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .contact-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2.5rem;
            margin: 2rem -2.5rem -3rem;
            text-align: center;
        }

        .contact-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .contact-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 1rem;
        }

        .contact-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .privacy-container {
                margin: 1rem;
                border-radius: 15px;
            }
            
            .privacy-header {
                padding: 2rem 1.5rem 1.5rem;
            }
            
            .privacy-title {
                font-size: 2.2rem;
            }
            
            .shield-icon {
                font-size: 3rem;
            }
            
            .privacy-content {
                padding: 2rem 1.5rem;
            }
            
            .section {
                padding: 1.2rem;
                margin-bottom: 1.5rem;
            }
            
            .section-title {
                font-size: 1.2rem;
            }
            
            .contact-section {
                margin: 1.5rem -1.5rem -2rem;
                padding: 2rem 1.5rem;
            }
        }

        @media (max-width: 576px) {
            .privacy-title {
                font-size: 1.8rem;
            }
            
            .privacy-content {
                padding: 1.5rem 1rem;
            }
            
            .section {
                padding: 1rem;
            }
            
            .info-list li {
                flex-direction: column;
                gap: 0.5rem;
                align-items: flex-start;
            }
            
            .list-icon {
                align-self: flex-start;
            }
        }

        /* Animation for sections */
        .section {
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.6s ease forwards;
        }

        .section:nth-child(1) { animation-delay: 0.1s; }
        .section:nth-child(2) { animation-delay: 0.2s; }
        .section:nth-child(3) { animation-delay: 0.3s; }
        .section:nth-child(4) { animation-delay: 0.4s; }
        .section:nth-child(5) { animation-delay: 0.5s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    <%-- Include header --%>
    <jsp:include page="/common/header.jsp"/>
</head>
<body>
    <div class="container-fluid px-2">
        <div class="privacy-container">
            <div class="privacy-header">
                <i class="fas fa-shield-alt shield-icon"></i>
                <h1 class="privacy-title">Chính Sách Bảo Mật</h1>
                <p class="privacy-subtitle">Cam kết bảo vệ thông tin cá nhân của bạn</p>
            </div>

            <div class="privacy-content">
                <div class="update-badge">
                    <i class="fas fa-calendar-alt"></i> Cập nhật lần cuối: 21 tháng 6, 2025
                </div>

                <div class="section">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        Giới thiệu
                    </h2>
                    <div class="section-content">
                        <p>Chào mừng bạn đến với <strong>English Learning</strong>. Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn và tôn trọng quyền riêng tư của bạn. Chính sách bảo mật này giải thích cách chúng tôi thu thập, sử dụng, lưu trữ và bảo vệ thông tin của bạn khi sử dụng dịch vụ của chúng tôi.</p>
                        
                        <div class="highlight-box">
                            <p class="mb-0"><strong>Lưu ý quan trọng:</strong> Bằng cách sử dụng trang web của chúng tôi, bạn đồng ý với các điều khoản trong chính sách bảo mật này.</p>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-database"></i>
                        </div>
                        Thông tin chúng tôi thu thập
                    </h2>
                    <div class="section-content">
                        <p>Chúng tôi thu thập các loại thông tin sau khi bạn đăng ký và sử dụng dịch vụ của chúng tôi:</p>
                        
                        <ul class="info-list">
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div>
                                    <strong>Thông tin cá nhân:</strong> Bao gồm tên đầy đủ, địa chỉ email, tên đăng nhập và mật khẩu (được mã hóa bảo mật). Chúng tôi không bao giờ lưu trữ mật khẩu dưới dạng văn bản thuần túy.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div>
                                    <strong>Dữ liệu học tập:</strong> Lịch sử làm bài kiểm tra, điểm số, tiến độ học tập, thời gian học và các hoạt động trên trang web để cải thiện trải nghiệm học tập của bạn.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-desktop"></i>
                                </div>
                                <div>
                                    <strong>Thông tin kỹ thuật:</strong> Địa chỉ IP, loại trình duyệt, hệ điều hành và thông tin thiết bị để tối ưu hóa hiệu suất trang web.
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="section">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-cogs"></i>
                        </div>
                        Cách chúng tôi sử dụng thông tin
                    </h2>
                    <div class="section-content">
                        <p>Thông tin của bạn được sử dụng một cách có trách nhiệm cho các mục đích sau:</p>
                        
                        <ul class="info-list">
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-play"></i>
                                </div>
                                <div>
                                    <strong>Cung cấp dịch vụ:</strong> Duy trì và vận hành trang web, cung cấp nội dung học tập và các tính năng tương tác.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-user-cog"></i>
                                </div>
                                <div>
                                    <strong>Cá nhân hóa trải nghiệm:</strong> Tùy chỉnh nội dung học tập phù hợp với trình độ và sở thích của bạn.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div>
                                    <strong>Liên lạc:</strong> Gửi thông báo về tài khoản, cập nhật dịch vụ và thông tin quan trọng khác.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-rocket"></i>
                                </div>
                                <div>
                                    <strong>Cải thiện dịch vụ:</strong> Phân tích dữ liệu để nâng cao chất lượng và phát triển các tính năng mới.
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="section">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-share-alt"></i>
                        </div>
                        Chia sẻ thông tin
                    </h2>
                    <div class="section-content">
                        <p>Chúng tôi có chính sách nghiêm ngặt về việc bảo vệ thông tin cá nhân của bạn:</p>
                        
                        <div class="highlight-box">
                            <p><strong>Cam kết của chúng tôi:</strong> Chúng tôi không bán, trao đổi, cho thuê hoặc chuyển giao thông tin cá nhân của bạn cho bất kỳ bên thứ ba nào mà không có sự đồng ý rõ ràng của bạn.</p>
                        </div>
                        
                        <p><strong>Các trường hợp ngoại lệ:</strong> Chúng tôi chỉ chia sẻ thông tin khi được yêu cầu bởi pháp luật hoặc để bảo vệ quyền lợi hợp pháp của chúng tôi và người dùng.</p>
                    </div>
                </div>

                <div class="section">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                        Bảo mật thông tin
                    </h2>
                    <div class="section-content">
                        <p>Chúng tôi áp dụng các biện pháp bảo mật tiên tiến để bảo vệ thông tin của bạn:</p>
                        
                        <ul class="info-list">
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-key"></i>
                                </div>
                                <div>
                                    <strong>Mã hóa dữ liệu:</strong> Tất cả mật khẩu được mã hóa bằng các thuật toán bảo mật tiên tiến.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div>
                                    <strong>Giao thức bảo mật:</strong> Sử dụng HTTPS và các biện pháp bảo mật khác để bảo vệ dữ liệu truyền tải.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-server"></i>
                                </div>
                                <div>
                                    <strong>Lưu trữ an toàn:</strong> Dữ liệu được lưu trữ trên các máy chủ được bảo mật nghiêm ngặt.
                                </div>
                            </li>
                            <li>
                                <div class="list-icon">
                                    <i class="fas fa-sync-alt"></i>
                                </div>
                                <div>
                                    <strong>Cập nhật thường xuyên:</strong> Hệ thống bảo mật được cập nhật và kiểm tra định kỳ.
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="contact-section">
                    <div class="contact-title">
                        <i class="fas fa-question-circle"></i> Có câu hỏi về chính sách bảo mật?
                    </div>
                    <p>Nếu bạn có bất kỳ thắc mắc nào về chính sách bảo mật này hoặc cách chúng tôi xử lý thông tin của bạn, vui lòng liên hệ với chúng tôi.</p>
                    <a href="mailto:privacy@englishlearning.com" class="contact-btn">
                        <i class="fas fa-envelope"></i> Liên hệ về bảo mật
                    </a>
                </div>
            </div>
        </div>
    </div>

    <%-- Include footer --%>
    <jsp:include page="/common/footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>