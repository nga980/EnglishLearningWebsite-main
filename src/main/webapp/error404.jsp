<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không Tìm Thấy Trang</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .error-container { text-align: center; margin-top: 100px; }
        .error-code { font-size: 10rem; font-weight: bold; }
        .error-message { font-size: 1.5rem; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>

    <div class="container error-container">
        <div class="error-code">404</div>
        <div class="error-message">Oops! Không tìm thấy trang bạn yêu cầu.</div>
        <p class="text-muted">Có vẻ như đường dẫn đã bị sai hoặc trang đã được di chuyển.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary mt-3">Quay về Trang Chủ</a>
    </div>
</body>
</html>