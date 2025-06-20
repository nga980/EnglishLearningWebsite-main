<%@page import="model.User"%> <%-- SỬA Ở ĐÂY: Tên package đầy đủ --%>
<%@page import="model.Lesson"%> <%-- SỬA Ở ĐÂY: Tên package đầy đủ --%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh Sách Bài Học - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin: 20px auto;
            padding: 40px;
            max-width: 1200px;
            min-height: 600px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }
        
        .page-title {
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 15px;
            position: relative;
        }
        
        .page-title:after {
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
        
        .page-title i {
            margin-right: 15px;
            color: #667eea;
        }
        
        .page-subtitle {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-top: 20px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .lessons-grid {
            display: grid;
            gap: 25px;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        }
        
        .lesson-card {
            background: white;
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            position: relative;
            opacity: 0;
            animation: fadeInUp 0.6s ease forwards;
        }
        
        .lesson-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .lesson-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        }
        
        .lesson-card .card-body {
            padding: 30px;
            position: relative;
        }
        
        .lesson-number {
            position: absolute;
            top: -15px;
            right: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .lesson-card .card-title {
            margin-top: 10px;
            margin-bottom: 20px;
        }
        
        .lesson-card .card-title a {
            color: #2c3e50;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.3rem;
            display: block;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .lesson-card .card-title a::before {
            content: '📖';
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .lesson-card .card-title a:hover {
            color: #667eea;
            text-decoration: none;
            transform: translateX(5px);
        }
        
        .lesson-meta {
            background: rgba(102, 126, 234, 0.05);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
        
        .lesson-date {
            color: #7f8c8d;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
        }
        
        .lesson-date i {
            margin-right: 8px;
            color: #667eea;
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
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
        }
        
        .lesson-button i {
            margin-right: 8px;
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
            animation: bounce 2s infinite;
        }
        
        .no-lessons-alert h3 {
            font-weight: 700;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .no-lessons-alert p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .pagination-wrapper {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid rgba(102, 126, 234, 0.1);
        }
        
        .pagination {
            justify-content: center;
        }
        
        .page-link {
            color: #667eea;
            border: 2px solid transparent;
            border-radius: 12px !important;
            margin: 0 5px;
            padding: 12px 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .page-link:hover {
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: transparent;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            transform: scale(1.05);
        }
        
        .page-item.disabled .page-link {
            color: #95a5a6;
            background: #f8f9fa;
            border-color: #dee2e6;
            box-shadow: none;
        }
        
        .page-item.disabled .page-link:hover {
            transform: none;
            box-shadow: none;
        }
        
        /* Animation delays for cards */
        .lesson-card:nth-child(1) { animation-delay: 0.1s; }
        .lesson-card:nth-child(2) { animation-delay: 0.2s; }
        .lesson-card:nth-child(3) { animation-delay: 0.3s; }
        .lesson-card:nth-child(4) { animation-delay: 0.4s; }
        .lesson-card:nth-child(5) { animation-delay: 0.5s; }
        .lesson-card:nth-child(6) { animation-delay: 0.6s; }
        
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
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-container {
                margin: 10px;
                padding: 25px;
                border-radius: 15px;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .lessons-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .lesson-card .card-body {
                padding: 25px;
            }
            
            .lesson-card .card-title a {
                font-size: 1.2rem;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .lesson-card .card-body {
                padding: 20px;
            }
            
            .page-link {
                padding: 10px 14px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="lessons"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="main-container">
            <div class="page-header">
                <h2 class="page-title">
                    <i class="fas fa-book-open"></i>
                    Danh Sách Bài Học
                </h2>
                <p class="page-subtitle">
                    Khám phá và học tập với bộ sưu tập bài học tiếng Anh phong phú của chúng tôi
                </p>
            </div>

            <c:choose>
                <c:when test="${not empty lessonList}">
                    <div class="lessons-grid">
                        <c:forEach var="lesson" items="${lessonList}" varStatus="loop">
                            <div class="card lesson-card">
                                <div class="lesson-number">${loop.count}</div>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lesson.lessonId}">
                                            <c:out value="${lesson.title}" />
                                        </a>
                                    </h5>
                                    <div class="lesson-meta">
                                        <div class="lesson-date">
                                            <i class="fas fa-calendar-alt"></i>
                                            Ngày tạo: <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lesson.lessonId}" 
                                       class="btn lesson-button">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </a>
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

            <%-- KHỐI PHÂN TRANG --%>
            <c:if test="${totalPages > 1}">
                <div class="pagination-wrapper">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <%-- Nút Previous --%>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/lessons?page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </li>

                            <%-- Các nút số trang --%>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/lessons?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <%-- Nút Next --%>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/lessons?page=${currentPage + 1}">
                                    Sau <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>