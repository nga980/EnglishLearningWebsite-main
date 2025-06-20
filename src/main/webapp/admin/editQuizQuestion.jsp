<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Câu Hỏi Quiz - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Sửa Câu Hỏi Quiz</h1>
             <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${questionToEdit.lessonId}" class="btn btn-sm btn-outline-secondary">
                <span data-feather="arrow-left"></span>
                Quay lại Quản lý Quiz
            </a>
        </div>

        <c:if test="${not empty questionToEdit}">
            <form method="POST" action="${pageContext.request.contextPath}/admin/update-quiz-question">
                <%-- Các trường ẩn quan trọng --%>
                <input type="hidden" name="questionId" value="<c:out value='${questionToEdit.questionId}'/>">
                <input type="hidden" name="lessonId" value="<c:out value='${questionToEdit.lessonId}'/>">

                <div class="form-group">
                    <label for="questionText"><strong>Nội dung câu hỏi:</strong></label>
                    <textarea class="form-control" id="questionText" name="questionText" rows="3" required><c:out value='${questionToEdit.questionText}'/></textarea>
                </div>

                <p><strong>Các lựa chọn và đáp án đúng:</strong></p>

                <c:forEach var="option" items="${questionToEdit.options}" varStatus="loop">
                    <div class="form-group row">
                        <label class="col-sm-1 col-form-label">Lựa chọn ${loop.count}:</label>
                        <div class="col-sm-10">
                            <%-- Trường ẩn để lưu optionId --%>
                            <input type="hidden" name="optionId" value="${option.optionId}">
                            <input type="text" class="form-control" name="optionText" value="<c:out value='${option.optionText}'/>" required>
                        </div>
                        <div class="col-sm-1 d-flex align-items-center">
                            <input class="form-check-input" type="radio" name="correctOptionIndex" 
                                   value="${loop.index}" ${option.isCorrect ? 'checked' : ''} required>
                            <label class="form-check-label">Đúng</label>
                        </div>
                    </div>
                </c:forEach>

                <button type="submit" class="btn btn-primary">Cập Nhật Câu Hỏi</button>
                <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${questionToEdit.lessonId}" class="btn btn-secondary">Hủy</a>
            </form>
        </c:if>

        <c:if test="${empty questionToEdit}">
            <div class="alert alert-danger">Không tìm thấy câu hỏi để sửa.</div>
        </c:if>

    </main>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>
      feather.replace();
    </script>
</body>
</html>