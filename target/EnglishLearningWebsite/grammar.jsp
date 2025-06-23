<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chủ Đề Ngữ Pháp - English Learning</title>
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
            padding: 2rem;
            margin: 2rem auto;
            max-width: 1200px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .page-header h2 {
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-header::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .topic-card {
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
        }

        .topic-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .topic-card .list-group-item {
            border: none;
            background: transparent;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .topic-card .list-group-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .topic-card:hover .list-group-item::before {
            opacity: 1;
        }

        .topic-card .list-group-item h5 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }

        .topic-card .list-group-item:hover h5 {
            color: #667eea;
        }

        .difficulty-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-top: 0.5rem;
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

        .date-badge {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            border-radius: 15px;
            color: white;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.7;
        }

        .pagination {
            margin-top: 3rem;
        }

        .pagination .page-link {
            border: none;
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            padding: 0.75rem 1rem;
            margin: 0 0.25rem;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .pagination .page-link:hover {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .pagination .page-item.disabled .page-link {
            background: rgba(0, 0, 0, 0.1);
            color: rgba(0, 0, 0, 0.3);
        }

        .stats-info {
            text-align: center;
            margin-bottom: 2rem;
            color: #6c757d;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                padding: 1.5rem;
                border-radius: 15px;
            }

            .page-header h2 {
                font-size: 2rem;
            }

            .topic-card .list-group-item {
                padding: 1rem;
            }
        }

        /* Animation cho loading */
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

        .topic-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .topic-card:nth-child(1) { animation-delay: 0.1s; }
        .topic-card:nth-child(2) { animation-delay: 0.2s; }
        .topic-card:nth-child(3) { animation-delay: 0.3s; }
        .topic-card:nth-child(4) { animation-delay: 0.4s; }
        .topic-card:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body class="d-flex flex-column h-75">
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="grammar"/>
    </jsp:include>
    
    <div class="container">
        <div class="main-container">
            <div class="page-header">
                <h2><i class="fas fa-book-open me-3"></i>Chủ Đề Ngữ Pháp</h2>
                <p class="text-muted">Khám phá và học tập các chủ đề ngữ pháp tiếng Anh một cách hiệu quả</p>
            </div>

            <c:choose>
                <c:when test="${not empty grammarTopicList}">
                    <div class="stats-info">
                        <i class="fas fa-info-circle"></i>
                        Hiển thị ${grammarTopicList.size()} chủ đề ngữ pháp
                    </div>
                    
                    <div class="list-group">
                        <c:forEach var="topic" items="${grammarTopicList}" varStatus="status">
                            <div class="topic-card">
                                <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${topic.topicId}" 
                                   class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h5 class="mb-2">
                                                <i class="fas fa-graduation-cap me-2"></i>
                                                <c:out value="${topic.title}"/>
                                            </h5>
                                            <div class="d-flex align-items-center flex-wrap">
                                                <c:if test="${not empty topic.difficultyLevel}">
                                                    <span class="difficulty-badge 
                                                        ${topic.difficultyLevel == 'Dễ' ? 'difficulty-easy' : 
                                                          topic.difficultyLevel == 'Trung bình' ? 'difficulty-medium' : 'difficulty-hard'}">
                                                        <i class="fas fa-signal me-1"></i>
                                                        <c:out value="${topic.difficultyLevel}"/>
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="text-right">
                                            <span class="date-badge">
                                                <i class="fas fa-calendar-alt me-1"></i>
                                                <fmt:formatDate value="${topic.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-book"></i>
                        <h4>Chưa có chủ đề ngữ pháp</h4>
                        <p class="mb-0">Hiện tại chưa có chủ đề ngữ pháp nào được thêm vào hệ thống.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/grammar?page=${currentPage - 1}">
                                <i class="fas fa-chevron-left me-1"></i>Trước
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/grammar?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/grammar?page=${currentPage + 1}">
                                Sau<i class="fas fa-chevron-right ms-1"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
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