<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Kết Quả Tìm Kiếm cho: <c:out value="${searchedKeyword}"/></title>
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

        .search-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: 2rem;
            backdrop-filter: blur(10px);
        }

        .search-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-align: center;
            position: relative;
        }

        .search-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, #007bff, #28a745);
            border-radius: 2px;
        }

        .keyword-highlight {
            background: linear-gradient(120deg, #a8edea 0%, #fed6e3 100%);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
            display: inline-block;
            margin: 0.5rem 0;
        }

        .result-category {
            margin-top: 2.5rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #007bff;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .result-category:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .category-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .category-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
        }

        .lessons-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .vocab-icon {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .grammar-icon {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .custom-list-group-item {
            border: none;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
            padding: 1rem 1.25rem;
        }

        .custom-list-group-item:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .vocab-item {
            background: #f8f9fa;
            border: none;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            padding: 1rem 1.25rem;
            border-left: 3px solid #28a745;
            transition: all 0.3s ease;
        }

        .vocab-item:hover {
            background: #e8f5e8;
            transform: translateX(3px);
        }

        .vocab-word {
            color: #007bff;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .vocab-meaning {
            color: #6c757d;
            margin-top: 0.25rem;
        }

        .no-results {
            text-align: center;
            padding: 3rem 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .no-results-icon {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .no-results-text {
            color: #6c757d;
            font-size: 1.1rem;
        }

        .search-prompt {
            text-align: center;
            padding: 3rem 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .search-prompt-icon {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 1rem;
        }

        .result-count {
            background: #007bff;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-left: 0.5rem;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container-fluid {
                max-width: 95%;
            }
        }

        @media (max-width: 992px) {
            .search-container {
                margin: 1.5rem;
                padding: 1.8rem;
            }
            
            .search-title {
                font-size: 1.5rem;
            }
            
            .category-title {
                font-size: 1.2rem;
            }
        }

        @media (max-width: 768px) {
            .search-container {
                margin: 1rem;
                padding: 1.2rem;
                border-radius: 10px;
            }
            
            .search-title {
                font-size: 1.3rem;
                margin-bottom: 1rem;
            }
            
            .search-title::after {
                width: 60px;
                height: 2px;
            }
            
            .keyword-highlight {
                display: block;
                text-align: center;
                margin: 1rem 0;
                padding: 0.5rem 1rem;
                font-size: 0.95rem;
            }
            
            .result-category {
                margin-top: 1.5rem;
                padding: 1rem;
                border-radius: 8px;
            }
            
            .category-title {
                font-size: 1.1rem;
                flex-wrap: wrap;
                gap: 0.3rem;
            }
            
            .category-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
            
            .result-count {
                font-size: 0.75rem;
                padding: 0.2rem 0.4rem;
            }
            
            .custom-list-group-item {
                padding: 0.8rem 1rem;
                font-size: 0.95rem;
            }
            
            .custom-list-group-item:hover {
                transform: translateX(3px);
            }
            
            .vocab-item {
                padding: 0.8rem 1rem;
            }
            
            .vocab-word {
                font-size: 1rem;
            }
            
            .vocab-meaning {
                font-size: 0.9rem;
            }
            
            .no-results {
                padding: 2rem 1rem;
            }
            
            .no-results-icon {
                font-size: 3rem;
            }
            
            .search-prompt {
                padding: 2rem 1rem;
            }
            
            .search-prompt-icon {
                font-size: 2.5rem;
            }
        }

        @media (max-width: 576px) {
            body {
                font-size: 14px;
            }
            
            .search-container {
                margin: 0.5rem;
                padding: 1rem;
                border-radius: 8px;
            }
            
            .search-title {
                font-size: 1.2rem;
                line-height: 1.3;
            }
            
            .keyword-highlight {
                font-size: 0.9rem;
                padding: 0.4rem 0.8rem;
                border-radius: 15px;
            }
            
            .result-category {
                margin-top: 1rem;
                padding: 0.8rem;
                border-left-width: 3px;
            }
            
            .category-title {
                font-size: 1rem;
                margin-bottom: 0.8rem;
                align-items: flex-start;
            }
            
            .category-icon {
                width: 30px;
                height: 30px;
                font-size: 0.9rem;
                margin-top: 2px;
            }
            
            .result-count {
                font-size: 0.7rem;
                padding: 0.15rem 0.35rem;
                margin-left: 0.3rem;
                margin-top: 0.2rem;
            }
            
            .custom-list-group-item {
                padding: 0.7rem 0.8rem;
                font-size: 0.9rem;
                margin-bottom: 0.4rem;
                border-radius: 6px;
            }
            
            .custom-list-group-item i {
                margin-right: 0.5rem;
                font-size: 0.8rem;
            }
            
            .vocab-item {
                padding: 0.7rem 0.8rem;
                margin-bottom: 0.4rem;
                border-left-width: 2px;
            }
            
            .vocab-word {
                font-size: 0.95rem;
                margin-bottom: 0.3rem;
            }
            
            .vocab-word i {
                font-size: 0.7rem;
                margin-right: 0.3rem;
            }
            
            .vocab-meaning {
                font-size: 0.85rem;
                line-height: 1.4;
            }
            
            .no-results {
                padding: 1.5rem 0.8rem;
            }
            
            .no-results-icon {
                font-size: 2.5rem;
                margin-bottom: 0.8rem;
            }
            
            .no-results-text {
                font-size: 1rem;
                line-height: 1.5;
            }
            
            .search-prompt {
                padding: 1.5rem 0.8rem;
            }
            
            .search-prompt-icon {
                font-size: 2rem;
                margin-bottom: 0.8rem;
            }
        }

        @media (max-width: 400px) {
            .search-container {
                margin: 0.25rem;
                padding: 0.8rem;
            }
            
            .search-title {
                font-size: 1.1rem;
            }
            
            .keyword-highlight {
                font-size: 0.85rem;
                padding: 0.3rem 0.6rem;
            }
            
            .result-category {
                padding: 0.6rem;
                margin-top: 0.8rem;
            }
            
            .category-title {
                font-size: 0.95rem;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 0.5rem;
            }
            
            .category-icon {
                width: 35px;
                height: 35px;
            }
            
            .result-count {
                margin-left: 0;
                margin-top: 0.3rem;
            }
            
            .custom-list-group-item {
                padding: 0.6rem;
                font-size: 0.85rem;
                text-align: left;
            }
            
            .vocab-item {
                padding: 0.6rem;
            }
            
            .vocab-word {
                font-size: 0.9rem;
            }
            
            .vocab-meaning {
                font-size: 0.8rem;
            }
        }

        /* Landscape orientation on mobile */
        @media screen and (max-height: 500px) and (orientation: landscape) {
            .search-container {
                margin-top: 1rem;
                padding: 1rem;
            }
            
            .result-category {
                margin-top: 1rem;
                padding: 0.8rem;
            }
        }

        /* High DPI screens */
        @media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
            .category-icon {
                transform: translateZ(0);
            }
            
            .custom-list-group-item {
                backface-visibility: hidden;
            }
        }
    </style>
</head>
<body class="d-flex flex-column h-75">
    <jsp:include page="common/header.jsp"/>

    <div class="main-content">
        <div class="container-fluid px-2 px-md-3">
            <div class="row justify-content-center">
                <div class="col-12 col-lg-10 col-xl-8">
                    <div class="search-container">
            <c:choose>
                <c:when test="${not empty searchedKeyword}">
                    <h2 class="search-title">
                        Kết quả tìm kiếm cho: 
                        <div class="keyword-highlight">
                            <i class="fas fa-search"></i> <c:out value="${searchedKeyword}"/>
                        </div>
                    </h2>

                    <%-- Kiểm tra xem có kết quả nào không --%>
                    <c:if test="${empty lessonResults && empty vocabResults && empty grammarResults}">
                        <div class="no-results">
                            <i class="fas fa-search-minus no-results-icon"></i>
                            <div class="no-results-text">
                                Không tìm thấy kết quả nào phù hợp với từ khóa của bạn.
                                <br><small class="text-muted">Hãy thử với từ khóa khác hoặc kiểm tra lại chính tả.</small>
                            </div>
                        </div>
                    </c:if>

                    <%-- Phần kết quả Bài Học --%>
                    <c:if test="${not empty lessonResults}">
                        <div class="result-category">
                            <h4 class="category-title">
                                <div class="category-icon lessons-icon">
                                    <i class="fas fa-book-open"></i>
                                </div>
                                Bài học liên quan
                                <span class="result-count">${lessonResults.size()}</span>
                            </h4>
                            <div class="list-group">
                                <c:forEach var="lesson" items="${lessonResults}">
                                    <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lesson.lessonId}" 
                                       class="list-group-item custom-list-group-item">
                                        <i class="fas fa-play-circle me-2"></i>
                                        <c:out value="${lesson.title}"/>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <%-- Phần kết quả Từ Vựng --%>
                    <c:if test="${not empty vocabResults}">
                        <div class="result-category">
                            <h4 class="category-title">
                                <div class="category-icon vocab-icon">
                                    <i class="fas fa-language"></i>
                                </div>
                                Từ vựng liên quan
                                <span class="result-count">${vocabResults.size()}</span>
                            </h4>
                            <ul class="list-group">
                                <c:forEach var="vocab" items="${vocabResults}">
                                    <li class="list-group-item vocab-item">
                                        <div class="vocab-word">
                                            <i class="fas fa-quote-left"></i> <c:out value="${vocab.word}"/>
                                        </div>
                                        <div class="vocab-meaning">
                                            <c:out value="${vocab.meaning}"/>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <%-- Phần kết quả Ngữ Pháp --%>
                    <c:if test="${not empty grammarResults}">
                        <div class="result-category">
                            <h4 class="category-title">
                                <div class="category-icon grammar-icon">
                                    <i class="fas fa-cogs"></i>
                                </div>
                                Chủ đề ngữ pháp liên quan
                                <span class="result-count">${grammarResults.size()}</span>
                            </h4>
                            <div class="list-group">
                                <c:forEach var="grammar" items="${grammarResults}">
                                    <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${grammar.topicId}" 
                                       class="list-group-item custom-list-group-item">
                                        <i class="fas fa-puzzle-piece me-2"></i>
                                        <c:out value="${grammar.title}"/>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                </c:when>
                <c:otherwise>
                    <div class="search-prompt">
                        <i class="fas fa-search search-prompt-icon"></i>
                        <h2 class="search-title">Tìm kiếm</h2>
                        <p class="text-muted">Vui lòng nhập từ khóa vào ô tìm kiếm ở phía trên để bắt đầu khám phá nội dung học tập.</p>
                    </div>
                </c:otherwise>
            </c:choose>
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