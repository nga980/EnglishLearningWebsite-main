<%-- File: /admin/_adminLayout.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <!-- Bootstrap 4.5.2 CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome cho icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        /* Custom CSS cho admin layout */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        /* Navbar styling */
        .admin-navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
            z-index: 1030;
        }
        
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        /* Sidebar styling */
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
        }
        
        .sidebar-sticky {
            position: sticky;
            top: 0;
            height: calc(100vh - 56px);
            padding-top: 1rem;
            overflow-x: hidden;
            overflow-y: auto;
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
        
        /* Main content area */
        .admin-main {
            margin-left: 16.66667%; /* 2/12 columns */
            padding-top: 56px; /* Navbar height */
            min-height: 100vh;
        }
        
        /* Mobile sidebar */
        .mobile-sidebar {
            display: none;
        }
        
        /* Responsive design */
        @media (max-width: 767.98px) {
            .admin-sidebar {
                display: none;
            }
            
            .admin-main {
                margin-left: 0;
            }
            
            .mobile-sidebar {
                display: block;
                background-color: #343a40;
                margin-top: 56px;
            }
            
            .mobile-sidebar .nav-link {
                color: #adb5bd !important;
                border-bottom: 1px solid #495057;
            }
            
            .mobile-sidebar .nav-link:hover,
            .mobile-sidebar .nav-link.active {
                color: #007bff !important;
                background-color: rgba(0, 123, 255, 0.1);
                font-weight: 500;
            }
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
        
        /* Logout button styling */
        .btn-logout {
            border-radius: 20px;
            padding: 0.375rem 1rem;
            font-size: 0.875rem;
        }
        
        /* Offcanvas sidebar for mobile */
        .offcanvas-sidebar {
            position: fixed;
            top: 56px;
            left: -250px;
            width: 250px;
            height: calc(100vh - 56px);
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
            top: 56px;
            left: 0;
            width: 100%;
            height: calc(100vh - 56px);
            background-color: rgba(0,0,0,0.5);
            z-index: 1039;
            display: none;
        }
        
        .offcanvas-overlay.show {
            display: block;
        }
    </style>
</head>
<body>

<%-- Navbar cố định ở trên cùng cho Admin Panel --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top admin-navbar">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-cogs mr-2"></i>Admin Panel
        </a>
        
        <!-- Mobile menu toggle -->
        <button class="navbar-toggler d-lg-none" type="button" onclick="toggleMobileSidebar()">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Desktop navbar toggle -->
        <button class="navbar-toggler d-none d-lg-block" type="button" data-toggle="collapse" data-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
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
                                    <c:when test="${not empty sessionScope.loggedInUser.fullName}">
                                        ${sessionScope.loggedInUser.fullName.substring(0,1).toUpperCase()}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.loggedInUser.username.substring(0,1).toUpperCase()}
                                    </c:otherwise>
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

<%-- Desktop Sidebar --%>
<nav class="col-md-2 d-none d-md-block admin-sidebar">
    <div class="sidebar-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-lessons' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-lessons">
                    <i class="fas fa-book"></i>Quản Lý Bài Học
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-vocabulary' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-vocabulary">
                    <i class="fas fa-spell-check"></i>Quản Lý Từ Vựng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-grammar' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-grammar">
                    <i class="fas fa-language"></i>Quản Lý Ngữ Pháp
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-users' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-users">
                    <i class="fas fa-users"></i>Quản Lý Người Dùng
                </a>
            </li>
        </ul>
    </div>
</nav>

<%-- Mobile Sidebar (Offcanvas) --%>
<div class="offcanvas-overlay" id="offcanvasOverlay" onclick="toggleMobileSidebar()"></div>
<nav class="offcanvas-sidebar" id="mobileSidebar">
    <div class="p-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/dashboard" onclick="toggleMobileSidebar()">
                    <i class="fas fa-tachometer-alt"></i>Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-lessons' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-lessons" onclick="toggleMobileSidebar()">
                    <i class="fas fa-book"></i>Quản Lý Bài Học
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-vocabulary' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-vocabulary" onclick="toggleMobileSidebar()">
                    <i class="fas fa-spell-check"></i>Quản Lý Từ Vựng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-grammar' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-grammar" onclick="toggleMobileSidebar()">
                    <i class="fas fa-language"></i>Quản Lý Ngữ Pháp
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-users' ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/manage-users" onclick="toggleMobileSidebar()">
                    <i class="fas fa-users"></i>Quản Lý Người Dùng
                </a>
            </li>
        </ul>
    </div>
</nav>

<!-- Bootstrap 4.5.2 JavaScript và dependencies -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
// Mobile sidebar toggle function
function toggleMobileSidebar() {
    const sidebar = document.getElementById('mobileSidebar');
    const overlay = document.getElementById('offcanvasOverlay');
    
    sidebar.classList.toggle('show');
    overlay.classList.toggle('show');
}

// Close mobile sidebar when clicking outside
document.addEventListener('click', function(event) {
    const sidebar = document.getElementById('mobileSidebar');
    const navbarToggler = document.querySelector('.navbar-toggler');
    
    if (!sidebar.contains(event.target) && !navbarToggler.contains(event.target) && sidebar.classList.contains('show')) {
        toggleMobileSidebar();
    }
});

// Close mobile sidebar on window resize if desktop view
window.addEventListener('resize', function() {
    if (window.innerWidth >= 768) {
        const sidebar = document.getElementById('mobileSidebar');
        const overlay = document.getElementById('offcanvasOverlay');
        
        if (sidebar.classList.contains('show')) {
            sidebar.classList.remove('show');
            overlay.classList.remove('show');
        }
    }
});
</script>

</body>
</html>