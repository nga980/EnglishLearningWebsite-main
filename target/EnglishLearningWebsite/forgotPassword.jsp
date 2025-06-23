<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - English Learning</title>
    <jsp:include page="common/header.jsp"/>
    <style>
        .form-container {
            max-width: 500px;
            margin: 5rem auto;
            padding: 2rem;
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            background-color: #f9f9f9;
        }
    </style>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="d-flex flex-column h-75">
    <div class="container">
        <div class="form-container">
            <h2 class="text-center mb-4">Quên Mật Khẩu</h2>
            <p class="text-center text-muted mb-4">Vui lòng nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi một đường link để bạn đặt lại mật khẩu.</p>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success" role="alert">
                    ${message}
                </div>
            </c:if>

            <form action="forgot-password" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Địa chỉ email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Gửi yêu cầu</button>
            </form>
            <div class="text-center mt-3">
                <a href="login">Quay lại trang đăng nhập</a>
            </div>
        </div>
    </div>
    <footer class="mt-auto">
        <jsp:include page="/common/footer.jsp"/>
    </footer>
</body>
</html>