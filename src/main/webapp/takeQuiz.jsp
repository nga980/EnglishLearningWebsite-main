<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Làm Bài Trắc Nghiệm: <c:out value="${lesson.title}"/></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .quiz-question {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .question-text {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="lessons"/>
    </jsp:include>
    <div class="container mt-4">        

        <h2 class="mb-4">Bài Trắc Nghiệm: <c:out value="${lesson.title}"/></h2>

        <form method="POST" action="${pageContext.request.contextPath}/submit-quiz">
            <%-- Trường ẩn để gửi lessonId đi --%>
            <input type="hidden" name="lessonId" value="${lesson.lessonId}">

            <c:forEach var="question" items="${questionList}" varStatus="loop">
                <div class="quiz-question">
                    <div class="question-text">${loop.count}. <c:out value="${question.questionText}"/></div>

                    <%-- Hiển thị các lựa chọn cho câu hỏi --%>
                    <c:forEach var="option" items="${question.options}">
                        <div class="form-check">
                            <%-- 
                                - name="question_${question.questionId}" để nhóm các lựa chọn cho cùng 1 câu hỏi.
                                - value="${option.optionId}" để servlet biết người dùng đã chọn lựa chọn nào.
                            --%>
                            <input class="form-check-input" type="radio" 
                                   name="question_${question.questionId}" 
                                   id="option_${option.optionId}" 
                                   value="${option.optionId}" required>
                            <label class="form-check-label" for="option_${option.optionId}">
                                <c:out value="${option.optionText}"/>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary btn-lg">Nộp Bài</button>
            </div>
        </form>
    </div>
    <jsp:include page="/common/footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>