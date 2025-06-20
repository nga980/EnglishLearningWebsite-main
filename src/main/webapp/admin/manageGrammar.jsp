<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@page import="model.GrammarTopic" %>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Ngữ Pháp - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <%-- Navbar & Sidebar --%>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Quản Lý Chủ Đề Ngữ Pháp</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/admin/addGrammar.jsp" class="btn btn-sm btn-outline-primary">
                    <span data-feather="plus-circle"></span>
                    Thêm Chủ Đề Mới
                </a>
            </div>
        </div>

        <c:if test="${not empty sessionScope.successMessage_grammar}">
            <div class="alert alert-success" role="alert">
                <c:out value="${sessionScope.successMessage_grammar}"/>
            </div>
            <% session.removeAttribute("successMessage_grammar"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage_grammar}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${sessionScope.errorMessage_grammar}"/>
            </div>
            <% session.removeAttribute("errorMessage_grammar"); %>
        </c:if>

        <div class="table-responsive">
            <table class="table table-striped table-sm">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tiêu Đề</th>
                        <th>Mức Độ</th>
                        <th>Ngày Tạo</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty grammarTopicList}">
                            <c:forEach var="topic" items="${grammarTopicList}">
                                <tr>
                                    <td><c:out value="${topic.topicId}"/></td>
                                    <td><c:out value="${topic.title}"/></td>
                                    <td><c:out value="${topic.difficultyLevel}"/></td>
                                    <td><fmt:formatDate value="${topic.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/edit-grammar-form?topicId=${topic.topicId}" class="btn btn-sm btn-info">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin/delete-grammar?topicId=${topic.topicId}" class="btn btn-sm btn-danger ml-1" onclick="return confirm('Bạn có chắc chắn muốn xóa chủ đề ngữ pháp này không?');">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center">Không có chủ đề ngữ pháp nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-grammar?page=${currentPage - 1}">Trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-grammar?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-grammar?page=${currentPage + 1}">Sau</a>
                    </li>
                </ul>
            </nav>
        </c:if>
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