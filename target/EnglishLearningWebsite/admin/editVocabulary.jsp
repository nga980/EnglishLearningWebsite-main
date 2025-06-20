<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Vocabulary" %> <%-- Giữ nguyên package của bạn --%>
<%-- <%@page import="model.Lesson" %> --%> <%-- Tùy chọn: Nếu dùng dropdown Lesson --%>
<%-- <%@page import="java.util.List" %> --%> <%-- Tùy chọn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Từ Vựng - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-vocabulary"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-2 d-none d-md-block admin-sidebar">
                <div class="sidebar-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                <span data-feather="home"></span> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link" href="${pageContext.request.contextPath}/admin/manage-lessons">
                                <span data-feather="file-text"></span> Quản Lý Bài Học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link active" href="${pageContext.request.contextPath}/admin/manage-vocabulary">
                                <span data-feather="book-open"></span> Quản Lý Từ Vựng <span class="sr-only">(current)</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link" href="${pageContext.request.contextPath}/admin/manage-grammar">
                                <span data-feather="award"></span> Quản Lý Ngữ Pháp
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link" href="#">
                                <span data-feather="users"></span> Quản Lý Người Dùng
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Sửa Từ Vựng</h1>
                </div>

                <c:if test="${not empty requestScope.vocabToEdit}">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/update-vocabulary-action">
                        <input type="hidden" name="vocabId" value="<c:out value='${vocabToEdit.vocabId}'/>">

                        <div class="form-group">
                            <label for="vocabWord"><strong>Từ (Word):</strong></label>
                            <input type="text" class="form-control form-control-lg" id="vocabWord" name="vocabWord" required 
                                   value="<c:out value='${not empty requestScope.submittedVocabWord ? requestScope.submittedVocabWord : vocabToEdit.word}'/>">
                        </div>
                        <div class="form-group">
                            <label for="vocabMeaning"><strong>Nghĩa (Meaning):</strong></label>
                            <input type="text" class="form-control form-control-lg" id="vocabMeaning" name="vocabMeaning" required
                                   value="<c:out value='${not empty requestScope.submittedVocabMeaning ? requestScope.submittedVocabMeaning : vocabToEdit.meaning}'/>">
                        </div>
                        <div class="form-group">
                            <label for="vocabExample"><strong>Ví dụ (Example):</strong></label>
                            <textarea class="form-control form-control-lg" id="vocabExample" name="vocabExample" rows="3"><c:out value='${not empty requestScope.submittedVocabExample ? requestScope.submittedVocabExample : vocabToEdit.example}'/></textarea>
                        </div>
                        <div class="form-group">
                            <label for="lessonId"><strong>Lesson ID (Tùy chọn):</strong></label>
                            <input type="number" class="form-control form-control-lg" id="lessonId" name="lessonId" placeholder="Để trống nếu không có"
                                   value="<c:out value='${not empty requestScope.submittedLessonId ? requestScope.submittedLessonId : vocabToEdit.lessonId}'/>">
                            <%-- Tùy chọn: Thay bằng dropdown nếu muốn
                            <select class="form-control form-control-lg" id="lessonId" name="lessonId">
                                <option value="">-- Không chọn bài học --</option>
                                <c:forEach var="lesson" items="${requestScope.lessonsForSelect}">
                                    <option value="${lesson.lessonId}" ${lesson.lessonId == vocabToEdit.lessonId ? 'selected' : ''}>
                                        <c:out value="${lesson.title}"/> (ID: ${lesson.lessonId})
                                    </option>
                                </c:forEach>
                            </select>
                            --%>
                        </div>

                        <c:if test="${not empty requestScope.errorMessage_editVocab}">
                            <div class="alert alert-danger mt-2" role="alert">
                                <c:out value="${requestScope.errorMessage_editVocab}"/>
                            </div>
                        </c:if>

                        <button type="submit" class="btn btn-primary btn-lg mt-3">Cập Nhật Từ Vựng</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-vocabulary" class="btn btn-secondary btn-lg mt-3">Hủy</a>
                    </form>
                </c:if>
                <c:if test="${empty requestScope.vocabToEdit && empty requestScope.errorMessage_editVocab}"> <%-- Chỉ hiển thị nếu không có vocab và cũng không có lỗi forward --%>
                    <div class="alert alert-warning" role="alert">
                        Không tìm thấy thông tin từ vựng để sửa. <a href="${pageContext.request.contextPath}/admin/manage-vocabulary" class="alert-link">Quay lại danh sách</a>.
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>
      feather.replace();
    </script>
</body>
</html>