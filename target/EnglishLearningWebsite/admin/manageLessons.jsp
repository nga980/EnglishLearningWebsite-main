<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Lesson" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Bài Học - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
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
                    <h1 class="h2">Quản Lý Bài Học</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/addLesson.jsp" class="btn btn-sm btn-outline-primary">
                            <span data-feather="plus-circle"></span>
                            Thêm Bài Học Mới
                        </a>
                    </div>
                </div>

                    <%-- Hiển thị thông báo (nếu có) từ session sau khi thêm/sửa/xóa --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success" role="alert">
                            <c:out value="${sessionScope.successMessage}"/>
                        </div>
                        <% session.removeAttribute("successMessage"); // Xóa message sau khi hiển thị %>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            <c:out value="${sessionScope.errorMessage}"/>
                        </div>
                        <% session.removeAttribute("errorMessage"); // Xóa message sau khi hiển thị %>
                    </c:if>

                <div class="table-responsive">
                    <table class="table table-striped table-sm">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu Đề</th>
                                <th>Ngày Tạo</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty lessonList}">
                                    <c:forEach var="lesson" items="${lessonList}">
                                        <tr>
                                            <td><c:out value="${lesson.lessonId}"/></td>
                                            <td><c:out value="${lesson.title}"/></td>
                                            <td><fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/edit-lesson-form?lessonId=${lesson.lessonId}" class="btn btn-sm btn-info">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${lesson.lessonId}" class="btn btn-sm btn-success ml-1">Quiz</a>
                                                <a href="${pageContext.request.contextPath}/admin/delete-lesson?lessonId=${lesson.lessonId}" 
                                                    class="btn btn-sm btn-danger ml-1" 
                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này không? Các dữ liệu liên quan (ví dụ: từ vựng, câu hỏi quiz thuộc bài học này) có thể cũng bị ảnh hưởng tùy theo thiết lập CSDL.');">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center">Không có bài học nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                    <%-- THÊM KHỐI PHÂN TRANG VÀO ĐÂY --%>
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <%-- Nút Previous --%>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${currentPage - 1}">Trước</a>
                            </li>

                            <%-- Các nút số trang --%>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <%-- Nút Next --%>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${currentPage + 1}">Sau</a>
                            </li>
                        </ul>
                    </nav>
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