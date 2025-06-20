<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Làm Bài - English Learning</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --hover-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #1f2937;
        }

        .main-container {
            background: var(--light-bg);
            min-height: 100vh;
            padding-top: 2rem;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 2rem 2rem;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .page-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 300;
        }

        .stats-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: none;
            margin-bottom: 2rem;
        }

        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--hover-shadow);
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }

        .stat-label {
            color: #6b7280;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            font-weight: 500;
        }

        .history-card {
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .history-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--hover-shadow);
        }

        .card-header-custom {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .history-item {
            padding: 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            transition: all 0.3s ease;
        }

        .history-item:last-child {
            border-bottom: none;
        }

        .history-item:hover {
            background: #f9fafb;
        }

        .lesson-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .score-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .score-excellent {
            background: #dcfce7;
            color: #166534;
        }

        .score-good {
            background: #dbeafe;
            color: #1e40af;
        }

        .score-average {
            background: #fef3c7;
            color: #92400e;
        }

        .score-poor {
            background: #fee2e2;
            color: #991b1b;
        }

        .date-time {
            color: #6b7280;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-modern {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .btn-primary-modern:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-secondary-modern {
            background: #f3f4f6;
            color: #4b5563;
            border: 1px solid #d1d5db;
        }

        .btn-secondary-modern:hover {
            background: #e5e7eb;
            transform: translateY(-1px);
            color: #374151;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
        }

        .empty-icon {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 1.5rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
        }

        .empty-description {
            color: #6b7280;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .btn-start-learning {
            background: linear-gradient(135deg, var(--success-color), #059669);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-start-learning:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            color: white;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }

            .stats-card .row {
                text-align: center;
            }

            .stat-item {
                margin-bottom: 1rem;
            }

            .history-item {
                padding: 1rem;
            }

            .action-buttons {
                justify-content: center;
            }

            .btn-modern {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }

            .lesson-title {
                font-size: 1rem;
            }

            .empty-state {
                padding: 2rem 1rem;
            }

            .page-header {
                padding: 2rem 0;
            }
        }

        @media (max-width: 576px) {
            .main-container {
                padding-top: 1rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-modern {
                justify-content: center;
            }

            .stats-card .col-4 {
                flex: 0 0 100%;
                max-width: 100%;
                margin-bottom: 1rem;
            }
        }

        /* Animation */
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

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out;
        }

        .stagger-1 { animation-delay: 0.1s; }
        .stagger-2 { animation-delay: 0.2s; }
        .stagger-3 { animation-delay: 0.3s; }
    </style>
</head>
<body>
    <%-- Nhúng header chung và truyền tham số để tô sáng mục menu --%>
    <jsp:include page="common/header.jsp">
         <jsp:param name="activePage" value="quiz-history"/>
    </jsp:include>

    <div class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 text-center">
                        <h1 class="page-title fade-in-up">
                            <i class="fas fa-history me-3"></i>
                            Lịch Sử Làm Bài
                        </h1>
                        <p class="page-subtitle fade-in-up stagger-1">
                            Theo dõi tiến trình học tập và xem lại các bài quiz đã hoàn thành
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <c:choose>
                <c:when test="${not empty quizHistory}">
                    <!-- Statistics Cards -->
                    <div class="stats-card fade-in-up stagger-1">
                        <div class="row">
                            <div class="col-4">
                                <div class="stat-item">
                                    <span class="stat-number">${fn:length(quizHistory)}</span>
                                    <div class="stat-label">
                                        <i class="fas fa-clipboard-list me-1"></i>
                                        Bài đã làm
                                    </div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="stat-item">
                                    <span class="stat-number">
                                        <c:set var="totalScore" value="0" />
                                        <c:set var="totalQuestions" value="0" />
                                        <c:forEach var="item" items="${quizHistory}">
                                            <c:set var="totalScore" value="${totalScore + item.score}" />
                                            <c:set var="totalQuestions" value="${totalQuestions + item.totalQuestions}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${(totalScore / totalQuestions) * 100}" maxFractionDigits="0" />%
                                    </span>
                                    <div class="stat-label">
                                        <i class="fas fa-chart-line me-1"></i>
                                        Điểm trung bình
                                    </div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="stat-item">
                                    <span class="stat-number">
                                        <c:set var="excellentCount" value="0" />
                                        <c:forEach var="item" items="${quizHistory}">
                                            <c:if test="${(item.score / item.totalQuestions) >= 0.8}">
                                                <c:set var="excellentCount" value="${excellentCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${excellentCount}
                                    </span>
                                    <div class="stat-label">
                                        <i class="fas fa-star me-1"></i>
                                        Điểm cao
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- History List -->
                    <div class="history-card fade-in-up stagger-2">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-list-alt"></i>
                                Chi Tiết Lịch Sử
                            </h3>
                        </div>
                        
                        <c:forEach var="item" items="${quizHistory}" varStatus="loop">
                            <div class="history-item fade-in-up stagger-${loop.index % 3 + 1}">
                                <div class="row align-items-center">
                                    <div class="col-lg-6 col-md-12 mb-3 mb-lg-0">
                                        <div class="lesson-title">
                                            <i class="fas fa-book-open text-primary"></i>
                                            <c:out value="${item.lessonTitle}"/>
                                        </div>
                                        <div class="date-time">
                                            <i class="far fa-clock"></i>
                                            <fmt:formatDate value="${item.attemptedAt}" pattern="HH:mm 'ngày' dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-3 col-md-6 mb-3 mb-lg-0 text-center text-lg-start">
                                        <c:set var="percentage" value="${(item.score / item.totalQuestions) * 100}" />
                                        <c:choose>
                                            <c:when test="${percentage >= 80}">
                                                <span class="score-badge score-excellent">
                                                    <i class="fas fa-star"></i>
                                                    ${item.score}/${item.totalQuestions} (${percentage}%)
                                                </span>
                                            </c:when>
                                            <c:when test="${percentage >= 60}">
                                                <span class="score-badge score-good">
                                                    <i class="fas fa-thumbs-up"></i>
                                                    ${item.score}/${item.totalQuestions} (${percentage}%)
                                                </span>
                                            </c:when>
                                            <c:when test="${percentage >= 40}">
                                                <span class="score-badge score-average">
                                                    <i class="fas fa-minus-circle"></i>
                                                    ${item.score}/${item.totalQuestions} (${percentage}%)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="score-badge score-poor">
                                                    <i class="fas fa-times-circle"></i>
                                                    ${item.score}/${item.totalQuestions} (${percentage}%)
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="col-lg-3 col-md-6">
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/take-quiz?lessonId=${item.lessonId}" 
                                               class="btn-modern btn-primary-modern">
                                                <i class="fas fa-redo"></i>
                                                Làm lại
                                            </a>
                                            <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${item.lessonId}" 
                                               class="btn-modern btn-secondary-modern">
                                                <i class="fas fa-eye"></i>
                                                Xem bài học
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <div class="empty-state fade-in-up">
                        <div class="empty-icon">
                            <i class="fas fa-clipboard-question"></i>
                        </div>
                        <h3 class="empty-title">Chưa có dữ liệu lịch sử</h3>
                        <p class="empty-description">
                            Bạn chưa hoàn thành bài quiz nào. Hãy bắt đầu học và làm bài để theo dõi tiến độ học tập của mình nhé!
                        </p>
                        <a href="${pageContext.request.contextPath}/lessons" class="btn-start-learning">
                            <i class="fas fa-play"></i>
                            Bắt đầu học ngay
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add smooth scrolling and enhanced interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Add hover effects to cards
            const cards = document.querySelectorAll('.history-item, .stats-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Animate counters
            const counters = document.querySelectorAll('.stat-number');
            counters.forEach(counter => {
                const target = parseInt(counter.textContent.replace('%', ''));
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        counter.textContent = counter.textContent.includes('%') ? target + '%' : target;
                        clearInterval(timer);
                    } else {
                        counter.textContent = counter.textContent.includes('%') ? Math.floor(current) + '%' : Math.floor(current);
                    }
                }, 20);
            });
        });
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>