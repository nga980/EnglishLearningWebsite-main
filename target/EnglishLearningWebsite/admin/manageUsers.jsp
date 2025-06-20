<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-users"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Quản Lý Người Dùng</h1>
        </div>

        <c:if test="${not empty sessionScope.successMessage_user}">
            <div class="alert alert-success" role="alert">
                <c:out value="${sessionScope.successMessage_user}"/>
            </div>
            <% session.removeAttribute("successMessage_user"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage_user}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${sessionScope.errorMessage_user}"/>
            </div>
            <% session.removeAttribute("errorMessage_user"); %>
        </c:if>

        <div class="table-responsive">
            <table class="table table-striped table-sm">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Email</th>
                        <th>Họ và Tên</th>
                        <th>Vai trò</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty userList}">
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td><c:out value="${user.userId}"/></td>
                                    <td><c:out value="${user.username}"/></td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td><c:out value="${user.fullName}"/></td>
                                    
                                    <%-- CỘT VAI TRÒ (ROLE) --%>
                                    <td>
                                        <%-- Nếu là tài khoản khác, hiển thị form thay đổi vai trò --%>
                                        <c:if test="${sessionScope.loggedInUser.userId != user.userId}">
                                            <form action="${pageContext.request.contextPath}/admin/update-user-role" method="POST" class="form-inline">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <select name="newRole" class="form-control form-control-sm mr-2">
                                                    <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>USER</option>
                                                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-primary">Lưu</button>
                                            </form>
                                        </c:if>
                                        <%-- Nếu là admin đang đăng nhập, chỉ hiển thị vai trò, không cho sửa --%>
                                        <c:if test="${sessionScope.loggedInUser.userId == user.userId}">
                                            <span class="badge badge-secondary"><c:out value="${user.role}"/> (Bạn)</span>
                                        </c:if>
                                    </td>
                                    
                                    <%-- CỘT HÀNH ĐỘNG (ACTION) --%>
                                    <td>
                                        <%-- Chỉ hiển thị nút Xóa nếu đây không phải là tài khoản admin đang đăng nhập --%>
                                        <c:if test="${sessionScope.loggedInUser.userId != user.userId}">
                                            <a href="${pageContext.request.contextPath}/admin/delete-user?userId=${user.userId}" 
                                               class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng \'${user.username}\' không? Hành động này không thể hoàn tác.');">Xóa</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center">Không có người dùng nào.</td>
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
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage - 1}">Trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage + 1}">Sau</a>
                    </li>
                </ul>
            </nav>
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