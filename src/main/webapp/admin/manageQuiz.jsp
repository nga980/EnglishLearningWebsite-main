<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@page import="model.Lesson" %>
<%@page import="model.QuizQuestion" %>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Quiz cho: <c:out value="${lesson.title}"/></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Quản Lý Quiz cho Bài Học: "<c:out value="${lesson.title}"/>"</h1>
            <a href="${pageContext.request.contextPath}/admin/manage-lessons" class="btn btn-sm btn-outline-secondary">
                <span data-feather="arrow-left"></span>
                Quay lại Danh sách Bài học
            </a>
        </div>

        <%-- Hiển thị thông báo (nếu có) --%>
        <c:if test="${not empty sessionScope.successMessage_quiz}">
            <div class="alert alert-success" role="alert">
                <c:out value="${sessionScope.successMessage_quiz}"/>
            </div>
            <% session.removeAttribute("successMessage_quiz"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage_quiz}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${sessionScope.errorMessage_quiz}"/>
            </div>
            <% session.removeAttribute("errorMessage_quiz"); %>
        </c:if>

        <%-- Phần 1: Danh sách các câu hỏi đã có --%>
        <div class="mb-5">
            <h4>Các câu hỏi hiện có</h4>
            <c:choose>
                <c:when test="${not empty questionList}">
                        <c:forEach var="question" items="${questionList}" varStatus="loop">
                            <div class="card mb-3">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <strong>Câu ${loop.count}: <c:out value="${question.questionText}"/></strong>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/edit-quiz-question-form?questionId=${question.questionId}" 
                                           class="btn btn-sm btn-info">
                                            <i data-feather="edit-3"></i> Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/delete-quiz-question?questionId=${question.questionId}&lessonId=${lesson.lessonId}" 
                                           class="btn btn-sm btn-outline-danger" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?');">
                                            <i data-feather="trash-2"></i> Xóa
                                        </a>
                                    </div>
                                </div>                      
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="option" items="${question.options}">
                                        <li class="list-group-item ${option.isCorrect ? 'correct-answer' : ''}">
                                            <c:out value="${option.optionText}"/>
                                            <c:if test="${option.isCorrect}"> (Đáp án đúng)</c:if>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:forEach>
                    </c:when>
                <c:otherwise>
                    <p class="text-muted">Chưa có câu hỏi nào cho bài học này.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <hr>

        <%-- Phần 2: Form thêm câu hỏi mới --%>
        <div class="mt-4">
            <h4>Thêm Câu Hỏi Mới</h4>
            <form method="POST" action="${pageContext.request.contextPath}/admin/add-quiz-question">
                <%-- Trường ẩn để lưu lessonId --%>
                <input type="hidden" name="lessonId" value="<c:out value='${lesson.lessonId}'/>">

                <div class="form-group">
                    <label for="questionText"><strong>Nội dung câu hỏi:</strong></label>
                    <textarea class="form-control" id="questionText" name="questionText" rows="3" required></textarea>
                </div>

                <p><strong>Các lựa chọn và đáp án đúng:</strong></p>
                <div class="form-group row">
                    <label class="col-sm-1 col-form-label">A.</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="optionText" placeholder="Nội dung lựa chọn A" required>
                    </div>
                    <div class="col-sm-1 d-flex align-items-center">
                        <input class="form-check-input" type="radio" name="correctOption" id="correctA" value="0" required>
                        <label class="form-check-label" for="correctA">Đúng</label>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-1 col-form-label">B.</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="optionText" placeholder="Nội dung lựa chọn B" required>
                    </div>
                    <div class="col-sm-1 d-flex align-items-center">
                        <input class="form-check-input" type="radio" name="correctOption" id="correctB" value="1">
                        <label class="form-check-label" for="correctB">Đúng</label>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-1 col-form-label">C.</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="optionText" placeholder="Nội dung lựa chọn C">
                    </div>
                    <div class="col-sm-1 d-flex align-items-center">
                        <input class="form-check-input" type="radio" name="correctOption" id="correctC" value="2">
                        <label class="form-check-label" for="correctC">Đúng</label>
                    </div>
                </div>
                 <div class="form-group row">
                    <label class="col-sm-1 col-form-label">D.</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="optionText" placeholder="Nội dung lựa chọn D">
                    </div>
                    <div class="col-sm-1 d-flex align-items-center">
                        <input class="form-check-input" type="radio" name="correctOption" id="correctD" value="3">
                        <label class="form-check-label" for="correctD">Đúng</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Thêm Câu Hỏi</button>
            </form>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>
      feather.replace();
    </script>
</body>
</html>