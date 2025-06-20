<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Lesson" %> <%-- Giữ nguyên package của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Bài Học - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
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
                            <a class="nav-link admin-nav-link active" href="${pageContext.request.contextPath}/admin/manage-lessons">
                                <span data-feather="file-text"></span> Quản Lý Bài Học <span class="sr-only">(current)</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link admin-nav-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary">
                                <span data-feather="book-open"></span> Quản Lý Từ Vựng
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
                    <h1 class="h2">Sửa Bài Học</h1>
                </div>

                <c:if test="${not empty requestScope.lessonToEdit}">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/update-lesson-action">
                        <%-- Trường ẩn để lưu lessonId --%>
                        <input type="hidden" name="lessonId" value="<c:out value='${lessonToEdit.lessonId}'/>">

                        <div class="form-group">
                            <label for="lessonTitle"><strong>Tiêu đề bài học:</strong></label>
                            <input type="text" class="form-control form-control-lg" id="lessonTitle" name="lessonTitle" required
                                   value="<c:out value='${lessonToEdit.title}'/>">
                        </div>
                        <div class="form-group">
                            <label for="lessonContent"><strong>Nội dung bài học:</strong></label>
                            <textarea class="form-control form-control-lg" id="lessonContent" name="lessonContent" rows="10" required><c:out value='${lessonToEdit.content}'/></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-lg">Cập Nhật Bài Học</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-lessons" class="btn btn-secondary btn-lg">Hủy</a>
                    </form>
                </c:if>
                <c:if test="${empty requestScope.lessonToEdit}">
                    <div class="alert alert-danger" role="alert">
                        Không tìm thấy thông tin bài học để sửa. <a href="${pageContext.request.contextPath}/admin/manage-lessons" class="alert-link">Quay lại danh sách</a>.
                    </div>
                </c:if>
                 <%-- Hiển thị thông báo lỗi nếu có từ servlet khi forward (ít dùng hơn session cho redirect) --%>
                <c:if test="${not empty requestScope.errorMessage_editLesson}">
                    <div class="alert alert-danger mt-3" role="alert">
                        <c:out value="${requestScope.errorMessage_editLesson}"/>
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
        <script>
        tinymce.init({
          selector: 'textarea#lessonContent', // Tìm đến textarea có ID là 'lessonContent'
          plugins: [ // Danh sách các plugin (tính năng) bạn muốn dùng
            'advlist', 'lists', 'link', 'image', 'charmap', 'preview',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'help', 'wordcount'
          ],
          toolbar: 'undo redo | blocks | ' +
            'bold italic forecolor | alignleft aligncenter ' +
            'alignright alignjustify | bullist numlist outdent indent | ' +
            'removeformat | help'
        });
    </script>
</body>
</html>