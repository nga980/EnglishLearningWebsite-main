<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .hero-section {
            background: linear-gradient(
                135deg,
                rgba(102, 126, 234, 0.9) 0%,
                rgba(118, 75, 162, 0.9) 100%
            ),
            url('https://images.unsplash.com/photo-1524178232363-1fb2b655?q=80&w=2070&auto=format&fit=crop') no-repeat center center;
            background-size: cover;
            background-attachment: fixed;
            color: white;
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.2);
            z-index: 1;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 20px;
            text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.5);
            animation: fadeInUp 1s ease-out;
        }
        
        .hero-subtitle {
            font-size: 1.3rem;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            animation: fadeInUp 1s ease-out 0.3s both;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .hero-button {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            font-weight: bold;
            border-radius: 50px;
            box-shadow: 0 10px 30px rgba(255, 107, 107, 0.4);
            transition: all 0.3s ease;
            animation: fadeInUp 1s ease-out 0.6s both;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .hero-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.6);
            background: linear-gradient(135deg, #ee5a24 0%, #ff6b6b 100%);
        }
        
        .hero-stats {
            margin-top: 60px;
            animation: fadeInUp 1s ease-out 0.9s both;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #ffd700;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .stat-label {
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 5px;
        }
        
        .main-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px 30px 0 0;
            margin-top: -30px;
            position: relative;
            z-index: 3;
            padding: 50px 0;
            min-height: 500px;
        }
        
        .section-title {
            text-align: center;
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 15px;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .section-subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-bottom: 50px;
        }
        
        .lesson-card {
            background: white;
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
            position: relative;
        }
        
        .lesson-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .lesson-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }
        
        .lesson-card .card-body {
            padding: 30px;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .lesson-card .card-title {
            color: #2c3e50;
            font-weight: 700;
            font-size: 1.3rem;
            margin-bottom: 15px;
            position: relative;
        }
        
        .lesson-card .card-title::before {
            content: '📚';
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .lesson-card .card-text {
            color: #7f8c8d;
            line-height: 1.6;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 75px;
            margin-bottom: 20px;
        }
        
        .lesson-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            align-self: flex-start;
        }
        
        .lesson-button:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            text-decoration: none;
        }
        
        .no-lessons-alert {
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1) 0%, rgba(155, 89, 182, 0.1) 100%);
            border: 2px dashed #3498db;
            border-radius: 20px;
            padding: 60px;
            text-align: center;
            color: #2c3e50;
            margin: 50px 0;
        }
        
        .no-lessons-alert i {
            display: block;
            font-size: 4rem;
            color: #3498db;
            margin-bottom: 20px;
        }
        
        .no-lessons-alert h3 {
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .features-section {
            background: rgba(255, 255, 255, 0.5);
            padding: 50px 0;
            margin: 50px 0;
            border-radius: 20px;
        }
        
        .feature-item {
            text-align: center;
            padding: 30px 20px;
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
            color: white;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }
        
        .feature-title {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .feature-desc {
            color: #7f8c8d;
            line-height: 1.6;
        }
        
        /* Animations */
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
        
        .lesson-card {
            opacity: 0;
            animation: fadeInUp 0.6s ease forwards;
        }
        
        .lesson-card:nth-child(1) { animation-delay: 0.1s; }
        .lesson-card:nth-child(2) { animation-delay: 0.2s; }
        .lesson-card:nth-child(3) { animation-delay: 0.3s; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.1rem;
            }
            
            .hero-button {
                padding: 12px 30px;
                font-size: 1rem;
            }
            
            .main-content {
                padding: 30px 0;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .lesson-card .card-body {
                padding: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .hero-section {
                padding: 60px 0;
            }
            
            .hero-title {
                font-size: 2rem;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="home"/>
    </jsp:include>
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container hero-content">
            <h1 class="hero-title">
                <i class="fas fa-graduation-cap"></i>
                Học Tiếng Anh Mỗi Ngày
            </h1>
            <p class="hero-subtitle">
                Nâng cao kỹ năng của bạn với các bài học, từ vựng và bài tập trắc nghiệm đa dạng. 
                Khám phá phương pháp học hiện đại và hiệu quả nhất!
            </p>
            <a class="btn hero-button" href="${pageContext.request.contextPath}/lessons" role="button">
                <i class="fas fa-rocket"></i> Bắt đầu học ngay
            </a>
            
            <!-- Stats Section -->
            <div class="row hero-stats">
                <div class="col-md-4 stat-item">
                    <div class="stat-number">500+</div>
                    <div class="stat-label">Bài học</div>
                </div>
                <div class="col-md-4 stat-item">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Từ vựng</div>
                </div>
                <div class="col-md-4 stat-item">
                    <div class="stat-number">1K+</div>
                    <div class="stat-label">Học viên</div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Features Section -->
            <div class="features-section">
                <div class="row">
                    <div class="col-md-4 feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h4 class="feature-title">Bài học đa dạng</h4>
                        <p class="feature-desc">Từ cơ bản đến nâng cao, phù hợp với mọi trình độ</p>
                    </div>
                    <div class="col-md-4 feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-brain"></i>
                        </div>
                        <h4 class="feature-title">Học thông minh</h4>
                        <p class="feature-desc">Phương pháp học tập hiện đại, tối ưu hóa trí nhớ</p>
                    </div>
                    <div class="col-md-4 feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h4 class="feature-title">Theo dõi tiến độ</h4>
                        <p class="feature-desc">Đánh giá kết quả học tập một cách chi tiết</p>
                    </div>
                </div>
            </div>
            
            <!-- Recent Lessons Section -->
            <h2 class="section-title">
                <i class="fas fa-star"></i>
                Các bài học mới nhất
            </h2>
            <p class="section-subtitle">Khám phá những bài học được cập nhật gần đây nhất</p>
            
            <c:choose>
                <c:when test="${not empty recentLessonList}">
                    <div class="row">
                        <c:forEach var="lesson" items="${recentLessonList}">
                            <div class="col-lg-4 col-md-6 mb-4">
                                <div class="card lesson-card">
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <c:out value="${lesson.title}"/>
                                        </h5>
                                        <p class="card-text">
                                            <c:out value="${lesson.content}"/>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lesson.lessonId}" 
                                           class="btn lesson-button">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-lessons-alert">
                        <i class="fas fa-book-reader"></i>
                        <h3>Chưa có bài học nào!</h3>
                        <p>Hãy quay lại sau để khám phá những bài học thú vị nhé.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>