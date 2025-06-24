<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Bài Tập Ngữ Pháp - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <%-- Sao chép toàn bộ thẻ <style> từ file cũ của bạn vào đây --%>
    <style>
        /* ... Toàn bộ CSS của bạn ... */
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="common/header.jsp"/>
    
    <div class="main-container">
        <div class="result-header">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 text-center">
                        <h1 class="result-title fade-in-up">
                            <i class="fas fa-check-double me-3"></i>
                            Kết Quả Bài Tập
                        </h1>
                        <p class="result-subtitle fade-in-up stagger-1">
                            Chúc mừng bạn đã hoàn thành phần luyện tập!
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="score-card bounce-in stagger-2">
                <div class="score-display">
                    <c:set var="percentage" value="${(score / totalQuestions) * 100}" />
                    
                    <div class="score-percentage count-up">
                        <fmt:formatNumber value="${percentage}" maxFractionDigits="0" />%
                    </div>
                    
                    <div class="score-circle">
                        <div class="score-number">
                            <c:out value="${score}"/> / <c:out value="${totalQuestions}"/>
                        </div>
                    </div>

                    <p class="score-description">
                        Bạn đã trả lời đúng <strong><c:out value="${score}"/></strong> trên tổng số <strong><c:out value="${totalQuestions}"/></strong> câu hỏi.
                    </p>

                    <c:choose>
                        <c:when test="${percentage >= 80}">
                            <div class="performance-badge badge-excellent">
                                <i class="fas fa-star"></i> Xuất sắc! Bạn đã nắm vững kiến thức!
                            </div>
                        </c:when>
                        <c:when test="${percentage >= 60}">
                            <div class="performance-badge badge-good">
                                <i class="fas fa-thumbs-up"></i> Tốt! Tiếp tục phát huy nhé!
                            </div>
                        </c:when>
                        <c:when test="${percentage >= 40}">
                            <div class="performance-badge badge-average">
                                <i class="fas fa-chart-line"></i> Khá ổn! Hãy cố gắng hơn nữa!
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="performance-badge badge-poor">
                                <i class="fas fa-redo"></i> Cần cải thiện! Đừng nản lòng nhé!
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${grammarTopicId}" 
                           class="btn-modern btn-primary-modern">
                            <i class="fas fa-redo"></i>
                            Luyện tập lại
                        </a>
                        <a href="${pageContext.request.contextPath}/grammar" 
                           class="btn-modern btn-secondary-modern">
                            <i class="fas fa-list"></i>
                            Xem các chủ đề khác
                        </a>
                    </div>
                </div>
            </div>

            <div class="review-section fade-in-up stagger-3">
                <div class="review-header">
                    <h3 class="review-title">
                        <i class="fas fa-clipboard-list"></i>
                        Xem Lại Bài Làm Chi Tiết
                    </h3>
                </div>
                
                <c:forEach var="result" items="${detailedResults}" varStatus="loop">
                    <div class="question-item">
                        <div class="question-text">
                            <span class="question-number">${loop.count}</span>
                            <span><c:out value="${result.question.questionText}" escapeXml="false"/></span>
                        </div>
                        
                        <ul class="options-list">
                            <c:forEach var="option" items="${result.question.options}">
                                <c:set var="optionClass" value="option-neutral"/>
                                <c:set var="iconClass" value="icon-neutral"/>
                                <c:set var="iconSymbol" value="○"/>
                                
                                <c:if test="${option.isCorrect()}">
                                    <c:set var="optionClass" value="option-correct"/>
                                    <c:set var="iconClass" value="icon-correct"/>
                                    <c:set var="iconSymbol" value="✓"/>
                                </c:if>
                                
                                <c:if test="${option.optionId == result.selectedOptionId && !option.isCorrect()}">
                                    <c:set var="optionClass" value="option-wrong"/>
                                    <c:set var="iconClass" value="icon-wrong"/>
                                    <c:set var="iconSymbol" value="✗"/>
                                </c:if>

                                <li class="option-item ${optionClass}">
                                    <div style="display: flex; align-items: center; flex: 1;">
                                        <div class="option-icon ${iconClass}">
                                            ${iconSymbol}
                                        </div>
                                        <span class="option-text">
                                            <c:out value="${option.optionText}"/>
                                        </span>
                                    </div>
                                    
                                    <c:if test="${option.optionId == result.selectedOptionId}">
                                        <span class="user-choice-badge">
                                            <i class="fas fa-user"></i>
                                            Lựa chọn của bạn
                                        </span>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <footer class="mt-auto">
        <jsp:include page="/common/footer.jsp"/>
    </footer>
    
    <script>
        // Bạn có thể sao chép script từ quizResult.jsp vào đây nếu muốn giữ các hiệu ứng
    </script>
</body>
</html>