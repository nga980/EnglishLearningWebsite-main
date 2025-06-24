<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh Sách Từ Vựng - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>        
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .main-container { background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 30px; }
        .page-title-container { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-title { margin-bottom: 0; }
        .btn-flashcard { font-size: 1.1rem; padding: 12px 25px; border-radius: 50px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
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
            padding: 30px;
            max-width: 1200px;
        }
        
        .page-title {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            font-weight: 700;
        }
        
        .page-title:after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .page-title i {
            margin-right: 10px;
            color: #667eea;
        }
        
        .vocab-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: none;
        }
        
        .vocab-table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 20px 15px;
            border: none;
            position: relative;
        }
        
        .vocab-table thead th:first-child {
            border-radius: 0;
        }
        
        .vocab-table thead th:last-child {
            border-radius: 0;
        }
        
        .vocab-table tbody tr {
            transition: all 0.3s ease;
            border: none;
        }
        
        .vocab-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .vocab-table tbody td {
            padding: 20px 15px;
            vertical-align: middle;
            border: none;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .vocab-word {
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.1rem;
            position: relative;
        }
        
        .vocab-word:before {
            content: '📚';
            margin-right: 8px;
        }
        
        .vocab-meaning {
            color: #27ae60;
            font-weight: 500;
        }
        
        .vocab-example {
            color: #7f8c8d;
            font-style: italic;
            position: relative;
        }
        
        .vocab-example:before {
            content: '"';
            color: #667eea;
            font-size: 1.2rem;
            font-weight: bold;
        }
        
        .vocab-example:after {
            content: '"';
            color: #667eea;
            font-size: 1.2rem;
            font-weight: bold;
        }
        
        .vocab-date {
            color: #95a5a6;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .row-number {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
        }
        
        .no-data-alert {
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1) 0%, rgba(155, 89, 182, 0.1) 100%);
            border: 2px dashed #3498db;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .no-data-alert i {
            display: block;
            font-size: 3rem;
            color: #3498db;
            margin-bottom: 15px;
        }
        
        .pagination {
            margin-top: 30px;
        }
        
        .page-link {
            color: #667eea;
            border: 2px solid transparent;
            border-radius: 10px !important;
            margin: 0 5px;
            padding: 10px 15px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .page-link:hover {
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: transparent;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .page-item.disabled .page-link {
            color: #95a5a6;
            background: #f8f9fa;
            border-color: #dee2e6;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-container {
                margin: 10px;
                padding: 20px;
                border-radius: 15px;
            }
            
            .vocab-table {
                font-size: 0.9rem;
            }
            
            .vocab-table thead th,
            .vocab-table tbody td {
                padding: 12px 8px;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
        }
        
        @media (max-width: 576px) {
            .vocab-table {
                font-size: 0.8rem;
            }
            
            .row-number {
                width: 30px;
                height: 30px;
                font-size: 0.8rem;
            }
            
            .vocab-word {
                font-size: 1rem;
            }
        }
        
        /* Animation for table load */
        .vocab-table tbody tr {
            opacity: 0;
            animation: fadeInUp 0.6s ease forwards;
        }
        
        .vocab-table tbody tr:nth-child(1) { animation-delay: 0.1s; }
        .vocab-table tbody tr:nth-child(2) { animation-delay: 0.2s; }
        .vocab-table tbody tr:nth-child(3) { animation-delay: 0.3s; }
        .vocab-table tbody tr:nth-child(4) { animation-delay: 0.4s; }
        .vocab-table tbody tr:nth-child(5) { animation-delay: 0.5s; }
        
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
        .vocab-table { background: white; border-radius: 15px; overflow: hidden; }
        .vocab-table thead th { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .vocab-image { max-width: 100px; border-radius: 8px; }
        .audio-player { width: 100%; min-width: 200px; height: 40px; }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="vocabulary"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="main-container">
            <div class="page-title-container">
                <h2 class="page-title">
                    <i class="fas fa-book"></i>
                    Danh Sách Từ Vựng
                </h2>
                <a href="${pageContext.request.contextPath}/flashcards" class="btn btn-success btn-flashcard">
                    <i class="fas fa-layer-group"></i> Ôn tập với Flashcard
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty vocabularyList}">
                    <div class="table-responsive">
                        <table class="table vocab-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Hình ảnh</th>
                                    <th>Từ</th>
                                    <th>Nghĩa</th>
                                    <th>Ví dụ</th>
                                    <th>Phát âm</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="vocab" items="${vocabularyList}" varStatus="loop">
                                    <tr>
                                        <td>
                                            <%-- Tính toán số thứ tự dựa trên trang hiện tại --%>
                                            <span class="row-number">${(currentPage - 1) * 15 + loop.count}</span>
                                        </td>
                                        <td>
                                            <c:if test="${vocab.hasImage}">
                                                <img src="${pageContext.request.contextPath}/media?id=${vocab.vocabId}&type=image" 
                                                 alt="<c:out value='${vocab.word}'/>" 
                                                 class="vocab-image img-thumbnail mt-2" 
                                                 style="max-height: 120px;">
                                            </c:if>
                                            <c:if test="${!vocab.hasImage}">
                                                <span class="text-muted small">N/A</span>
                                            </c:if>
                                        </td>
                                        <td class="vocab-word"><c:out value="${vocab.word}"/></td>
                                        <td class="vocab-meaning"><c:out value="${vocab.meaning}"/></td>
                                        <td><c:out value="${vocab.example}"/></td>
                                        <td>
                                            <c:if test="${vocab.hasAudio}">
                                                <audio controls class="audio-player" 
                                                       src="${pageContext.request.contextPath}/media?id=${vocab.vocabId}&type=audio">
                                                </audio>
                                            </c:if>
                                            <c:if test="${!vocab.hasAudio}">
                                                <span class="text-muted small">N/A</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">Chưa có từ vựng nào.</div>
                </c:otherwise>
            </c:choose>
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/vocabulary?page=${currentPage - 1}">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/vocabulary?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/vocabulary?page=${currentPage + 1}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
    
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

</body>
</html>