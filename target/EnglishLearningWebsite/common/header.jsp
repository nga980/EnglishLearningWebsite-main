<%-- File: /common/header.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%> <%-- Import User để có thể lấy thông tin từ session --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* Enhanced Header Styles - More Responsive & Compact */
    .navbar {
        background: rgba(255, 255, 255, 0.95) !important;
        backdrop-filter: blur(15px);
        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
        border-bottom: 1px solid rgba(102, 126, 234, 0.1);
        padding: 0.75rem 0;
        transition: all 0.3s ease;
        min-height: 60px;
    }

    .navbar-brand {
        font-weight: 700;
        font-size: 1.5rem;
        background: linear-gradient(45deg, #667eea, #764ba2);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-decoration: none;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        padding: 0.25rem 0;
    }

    .navbar-brand:hover {
        transform: scale(1.02);
        text-decoration: none;
    }

    .navbar-brand i {
        color: #667eea;
        margin-right: 0.4rem;
        font-size: 1.25rem;
    }

    .navbar-nav .nav-item {
        margin: 0 0.1rem;
    }

    .navbar-nav .nav-link {
        font-weight: 500;
        color: #2c3e50 !important;
        transition: all 0.3s ease;
        border-radius: 8px;
        padding: 0.6rem 0.8rem !important;
        position: relative;
        display: flex;
        align-items: center;
        font-size: 0.9rem;
    }

    .navbar-nav .nav-link i {
        margin-right: 0.4rem;
        font-size: 0.9rem;
        width: 16px;
        text-align: center;
    }

    .navbar-nav .nav-link:hover {
        background: rgba(102, 126, 234, 0.1);
        color: #667eea !important;
        transform: translateY(-1px);
    }

    .navbar-nav .nav-item.active .nav-link {
        background: linear-gradient(45deg, #667eea, #764ba2);
        color: white !important;
        box-shadow: 0 3px 12px rgba(102, 126, 234, 0.3);
    }

    .navbar-nav .nav-item.active .nav-link:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
    }

    /* Compact Search Form */
    .search-form {
        background: rgba(102, 126, 234, 0.05);
        border-radius: 20px;
        padding: 0.2rem;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
        border: 1px solid transparent;
        max-width: 300px;
        width: 100%;
    }

    .search-form:focus-within {
        background: rgba(102, 126, 234, 0.1);
        border-color: rgba(102, 126, 234, 0.3);
        transform: scale(1.01);
    }

    .search-form input {
        border: none;
        background: transparent;
        outline: none;
        padding: 0.5rem 0.8rem;
        color: #2c3e50;
        font-weight: 400;
        width: 100%;
        transition: all 0.3s ease;
        font-size: 0.9rem;
    }

    .search-form input::placeholder {
        color: #6c757d;
        font-weight: 400;
    }

    .search-form button {
        background: linear-gradient(45deg, #667eea, #764ba2);
        border: none;
        border-radius: 16px;
        padding: 0.45rem 0.8rem;
        color: white;
        font-weight: 500;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        font-size: 0.85rem;
        white-space: nowrap;
    }

    .search-form button:hover {
        transform: translateY(-1px);
        box-shadow: 0 3px 12px rgba(102, 126, 234, 0.3);
    }

    .search-form button i {
        margin-right: 0.3rem;
    }

    /* Compact Buttons */
    .btn-outline-primary {
        border-color: #667eea;
        color: #667eea;
        border-radius: 16px;
        padding: 0.45rem 1rem;
        font-weight: 500;
        transition: all 0.3s ease;
        border-width: 1.5px;
        text-decoration: none;
        display: flex;
        align-items: center;
        font-size: 0.85rem;
        white-space: nowrap;
    }

    .btn-outline-primary:hover {
        background: #667eea;
        border-color: #667eea;
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 3px 12px rgba(102, 126, 234, 0.3);
        text-decoration: none;
    }

    .btn-outline-primary i {
        margin-right: 0.3rem;
    }

    .btn-primary {
        background: linear-gradient(45deg, #667eea, #764ba2);
        border: none;
        border-radius: 16px;
        padding: 0.45rem 1rem;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: flex;
        align-items: center;
        font-size: 0.85rem;
        white-space: nowrap;
    }

    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 3px 12px rgba(102, 126, 234, 0.3);
        text-decoration: none;
    }

    .btn-primary i {
        margin-right: 0.3rem;
    }

    /* Compact Dropdown */
    .dropdown-toggle {
        background: rgba(102, 126, 234, 0.08);
        border-radius: 20px;
        padding: 0.5rem 0.8rem !important;
        border: 1px solid transparent;
        transition: all 0.3s ease;
        font-size: 0.9rem;
    }

    .dropdown-toggle:hover {
        background: rgba(102, 126, 234, 0.12);
        border-color: rgba(102, 126, 234, 0.2);
        text-decoration: none;
        color: #667eea !important;
    }

    .dropdown-toggle::after {
        margin-left: 0.5rem;
        border-top-color: #667eea;
    }

    .dropdown-menu {
        border: none;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
        backdrop-filter: blur(10px);
        background: rgba(255, 255, 255, 0.95);
        padding: 0.4rem;
        margin-top: 0.4rem;
        min-width: 200px;
    }

    .dropdown-item {
        border-radius: 8px;
        padding: 0.6rem 0.8rem;
        transition: all 0.3s ease;
        color: #2c3e50;
        font-weight: 500;
        display: flex;
        align-items: center;
        font-size: 0.9rem;
    }

    .dropdown-item:hover {
        background: rgba(102, 126, 234, 0.1);
        color: #667eea;
        transform: translateX(3px);
    }

    .dropdown-item i {
        margin-right: 0.6rem;
        width: 14px;
        color: #667eea;
        font-size: 0.85rem;
    }

    .dropdown-divider {
        border-color: rgba(102, 126, 234, 0.15);
        margin: 0.4rem 0;
    }

    .user-info {
        display: flex;
        align-items: center;
    }

    .user-avatar {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: linear-gradient(45deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        margin-right: 0.5rem;
        font-size: 0.8rem;
    }

    .admin-badge {
        background: linear-gradient(45deg, #e74c3c, #c0392b);
        color: white;
        padding: 0.15rem 0.4rem;
        border-radius: 8px;
        font-size: 0.7rem;
        font-weight: 600;
        margin-left: 0.4rem;
    }

    /* Enhanced Mobile Responsive */
    @media (max-width: 991px) {
        .navbar {
            padding: 0.5rem 0;
        }

        .navbar-brand {
            font-size: 1.3rem;
        }

        .navbar-brand i {
            font-size: 1.1rem;
            margin-right: 0.3rem;
        }

        .search-form {
            margin: 0.75rem 0;
            max-width: 100%;
        }

        .navbar-nav .nav-link {
            padding: 0.5rem 0.6rem !important;
            margin: 0.1rem 0;
        }

        .dropdown-toggle {
            padding: 0.4rem 0.6rem !important;
        }

        .user-avatar {
            width: 24px;
            height: 24px;
            font-size: 0.75rem;
        }

        .admin-badge {
            font-size: 0.65rem;
            padding: 0.1rem 0.3rem;
        }
    }

    @media (max-width: 768px) {
        .navbar-brand {
            font-size: 1.2rem;
        }

        .navbar-nav .nav-link {
            font-size: 0.85rem;
            padding: 0.4rem 0.5rem !important;
        }

        .search-form input {
            font-size: 0.85rem;
            padding: 0.4rem 0.6rem;
        }

        .search-form button {
            font-size: 0.8rem;
            padding: 0.4rem 0.6rem;
        }

        .btn-outline-primary,
        .btn-primary {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
        }

        .dropdown-item {
            font-size: 0.85rem;
            padding: 0.5rem 0.6rem;
        }
    }

    @media (max-width: 576px) {
        .navbar {
            padding: 0.4rem 0;
        }

        .navbar-brand {
            font-size: 1.1rem;
        }

        .navbar-nav .nav-link span {
            display: none;
        }

        .navbar-nav .nav-link i {
            margin-right: 0;
        }

        .search-form button span {
            display: none;
        }

        .btn-outline-primary span,
        .btn-primary span {
            display: none;
        }

        .user-info span {
            display: none;
        }

        .user-avatar {
            margin-right: 0;
        }
    }

    /* Navbar Toggler Enhancement */
    .navbar-toggler {
        border: none;
        padding: 0.3rem 0.5rem;
        border-radius: 8px;
        background: rgba(102, 126, 234, 0.1);
        transition: all 0.3s ease;
    }

    .navbar-toggler:hover {
        background: rgba(102, 126, 234, 0.15);
    }

    .navbar-toggler:focus {
        box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.25);
    }

    /* Animation */
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-8px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .dropdown-menu {
        animation: slideDown 0.25s ease;
    }

    /* Loading state for search */
    .search-form.loading button {
        opacity: 0.7;
        pointer-events: none;
    }

    .search-form.loading button i {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-graduation-cap"></i>
            <span>English Learning</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <%-- Các mục điều hướng chính --%>
            <ul class="navbar-nav mr-auto">
                <li class="nav-item ${param.activePage == 'home' ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i>
                        <span>Trang Chủ</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'lessons' ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/lessons">
                        <i class="fas fa-book"></i>
                        <span>Bài Học</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'vocabulary' ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/vocabulary">
                        <i class="fas fa-spell-check"></i>
                        <span>Từ Vựng</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'grammar' ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/grammar">
                        <i class="fas fa-language"></i>
                        <span>Ngữ Pháp</span>
                    </a>
                </li>
            </ul>
            
            <%-- FORM TÌM KIẾM --%>
            <form class="search-form mx-auto" action="${pageContext.request.contextPath}/search" method="GET">
                <input type="search" name="keyword" placeholder="Tìm kiếm..." aria-label="Search" value="<c:out value='${param.keyword}'/>">
                <button type="submit">
                    <i class="fas fa-search"></i>
                    <span>Tìm</span>
                </button>
            </form>    

            <%-- Thông tin người dùng và các nút chức năng --%>
            <ul class="navbar-nav ml-auto">
                <%
                    User loggedInUser = (User) session.getAttribute("loggedInUser");
                    if (loggedInUser != null) {
                        String userName = loggedInUser.getFullName() != null && !loggedInUser.getFullName().isEmpty() 
                                        ? loggedInUser.getFullName() : loggedInUser.getUsername();
                        String userInitial = userName.substring(0, 1).toUpperCase();
                    %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <%= userInitial %>
                                    </div>
                                    <span>
                                        <%= userName %>
                                        <% if ("ADMIN".equals(loggedInUser.getRole())) { %>
                                            <span class="admin-badge">Admin</span>
                                        <% } %>
                                    </span>
                                </div>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user"></i>
                                    Hồ sơ của tôi
                                </a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/quiz-history">
                                    <i class="fas fa-history"></i>
                                    Lịch sử học tập
                                </a>
                                <% if ("ADMIN".equals(loggedInUser.getRole())) { %>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                        <i class="fas fa-cog"></i>
                                        Trang quản trị
                                    </a>
                                <% } %>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt"></i>
                                    Đăng xuất
                                </a>
                            </div>
                        </li>
                    <%} else {
                    %>
                         <li class="nav-item">
                            <a class="btn btn-outline-primary mr-2" href="${pageContext.request.contextPath}/login.jsp">
                                <i class="fas fa-sign-in-alt"></i>
                                <span>Đăng Nhập</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/register.jsp">
                                <i class="fas fa-user-plus"></i>
                                <span>Đăng Ký</span>
                            </a>
                        </li>
                    <%
                        }
                %>
            </ul>
        </div>
    </div>
</nav>

<!-- Font Awesome Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<script>
// Enhanced search form functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.querySelector('.search-form');
    const searchInput = searchForm.querySelector('input');
    
    // Add loading state on form submit
    searchForm.addEventListener('submit', function() {
        this.classList.add('loading');
    });
    
    // Auto-focus search input on "/" key press
    document.addEventListener('keydown', function(e) {
        if (e.key === '/' && !e.ctrlKey && !e.metaKey && !e.altKey) {
            e.preventDefault();
            searchInput.focus();
        }
    });
});
</script>