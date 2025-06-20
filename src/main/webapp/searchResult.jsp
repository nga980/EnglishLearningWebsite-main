<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Kết Quả Tìm Kiếm cho: <c:out value="${searchedKeyword}"/></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .result-category {
            margin-top: 30px;
            border-top: 2px solid #007bff;
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>

    <div class="container mt-4">
        <c:choose>
            <c:when test="${not empty searchedKeyword}">
                <h2>Kết quả tìm kiếm cho: "<i><c:out value="${searchedKeyword}"/></i>"</h2>
                <hr>

                <%-- Kiểm tra xem có kết quả nào không --%>
                <c:if test="${empty lessonResults && empty vocabResults && empty grammarResults}">
                    <div class="alert alert-warning mt-4">
                        Không tìm thấy kết quả nào phù hợp với từ khóa của bạn.
                    </div>
                </c:if>

                <%-- Phần kết quả Bài Học --%>
                <c:if test="${not empty lessonResults}">
                    <div class="result-category">
                        <h4>Bài học liên quan</h4>
                        <div class="list-group">
                            <c:forEach var="lesson" items="${lessonResults}">
                                <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lesson.lessonId}" class="list-group-item list-group-item-action">
                                    <c:out value="${lesson.title}"/>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <%-- Phần kết quả Từ Vựng --%>
                <c:if test="${not empty vocabResults}">
                    <div class="result-category">
                        <h4>Từ vựng liên quan</h4>
                        <ul class="list-group">
                            <c:forEach var="vocab" items="${vocabResults}">
                                <li class="list-group-item">
                                    <strong><c:out value="${vocab.word}"/>:</strong> <c:out value="${vocab.meaning}"/>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <%-- Phần kết quả Ngữ Pháp --%>
                <c:if test="${not empty grammarResults}">
                    <div class="result-category">
                        <h4>Chủ đề ngữ pháp liên quan</h4>
                        <div class="list-group">
                            <c:forEach var="grammar" items="${grammarResults}">
                                <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${grammar.topicId}" class="list-group-item list-group-item-action">
                                    <c:out value="${grammar.title}"/>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

            </c:when>
            <c:otherwise>
                <h2>Tìm kiếm</h2>
                <hr>
                <p>Vui lòng nhập từ khóa vào ô tìm kiếm ở phía trên để bắt đầu.</p>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="/common/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>