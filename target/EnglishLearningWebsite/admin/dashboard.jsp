<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn, cần thiết nếu có scriptlet dùng User --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- URI này đúng cho Tomcat 10/11+ (Jakarta EE 9+) --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">          

            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Dashboard</h1>
                </div>
                <p>Chào mừng bạn đến với trang quản trị của Website Học Tiếng Anh.</p>
                <p>Vui lòng chọn một mục từ thanh điều hướng bên trái để bắt đầu quản lý.</p>

                <div class="row">
                    <div class="col-md-4">
                        <div class="card text-white bg-primary mb-3">
                            <div class="card-header">Tổng số bài học</div>
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalLessons}"/></h5>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-header">Tổng số từ vựng</div>
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalVocabulary}"/></h5>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-info mb-3">
                            <div class="card-header">Số người dùng</div>
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalUsers}"/></h5>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script> <%-- Popper v2, Bootstrap 4 dùng v1.16.1 --%>
    <%-- <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script> --%>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>feather.replace();</script>
</body>
</html>