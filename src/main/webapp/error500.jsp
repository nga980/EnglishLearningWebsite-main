<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Dòng này rất quan trọng để trang lỗi không tự gây ra lỗi khác --%>
<%@page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi Hệ Thống</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .error-container { text-align: center; margin-top: 100px; }
        .error-code { font-size: 10rem; font-weight: bold; color: #dc3545; }
        .error-message { font-size: 1.5rem; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>

    <div class="container error-container">
        <div class="error-code">500</div>
        <div class="error-message">Oops! Đã có lỗi xảy ra trên hệ thống.</div>
        <p class="text-muted">Chúng tôi đang làm việc để khắc phục sự cố. Vui lòng thử lại sau.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary mt-3">Quay về Trang Chủ</a>
    </div>
</body>
</html>