<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Lesson"%> <%-- Giữ nguyên theo yêu cầu của bạn --%>
<%@page import="model.User"%>   <%-- Giữ nguyên theo yêu cầu của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- SỬA LẠI URI CHO JAKARTA EE / TOMCAT 11 --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- SỬA LẠI URI CHO JAKARTA EE / TOMCAT 11 --%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:set var="lessonTitle" value="${not empty lesson ? lesson.title : 'Chi Tiết Bài Học'}"/>
    <title><c:out value="${lessonTitle}"/> - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Enhanced Lesson Detail Styles */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            margin: 2rem auto;
            padding: 0;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

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

        /* Enhanced Breadcrumb */
        .custom-breadcrumb {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-radius: 20px 20px 0 0;
            padding: 1.5rem 2rem;
            margin: 0;
        }

        .custom-breadcrumb .breadcrumb {
            background: transparent;
            margin: 0;
            padding: 0;
        }

        .custom-breadcrumb .breadcrumb-item {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 500;
        }

        .custom-breadcrumb .breadcrumb-item.active {
            color: white;
            font-weight: 600;
        }

        .custom-breadcrumb .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: all 0.3s ease;
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
        }

        .custom-breadcrumb .breadcrumb-item a:hover {
            color: white;
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
        }

        /* Lesson Header */
        .lesson-header {
            padding: 2rem;
            background: white;
            position: relative;
        }

        .lesson-title {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .lesson-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            background: rgba(102, 126, 234, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            color: #667eea;
            font-weight: 500;
        }

        .meta-item i {
            margin-right: 0.5rem;
            font-size: 1rem;
        }

        .lesson-divider {
            height: 3px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 2px;
            margin: 0;
        }

        /* Enhanced Lesson Content */
        .lesson-content-wrapper {
            padding: 2rem;
            background: white;
        }

        .lesson-content {
            white-space: normal;
            line-height: 1.8;
            font-size: 1.1rem;
            color: #2c3e50;
            background: rgba(248, 249, 250, 0.8);
            padding: 2rem;
            border-radius: 15px;
            border-left: 4px solid #667eea;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            position: relative;
            overflow: hidden;
        }

        .lesson-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.02), rgba(118, 75, 162, 0.02));
            pointer-events: none;
        }

        /* Enhanced Quiz Section */
        .quiz-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .quiz-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .quiz-section * {
            position: relative;
            z-index: 2;
        }

        .quiz-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .quiz-description {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .quiz-btn {
            background: white;
            color: #667eea;
            border: none;
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            position: relative;
            overflow: hidden;
        }

        .quiz-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.2), transparent);
            transition: left 0.5s;
        }

        .quiz-btn:hover::before {
            left: 100%;
        }

        .quiz-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.2);
            color: #667eea;
            text-decoration: none;
        }

        .quiz-btn i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }

        .quiz-btn:hover i {
            transform: rotate(15deg);
        }

        /* Enhanced Alert Messages */
        .custom-alert {
            border: none;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            border-left: 4px solid;
            position: relative;
            overflow: hidden;
        }

        .custom-alert.alert-info {
            background: linear-gradient(135deg, rgba(23, 162, 184, 0.1), rgba(23, 162, 184, 0.05));
            border-left-color: #17a2b8;
            color: #0c5460;
        }

        .custom-alert.alert-warning {
            background: linear-gradient(135deg, rgba(255, 193, 7, 0.1), rgba(255, 193, 7, 0.05));
            border-left-color: #ffc107;
            color: #856404;
        }

        .custom-alert::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(255, 255, 255, 0.5), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .custom-alert:hover::before {
            opacity: 1;
        }

        /* Error State */
        .error-container {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 0 0 20px 20px;
        }

        .error-icon {
            font-size: 4rem;
            color: #ffc107;
            margin-bottom: 1.5rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .error-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .error-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 8px;
        }

        .error-link:hover {
            color: #667eea;
            background: rgba(102, 126, 234, 0.1);
            text-decoration: none;
            transform: translateY(-1px);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                border-radius: 15px;
            }

            .custom-breadcrumb {
                padding: 1rem 1.5rem;
                border-radius: 15px 15px 0 0;
            }

            .lesson-header,
            .lesson-content-wrapper {
                padding: 1.5rem;
            }

            .lesson-title {
                font-size: 2rem;
            }

            .lesson-content {
                padding: 1.5rem;
                font-size: 1rem;
            }

            .quiz-section {
                padding: 2rem 1.5rem;
            }

            .quiz-title {
                font-size: 1.5rem;
            }

            .quiz-description {
                font-size: 1rem;
            }

            .quiz-btn {
                padding: 0.8rem 2rem;
                font-size: 1rem;
            }

            .meta-item {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }
        }

        @media (max-width: 576px) {
            .lesson-meta {
                justify-content: center;
            }

            .meta-item {
                flex: 1;
                justify-content: center;
                min-width: 120px;
            }

            .custom-breadcrumb {
                padding: 0.8rem 1rem;
            }

            .lesson-header,
            .lesson-content-wrapper {
                padding: 1rem;
            }

            .quiz-section {
                padding: 1.5rem 1rem;
            }
        }

        /* Scroll Animation */
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.6s ease;
        }

        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }

        /* Print Styles */
        @media print {
            .quiz-section,
            .custom-breadcrumb {
                display: none;
            }

            .main-container {
                box-shadow: none;
                background: white;
            }

            .lesson-content {
                background: white;
                box-shadow: none;
            }
        }
        .vocab-section {
            padding: 2rem;
            background: white;
        }
        .vocab-section .page-title {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 2.5rem;
        }
        .vocab-list-item {
            background: #fff;
            border-radius: 12px;
            margin-bottom: 1rem;
            padding: 1.25rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #e9ecef;
        }
        .vocab-list-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
            border-color: #667eea;
        }
        .vocab-list-item .vocab-term strong {
            font-size: 1.2rem;
            color: #667eea;
        }
        .vocab-list-item audio { height: 40px; max-width: 250px; border-radius: 20px; }
        .vocab-example {
            margin-top: 0.75rem;
            padding-left: 1rem;
            border-left: 3px solid #667eea;
            color: #495057;
            font-style: italic;
        }
        .vocab-image { margin-top: 0.75rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .action-buttons-container {
            padding: 3rem 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 0 0 20px 20px;
            text-align: center;
        }
        .action-buttons { display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap; margin-top: 1.5rem; }
        .action-buttons .btn {
            font-weight: 600;
            border-radius: 50px;
            padding: 0.8rem 2rem;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .action-buttons .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            text-decoration: none;
        }
        .action-buttons .btn-success { background: linear-gradient(45deg, #28a745, #20c997); color: white !important; }
        .action-buttons .btn-primary { background: linear-gradient(45deg, #667eea, #764ba2); color: white !important; }        
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="lessons"/>
    </jsp:include>

    <div class="container-fluid">
        <c:choose>
            <c:when test="${not empty lesson}">
                <div class="main-container">
                    <!-- Enhanced Breadcrumb -->
                    <div class="custom-breadcrumb">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/lessons">
                                        <i class="fas fa-book"></i>
                                        Danh sách bài học
                                    </a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    <i class="fas fa-bookmark"></i>
                                    <c:out value="${lesson.title}"/>
                                </li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Lesson Header -->
                    <div class="lesson-header fade-in">
                        <h1 class="lesson-title">
                            <c:out value="${lesson.title}"/>
                        </h1>
                        
                        <div class="lesson-meta">
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-clock"></i>
                                Thời gian đọc: ~5 phút
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-tag"></i>
                                Bài học
                            </div>
                        </div>
                        
                        <div class="lesson-divider"></div>
                    </div>

                    <!-- Lesson Content -->
                    <div class="lesson-content-wrapper fade-in">
                        <div class="lesson-content">
                            <c:out value="${lesson.content}" escapeXml="false"/>
                        </div>
                        
                        <!-- Quiz Message -->
                        <c:if test="${not empty requestScope.quizMessage}">
                            <div class="custom-alert alert-info">
                                <i class="fas fa-info-circle mr-2"></i>
                                <c:out value="${requestScope.quizMessage}"/>
                            </div>
                        </c:if>
                    </div>
                    <c:if test="${not empty lessonVocabulary}">
                        <div class="vocab-section fade-in">
                            <h2 class="text-center page-title">
                                <i class="fas fa-list-alt"></i> Từ vựng của bài học
                            </h2>
                            <div class="list-group">
                                <c:forEach var="vocab" items="${lessonVocabulary}">
                                    <div class="list-group-item flex-column align-items-start vocab-list-item">
                                        <div class="d-flex w-100 justify-content-between align-items-center flex-wrap">
                                            <div class="vocab-term mb-2 flex-grow-1">
                                                <h5 class="mb-1"><strong><c:out value="${vocab.word}"/></strong></h5>
                                                <small class="text-muted"><c:out value="${vocab.meaning}"/></small>
                                            </div>

                                            <c:if test="${vocab.hasAudio}">
                                                <div class="ml-3">
                                                    <%-- Trỏ src đến MediaServlet để lấy dữ liệu BLOB --%>
                                                    <audio controls class="audio-player" src="${pageContext.request.contextPath}/media?id=${vocab.vocabId}&type=audio"></audio>
                                                </div>
                                            </c:if>
                                        </div>

                                        <c:if test="${not empty vocab.example}">
                                            <div class="w-100 vocab-example">
                                                <strong>Ví dụ:</strong> <c:out value="${vocab.example}"/>
                                            </div>
                                        </c:if>

                                        <c:if test="${vocab.hasImage}">
                                            <img src="${pageContext.request.contextPath}/media?id=${vocab.vocabId}&type=image" 
                                                 alt="<c:out value='${vocab.word}'/>" 
                                                 class="vocab-image img-thumbnail mt-2" 
                                                 style="max-height: 120px;">
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Enhanced Quiz Section -->
                    <div class="action-buttons-container fade-in">
                        <h3 class="quiz-title">Sẵn sàng thực hành?</h3>
                        <p class="quiz-description">Củng cố kiến thức với các bài tập dành riêng cho bài học này.</p>
                        <div class="action-buttons">
                            <c:if test="${not empty lessonVocabulary}">
                                <a href="${pageContext.request.contextPath}/flashcards?lessonId=${lesson.lessonId}" class="btn btn-success">
                                    <i class="fas fa-layer-group"></i> Học Từ vựng (Flashcard)
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/take-quiz?lessonId=${lesson.lessonId}" class="btn btn-primary">
                                <i class="fas fa-question-circle"></i> Làm Bài Trắc Nghiệm
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="main-container">
                    <!-- Error Breadcrumb -->
                    <div class="custom-breadcrumb">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/lessons">
                                        <i class="fas fa-book"></i>
                                        Danh sách bài học
                                    </a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    Không tìm thấy
                                </li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Error Content -->
                    <div class="error-container">
                        <i class="fas fa-search error-icon"></i>
                        <h2 class="error-title">Không tìm thấy thông tin bài học</h2>
                        <p class="text-muted mb-4">
                            Bài học này có thể đã bị xóa hoặc không tồn tại. 
                            Hãy quay lại danh sách để chọn bài học khác.
                        </p>
                        <a href="${pageContext.request.contextPath}/lessons" class="error-link">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Quay lại danh sách bài học
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        // Enhanced animations and interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Fade in animation on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                    }
                });
            }, observerOptions);

            // Observe all fade-in elements
            document.querySelectorAll('.fade-in').forEach(el => {
                observer.observe(el);
            });

            // Add reading progress indicator
            const content = document.querySelector('.lesson-content');
            if (content) {
                let progressBar = document.createElement('div');
                progressBar.style.cssText = `
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 0%;
                    height: 3px;
                    background: linear-gradient(45deg, #667eea, #764ba2);
                    z-index: 9999;
                    transition: width 0.3s ease;
                `;
                document.body.appendChild(progressBar);

                window.addEventListener('scroll', function() {
                    const scrolled = (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100;
                    progressBar.style.width = Math.min(scrolled, 100) + '%';
                });
            }

            // Enhanced quiz button interaction
            const quizBtn = document.querySelector('.quiz-btn');
            if (quizBtn) {
                quizBtn.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px) scale(1.05)';
                });
                
                quizBtn.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            }

            // Smooth scroll for anchors
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Add copy to clipboard functionality for lesson content
            if (content) {
                const copyBtn = document.createElement('button');
                copyBtn.innerHTML = '<i class="fas fa-copy"></i>';
                copyBtn.className = 'btn btn-sm btn-outline-secondary';
                copyBtn.style.cssText = `
                    position: absolute;
                    top: 1rem;
                    right: 1rem;
                    opacity: 0.7;
                    transition: opacity 0.3s ease;
                `;
                copyBtn.title = 'Sao chép nội dung';
                
                content.style.position = 'relative';
                content.appendChild(copyBtn);
                
                copyBtn.addEventListener('click', function() {
                    navigator.clipboard.writeText(content.textContent).then(() => {
                        this.innerHTML = '<i class="fas fa-check"></i>';
                        setTimeout(() => {
                            this.innerHTML = '<i class="fas fa-copy"></i>';
                        }, 2000);
                    });
                });
                
                content.addEventListener('mouseenter', () => copyBtn.style.opacity = '1');
                content.addEventListener('mouseleave', () => copyBtn.style.opacity = '0.7');
            }
        });
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>