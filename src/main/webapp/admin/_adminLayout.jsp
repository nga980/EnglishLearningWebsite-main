<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        /* === FIXED ADMIN LAYOUT CSS === */

        /* Custom CSS cho admin layout */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            padding-top: 0; /* Xóa padding-top mặc định */
        }

        /* Navbar styling */
        .admin-navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
            z-index: 1030;
            height: 56px; /* Đảm bảo chiều cao cố định */
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }

        /* Desktop Sidebar styling */
        .admin-sidebar {
            position: fixed;
            top: 56px; /* Navbar height */
            bottom: 0;
            left: 0;
            z-index: 1000;
            padding: 0;
            overflow-x: hidden;
            overflow-y: auto;
            background-color: #343a40;
            border-right: 1px solid #dee2e6;
            width: 250px; /* Chiều rộng cố định */
        }

        .sidebar-sticky {
            position: sticky;
            top: 0;
            height: calc(100vh - 56px);
            padding-top: 1rem;
        }

        .admin-nav-link {
            color: #adb5bd !important;
            padding: 0.75rem 1rem;
            margin-bottom: 0.25rem;
            border-radius: 0.25rem;
            transition: all 0.3s ease;
        }

        .admin-nav-link:hover {
            color: #fff !important;
            background-color: #495057;
            text-decoration: none;
        }

        .admin-nav-link.active {
            color: #007bff !important;
            background-color: rgba(0, 123, 255, 0.1);
            font-weight: 500;
        }

        .admin-nav-link i {
            margin-right: 0.5rem;
            width: 16px;
            text-align: center;
        }

        /* Main content area - KEY FIX */
        .admin-main {
           margin-left: 250px; /* Bằng chiều rộng sidebar */
            padding-top: 56px; /* Chỉ bằng chiều cao navbar */
            padding-left: 0; /* Loại bỏ padding trái */
            padding-right: 0; /* Loại bỏ padding phải */
            padding-bottom: 0; /* Loại bỏ padding dưới */
            min-height: auto; /* Không force min-height */
        }

        /* Container fluid trong main */
        .admin-main .container-fluid {
            padding-left: 0;
            padding-right: 0;
        }

        /* User info styling */
        .user-info { 
            display: flex; 
            align-items: center; 
        }

        .user-avatar {
            width: 32px; 
            height: 32px; 
            border-radius: 50%; 
            background-color: #007bff;
            display: flex; 
            align-items: center; 
            justify-content: center;
            margin-right: 0.5rem; 
            font-size: 0.875rem; 
            font-weight: bold; 
            color: white;
        }

        .btn-logout { 
            border-radius: 20px; 
            padding: 0.375rem 1rem; 
            font-size: 0.875rem; 
        }

        /* Offcanvas sidebar for mobile */
        .offcanvas-sidebar {
            position: fixed;
            top: 0;
            left: -280px;
            width: 280px;
            height: 100%;
            background-color: #343a40;
            transition: left 0.3s ease;
            z-index: 1040;
            overflow-y: auto;
        }

        .offcanvas-sidebar.show {
            left: 0;
        }

        .offcanvas-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1039;
            display: none;
        }

        .offcanvas-overlay.show {
            display: block;
        }

        /* === RESPONSIVE DESIGN - KEY FIX === */
        @media (max-width: 991.98px) {
            .admin-sidebar {
                display: none; /* Ẩn sidebar desktop */
            }

            .admin-main {
                margin-left: 0; /* Xóa margin để content chiếm full width */
                padding-top: 56px; /* Vẫn giữ khoảng cách với navbar */
                padding-left: 15px; /* Padding phù hợp cho mobile */
                padding-right: 15px;
            }

            /* Đảm bảo navbar không che nội dung trên mobile */
            body {
                padding-top: 0;
            }
        }

        /* === ADDITIONAL FIXES === */

        /* Đảm bảo navbar luôn ở trên cùng */
        .navbar.fixed-top {
            position: fixed;
            top: 0;
            right: 0;
            left: 0;
            z-index: 1030;
        }

        /* Fix cho dropdown và các element khác */
        .dropdown-menu {
            z-index: 1035;
        }

        /* Đảm bảo content không bị che */
        .admin-main-content {
            /* Nếu bạn vẫn dùng class này */
            margin-left: 250px;
            padding-top: 56px;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .admin-main-content {
                margin-left: 0;
                padding-top: 56px;
            }
        }

        /* Fix cho mobile navbar toggle */
        .navbar-toggler {
            border: none;
            padding: 0.25rem 0.5rem;
        }

        .navbar-toggler:focus {
            box-shadow: none;
        }

        /* Đảm bảo mobile sidebar hoạt động tốt */
        @media (max-width: 991.98px) {
            .offcanvas-sidebar {
                padding-top: 56px; /* Để tránh che navbar */
            }

            .offcanvas-sidebar .p-4 {
                padding-top: 1rem !important;
            }
        }
    </style>
</head>
<body>

<%-- Navbar cố định --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top admin-navbar">
    <div class="container-fluid">
        <button class="navbar-toggler d-lg-none" type="button" onclick="toggleMobileSidebar()">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <a class="navbar-brand mx-auto mx-lg-0" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-cogs mr-2"></i>Admin Panel
        </a>
        
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home" target="_blank">
                        <i class="fas fa-external-link-alt mr-1"></i>Xem Website
                    </a>
                </li>
                <c:if test="${not empty sessionScope.loggedInUser}">
                    <li class="nav-item d-flex align-items-center">
                        <div class="user-info mr-3">
                            <div class="user-avatar">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loggedInUser.fullName}">${sessionScope.loggedInUser.fullName.substring(0,1).toUpperCase()}</c:when>
                                    <c:otherwise>${sessionScope.loggedInUser.username.substring(0,1).toUpperCase()}</c:otherwise>
                                </c:choose>
                            </div>
                            <span class="navbar-text text-light d-none d-md-inline">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loggedInUser.fullName}">${sessionScope.loggedInUser.fullName}</c:when>
                                    <c:otherwise>${sessionScope.loggedInUser.username}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-logout" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt mr-1"></i>Đăng Xuất
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div class="main-wrapper">
    <%-- Desktop Sidebar --%>
    <nav class="admin-sidebar d-none d-lg-block">
        <div class="sidebar-sticky">
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-lessons"><i class="fas fa-book"></i>Quản Lý Bài Học</a></li>
                <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-vocabulary' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-vocabulary"><i class="fas fa-spell-check"></i>Quản Lý Từ Vựng</a></li>
                <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-grammar' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-grammar"><i class="fas fa-language"></i>Quản Lý Ngữ Pháp</a></li>
                <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-users"><i class="fas fa-users"></i>Quản Lý Người Dùng</a></li>
            </ul>
        </div>
    </nav>

    <%-- ===== KHU VỰC NỘI DUNG CHÍNH ===== --%>
    <main role="main" class="admin-main">
        <div class="container-fluid">
            <%-- CÁC TRANG CON (.jsp) SẼ ĐƯỢC NẠP VÀO ĐÂY --%>
            <%-- Ví dụ: <jsp:include page="${contentPage}" /> --%>
        </div>
    </main>
</div>

<%-- Mobile Sidebar (Offcanvas) --%>
<div class="offcanvas-overlay" id="offcanvasOverlay" onclick="toggleMobileSidebar()"></div>
<nav class="offcanvas-sidebar" id="mobileSidebar">
    <div class="p-4">
        <h5 class="text-white mb-4">Menu</h5>
        <ul class="nav flex-column">
             <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
             <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-lessons"><i class="fas fa-book"></i>Quản Lý Bài Học</a></li>
             <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-vocabulary' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-vocabulary"><i class="fas fa-spell-check"></i>Quản Lý Từ Vựng</a></li>
             <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-grammar' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-grammar"><i class="fas fa-language"></i>Quản Lý Ngữ Pháp</a></li>
             <li class="nav-item"><a class="nav-link admin-nav-link ${param.activePage == 'manage-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-users"><i class="fas fa-users"></i>Quản Lý Người Dùng</a></li>
        </ul>
    </div>
</nav>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Hàm đóng/mở mobile sidebar
    function toggleMobileSidebar() {
        document.getElementById('mobileSidebar').classList.toggle('show');
        document.getElementById('offcanvasOverlay').classList.toggle('show');
    }

    // Tự động đóng sidebar khi chuyển sang màn hình desktop
    window.addEventListener('resize', function() {
        if (window.innerWidth >= 992) {
            const sidebar = document.getElementById('mobileSidebar');
            const overlay = document.getElementById('offcanvasOverlay');
            
            if (sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
                overlay.classList.remove('show');
            }
        }
    });

    // Xử lý khi nhấn vào link trên mobile sidebar -> đóng sidebar
    document.querySelectorAll('.offcanvas-sidebar .admin-nav-link').forEach(link => {
        link.addEventListener('click', function() {
            toggleMobileSidebar();
        });
    });
</script>

</body>
</html>