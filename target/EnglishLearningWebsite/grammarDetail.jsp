<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:set var="topicTitle" value="${not empty grammarTopic ? grammarTopic.title : 'Chi Tiết Ngữ Pháp'}"/>
    <title><c:out value="${topicTitle}"/> - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Enhanced Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            border-bottom: 1px solid rgba(102, 126, 234, 0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .navbar-nav .nav-link {
            font-weight: 500;
            color: #2c3e50 !important;
            transition: all 0.3s ease;
            margin: 0 0.5rem;
            border-radius: 8px;
            padding: 0.5rem 1rem !important;
        }

        .navbar-nav .nav-link:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea !important;
        }

        .btn-outline-primary {
            border-color: #667eea;
            color: #667eea;
            border-radius: 20px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-outline-primary:hover {
            background: #667eea;
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 20px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-outline-danger {
            border-radius: 20px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-outline-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.4);
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin: 2rem auto;
            max-width: 1000px;
        }

        /* Enhanced Breadcrumb */
        .breadcrumb {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            border-radius: 15px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            border: none;
        }

        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .breadcrumb-item a:hover {
            color: #764ba2;
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: #2c3e50;
            font-weight: 600;
        }

        /* Enhanced Title Section */
        .topic-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .topic-header h1 {
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .topic-meta {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            background: rgba(102, 126, 234, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            color: #667eea;
            font-weight: 500;
        }

        .meta-item i {
            margin-right: 0.5rem;
        }

        .difficulty-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .difficulty-easy {
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            color: white;
        }

        .difficulty-medium {
            background: linear-gradient(45deg, #f39c12, #e67e22);
            color: white;
        }

        .difficulty-hard {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
            color: white;
        }

        /* Enhanced Content Sections */
        .content-section {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05);
            border-left: 5px solid #667eea;
        }

        .content-section h4 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .content-section h4 i {
            margin-right: 0.75rem;
            color: #667eea;
        }

        .grammar-content {
            white-space: pre-wrap;
            line-height: 1.8;
            color: #34495e;
            font-size: 1.1rem;
        }

        .example-section {
            background: linear-gradient(135deg, rgba(46, 204, 113, 0.1), rgba(39, 174, 96, 0.1));
            border-radius: 15px;
            padding: 2rem;
            margin-top: 2rem;
            border-left: 5px solid #2ecc71;
        }

        .example-section h4 {
            color: #27ae60;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .example-section h4 i {
            margin-right: 0.75rem;
        }

        .example-sentences {
            white-space: pre-wrap;
            line-height: 1.8;
            color: #2c3e50;
            font-size: 1.05rem;
            background: rgba(255, 255, 255, 0.7);
            padding: 1.5rem;
            border-radius: 10px;
            border: 1px solid rgba(46, 204, 113, 0.2);
        }

        /* Enhanced Alert */
        .alert-warning {
            background: linear-gradient(135deg, rgba(243, 156, 18, 0.1), rgba(230, 126, 34, 0.1));
            border: 1px solid rgba(243, 156, 18, 0.3);
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
        }

        .alert-warning i {
            font-size: 3rem;
            color: #f39c12;
            margin-bottom: 1rem;
            display: block;
        }

        /* Back to Top Button */
        .back-to-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            transition: all 0.3s ease;
            opacity: 0;
            visibility: hidden;
        }

        .back-to-top.show {
            opacity: 1;
            visibility: visible;
        }

        .back-to-top:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                padding: 1.5rem;
                border-radius: 15px;
            }

            .topic-header h1 {
                font-size: 2rem;
            }

            .topic-meta {
                justify-content: center;
            }

            .content-section,
            .example-section {
                padding: 1.5rem;
            }

            .navbar-nav {
                text-align: center;
            }

            .navbar-nav .nav-link {
                margin: 0.25rem 0;
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

        .main-container > * {
            animation: fadeInUp 0.6s ease forwards;
        }

        .content-section {
            animation: fadeInUp 0.8s ease forwards;
        }

        .example-section {
            animation: fadeInUp 1s ease forwards;
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="grammar"/>
    </jsp:include>

    <div class="container">
        <div class="main-container">
            <c:choose>
                <c:when test="${not empty grammarTopic}">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/grammar">
                                    <i class="fas fa-home me-1"></i>Chủ đề ngữ pháp
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <c:out value="${grammarTopic.title}"/>
                            </li>
                        </ol>
                    </nav>
                    
                    <div class="topic-header">
                        <h1><c:out value="${grammarTopic.title}"/></h1>
                        <div class="topic-meta">
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <fmt:formatDate value="${grammarTopic.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                            <c:if test="${not empty grammarTopic.difficultyLevel}">
                                <div class="difficulty-badge 
                                    ${grammarTopic.difficultyLevel == 'Dễ' ? 'difficulty-easy' : 
                                      grammarTopic.difficultyLevel == 'Trung bình' ? 'difficulty-medium' : 'difficulty-hard'}">
                                    <i class="fas fa-signal me-1"></i>
                                    <c:out value="${grammarTopic.difficultyLevel}"/>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="content-section">
                        <h4>
                            <i class="fas fa-book-open"></i>
                            Nội dung bài học
                        </h4>
                        <div class="grammar-content">
                            <c:out value="${grammarTopic.content}" escapeXml="false"/>
                        </div>
                    </div>

                    <c:if test="${not empty grammarTopic.exampleSentences}">
                        <div class="example-section">
                            <h4>
                                <i class="fas fa-lightbulb"></i>
                                Ví dụ minh họa
                            </h4>
                            <div class="example-sentences">
                                <c:out value="${grammarTopic.exampleSentences}" escapeXml="false"/>
                            </div>
                        </div>
                    </c:if>

                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h4>Không tìm thấy nội dung</h4>
                        <p class="mb-0">
                            Không tìm thấy thông tin chủ đề ngữ pháp. 
                            <a href="${pageContext.request.contextPath}/grammar" class="alert-link">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop">
        <i class="fas fa-arrow-up"></i>
    </button>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        // Back to top functionality
        window.addEventListener('scroll', function() {
            const backToTop = document.getElementById('backToTop');
            if (window.pageYOffset > 300) {
                backToTop.classList.add('show');
            } else {
                backToTop.classList.remove('show');
            }
        });

        document.getElementById('backToTop').addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Smooth scroll for breadcrumb links
        document.querySelectorAll('.breadcrumb a').forEach(link => {
            link.addEventListener('click', function(e) {
                // Add smooth transition effect
                this.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 150);
            });
        });
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>