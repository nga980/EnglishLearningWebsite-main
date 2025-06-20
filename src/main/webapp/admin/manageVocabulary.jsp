<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Vocabulary" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Từ Vựng - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-vocabulary"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Quản Lý Từ Vựng</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/addVocabulary.jsp" class="btn btn-sm btn-outline-primary">
                            <span data-feather="plus-circle"></span>
                            Thêm Từ Vựng Mới
                        </a>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage_vocab}">
                    <div class="alert alert-success" role="alert">
                        <c:out value="${sessionScope.successMessage_vocab}"/>
                    </div>
                    <% session.removeAttribute("successMessage_vocab"); %>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage_vocab}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${sessionScope.errorMessage_vocab}"/>
                    </div>
                    <% session.removeAttribute("errorMessage_vocab"); %>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-striped table-sm">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Từ (Word)</th>
                                <th>Nghĩa (Meaning)</th>
                                <th>Ví dụ (Example)</th>
                                <th>Lesson ID</th>
                                <th>Ngày Tạo</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty vocabularyList}">
                                    <c:forEach var="vocab" items="${vocabularyList}">
                                        <tr>
                                            <td><c:out value="${vocab.vocabId}"/></td>
                                            <td><c:out value="${vocab.word}"/></td>
                                            <td><c:out value="${vocab.meaning}"/></td>
                                            <td><c:out value="${vocab.example}"/></td>
                                            <td>
                                                <c:if test="${not empty vocab.lessonId}">
                                                    <c:out value="${vocab.lessonId}"/>
                                                </c:if>
                                                <c:if test="${empty vocab.lessonId}">
                                                    N/A
                                                </c:if>
                                            </td>
                                            <td><fmt:formatDate value="${vocab.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/edit-vocabulary-form?vocabId=${vocab.vocabId}" class="btn btn-sm btn-info">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/admin/delete-vocabulary?vocabId=${vocab.vocabId}" class="btn btn-sm btn-danger ml-1" onclick="return confirm('Bạn có chắc chắn muốn xóa từ vựng này không?');">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center">Không có từ vựng nào.</td>
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
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${currentPage - 1}">Trước</a>
                            </li>
    
                            <%-- Các nút số trang --%>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
    
                            <%-- Nút Next --%>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${currentPage + 1}">Sau</a>
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