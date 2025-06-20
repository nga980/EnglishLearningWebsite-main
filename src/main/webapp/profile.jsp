<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi"> 
<head>
    <meta charset="UTF-8">     
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Của Tôi</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="common/header.jsp"/>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h2>Hồ Sơ Của Tôi</h2>
                <hr>

                <%-- Hiển thị thông báo thành công (từ session) hoặc thất bại (từ request) --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success" role="alert">
                        <c:out value="${sessionScope.successMessage}"/>
                    </div>
                    <%-- Xóa message khỏi session sau khi đã hiển thị --%>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${requestScope.errorMessage}"/>
                    </div>
                </c:if>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Thông Tin Tài Khoản</h5>
                        <p><strong>Tên đăng nhập:</strong> <c:out value="${sessionScope.loggedInUser.username}"/></p>
                        <p><strong>Họ và tên:</strong> <c:out value="${sessionScope.loggedInUser.fullName}"/></p>
                        <p><strong>Email:</strong> <c:out value="${sessionScope.loggedInUser.email}"/></p>
                        <p><strong>Vai trò:</strong> <c:out value="${sessionScope.loggedInUser.role}"/></p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Đổi Mật Khẩu</h5>
                        <form method="POST" action="${pageContext.request.contextPath}/change-password">
                            <div class="form-group">
                                <label for="currentPassword">Mật khẩu hiện tại:</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">Mật khẩu mới:</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmNewPassword">Xác nhận mật khẩu mới:</label>
                                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>feather.replace();</script>
</body>
</html>