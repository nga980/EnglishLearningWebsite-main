<%-- File: /admin/_adminLayout.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Navbar cố định ở trên cùng cho Admin Panel --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNavbar">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp" target="_blank">Xem Website</a>
            </li>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <li class="nav-item">
                    <span class="navbar-text mr-3">Xin chào,
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.fullName}">${sessionScope.loggedInUser.fullName}</c:when>
                            <c:otherwise>${sessionScope.loggedInUser.username}</c:otherwise>
                        </c:choose>!
                    </span>
                </li>
                <li class="nav-item">
                    <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                </li>
            </c:if>
        </ul>
    </div>
</nav>

<%-- Sidebar điều hướng cho Admin --%>
<nav class="col-md-2 d-none d-md-block admin-sidebar">
    <div class="sidebar-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                    <span data-feather="home"></span> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-lessons">
                    <span data-feather="file-text"></span> Quản Lý Bài Học
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-vocabulary' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-vocabulary">
                    <span data-feather="book-open"></span> Quản Lý Từ Vựng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-grammar' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-grammar">
                    <span data-feather="award"></span> Quản Lý Ngữ Pháp
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link admin-nav-link ${param.activePage == 'manage-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manage-users">
                    <span data-feather="users"></span> Quản Lý Người Dùng
                </a>
            </li>
        </ul>
    </div>
</nav>