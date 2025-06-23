<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng Ký Tài Khoản</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="register"/>
    </jsp:include>

    <style>
        body { background-color: #f8f9fa; }
        .register-container { 
            max-width: 500px;
            margin: 50px auto; 
            padding: 30px; 
            background-color: #fff; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        .required-field {
            color: red;
            margin-left: 2px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <h2 class="text-center mb-4">Đăng Ký Tài Khoản</h2>

            <%-- Sử dụng JSTL để hiển thị lỗi một cách an toàn và sạch sẽ --%>
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger">${requestScope.error}</div>
            </c:if>
            
            <form action="register" method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập:<span class="required-field">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu:<span class="required-field">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" required minlength="6">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu:<span class="required-field">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:<span class="required-field">*</span></label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" class="form-control" id="fullName" name="fullName">
                </div>
                <button type="submit" class="btn btn-primary btn-block">Đăng Ký</button>
                <p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập tại đây</a></p>
            </form>
        </div>
    </div>

    <%-- Đảm bảo đường dẫn đến footer là tuyệt đối --%>
    <jsp:include page="/common/footer.jsp"/>
</body>
</html>