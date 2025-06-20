<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Từ Vựng Mới - Admin</title>
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
                    <h1 class="h2">Thêm Từ Vựng Mới</h1>
                </div>

                <c:if test="${not empty requestScope.errorMessage_addVocab}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${requestScope.errorMessage_addVocab}"/>
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/admin/add-vocabulary-action">
                    <div class="form-group">
                        <label for="vocabWord"><strong>Từ (Word):</strong></label>
                        <input type="text" class="form-control form-control-lg" id="vocabWord" name="vocabWord" required value="<c:out value='${param.vocabWord}'/>">
                    </div>
                    <div class="form-group">
                        <label for="vocabMeaning"><strong>Nghĩa (Meaning):</strong></label>
                        <input type="text" class="form-control form-control-lg" id="vocabMeaning" name="vocabMeaning" required value="<c:out value='${param.vocabMeaning}'/>">
                    </div>
                    <div class="form-group">
                        <label for="vocabExample"><strong>Ví dụ (Example):</strong></label>
                        <textarea class="form-control form-control-lg" id="vocabExample" name="vocabExample" rows="3"><c:out value='${param.vocabExample}'/></textarea>
                    </div>
                    <div class="form-group">
                        <label for="lessonId"><strong>Lesson ID (Tùy chọn - nhập ID của bài học liên quan):</strong></label>
                        <input type="number" class="form-control form-control-lg" id="lessonId" name="lessonId" placeholder="Để trống nếu không có" value="<c:out value='${param.lessonId}'/>">
                        <small class="form-text text-muted">Nếu từ vựng này thuộc một bài học cụ thể, hãy nhập ID của bài học đó. Nếu không, để trống.</small>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg">Thêm Từ Vựng</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-vocabulary" class="btn btn-secondary btn-lg">Hủy</a>
                </form>
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