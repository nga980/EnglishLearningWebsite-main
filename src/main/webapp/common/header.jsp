<%-- File: /common/header.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    /* CSS của bạn đã được tối ưu và giữ lại ở đây */
    body {
        padding-top: 70px; /* Thêm padding để nội dung không bị header che mất */
    }
    
    .navbar {
        background: rgba(255, 255, 255, 0.95) !important;
        backdrop-filter: blur(15px);
        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
        padding: 0.5rem 1rem;
    }
    .navbar-brand {
        font-weight: 700;
        font-size: 1.4rem;
        background: linear-gradient(45deg, #667eea, #764ba2);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    .navbar-brand i {
        margin-right: 0.5rem;
    }
    .navbar-nav .nav-link {
        font-weight: 500;
        color: #2c3e50 !important;
        transition: all 0.3s ease;
        border-radius: 8px;
        padding: 0.6rem 1rem !important;
        font-size: 0.95rem;
    }
    .navbar-nav .nav-link:hover, .dropdown-item:hover {
        background: rgba(102, 126, 234, 0.1);
        color: #667eea !important;
    }
    .navbar-nav .nav-item.active > .nav-link {
        background: linear-gradient(45deg, #667eea, #764ba2);
        color: white !important;
        box-shadow: 0 3px 12px rgba(102, 126, 234, 0.3);
    }
    .dropdown-menu {
        border: none;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
        margin-top: 0.5rem;
    }
    .dropdown-menu-right {
        right: 0;
        left: auto;
    }
    .user-info {
        display: flex;
        align-items: center;
    }
    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: linear-gradient(45deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        margin-right: 0.75rem;
        font-size: 1rem;
    }
    .admin-badge {
        background: #e74c3c;
        color: white;
        padding: 0.2rem 0.5rem;
        border-radius: 8px;
        font-size: 0.75rem;
        font-weight: 600;
    }
    .search-form {
        background: rgba(102, 126, 234, 0.05);
        border-radius: 20px;
        padding: 0.2rem;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
        border: 1px solid transparent;
        width: 100%;
        max-width: 300px;
    }
    .search-form:focus-within {
        background: rgba(102, 126, 234, 0.1);
        border-color: rgba(102, 126, 234, 0.3);
    }
    .search-form input {
        border: none;
        background: transparent;
        outline: none;
        padding: 0.5rem 0.8rem;
        width: 100%;
    }
    .search-form button {
        background: linear-gradient(45deg, #667eea, #764ba2);
        border: none;
        border-radius: 16px;
        padding: 0.45rem 0.8rem;
        color: white;
        transition: all 0.3s ease;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-graduation-cap"></i>
            <span>Easy English</span>
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            
            <c:set var="path" value="${pageContext.request.servletPath}" />
            
            <ul class="navbar-nav mr-auto">
                <li class="nav-item ${path.endsWith('/home') or path eq '/' ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang Chủ</a>
                </li>
                <li class="nav-item ${path.contains('/lesson') ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/lessons"><i class="fas fa-book"></i> Bài Học</a>
                </li>
                <li class="nav-item ${path.contains('/vocabulary') ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/vocabulary"><i class="fas fa-spell-check"></i> Từ Vựng</a>
                </li>
                <li class="nav-item ${path.contains('/grammar') ? 'active' : ''}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/grammar"><i class="fas fa-language"></i> Ngữ Pháp</a>
                </li>
            </ul>

            <form class="search-form mx-auto" action="${pageContext.request.contextPath}/search" method="GET">
                <input class="form-control" type="search" name="keyword" placeholder="Tìm kiếm bài học, từ vựng..." aria-label="Search" value="${param.keyword}">
                <button type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <ul class="navbar-nav ml-auto">
                <%
                    User loggedInUser = (User) session.getAttribute("loggedInUser");
                    if (loggedInUser != null) {
                        String userName = loggedInUser.getFullName() != null && !loggedInUser.getFullName().isEmpty() 
                                        ? loggedInUser.getFullName() : loggedInUser.getUsername();
                        String userInitial = (userName != null && !userName.isEmpty()) ? userName.substring(0, 1).toUpperCase() : "?";
                %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <div class="user-info">
                                    <div class="user-avatar"><%= userInitial %></div>
                                    <span><%= userName %></span>
                                </div>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Hồ sơ</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/quiz-history"><i class="fas fa-history"></i> Lịch sử học tập</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/grammar-history"><i class="fas fa-history"></i> Lịch sử bài tập Ngữ pháp</a>
                                <% if ("ADMIN".equals(loggedInUser.getRole())) { %>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-cog"></i> Trang quản trị</a>
                                <% } %>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                            </div>
                        </li>
                <% } else { %>
                        <li class="nav-item ${path.contains('/login') ? 'active' : ''}">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> <span>Đăng Nhập</span></a>
                        </li>
                        <li class="nav-item ${path.contains('/register') ? 'active' : ''}">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> <span>Đăng Ký</span></a>
                        </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>