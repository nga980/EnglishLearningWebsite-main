<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Người Dùng - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <style>
        .admin-main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container-fluid {
            padding: 0;
        }
        
        .content-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .page-header h1 {
            margin: 0;
            font-weight: 600;
            font-size: 1.8rem;
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.08);
        }
        
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px 10px;
        }
        
        .table tbody tr {
            transition: all 0.3s ease;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
        }
        
        .table td {
            padding: 15px 10px;
            vertical-align: middle;
            border-color: #e9ecef;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
        }
        
        .username-cell {
            font-weight: 600;
            color: #495057;
        }
        
        .email-cell {
            color: #6c757d;
        }
        
        .fullname-cell {
            color: #495057;
        }
        
        .role-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .role-admin {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .role-user {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .role-current-user {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
        }
        
        .role-select-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .role-select {
            min-width: 100px;
            border-radius: 20px;
            border: 2px solid #e9ecef;
            padding: 5px 10px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .btn-save-role {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.8rem;
            font-weight: 500;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-save-role:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(0, 123, 255, 0.4);
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.8rem;
            font-weight: 500;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.4);
            color: white;
        }
        
        .pagination .page-link {
            border-radius: 20px;
            margin: 0 3px;
            border: none;
            color: #667eea;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            transform: scale(1.1);
        }
        
        .pagination .page-link:hover {
            background-color: #f8f9fa;
            color: #667eea;
            transform: translateY(-2px);
        }
        
        .alert {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                text-align: center;
                padding: 20px 15px;
            }
            
            .table-responsive {
                border-radius: 15px;
            }
            
            .table td, .table th {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
            
            .role-select-form {
                flex-direction: column;
                gap: 5px;
            }
            
            .role-select {
                min-width: 80px;
            }
            
            .btn-save-role, .btn-delete {
                padding: 4px 10px;
                font-size: 0.7rem;
            }
            
            .content-card {
                padding: 15px;
            }
            
            .user-avatar {
                width: 30px;
                height: 30px;
                font-size: 1rem;
            }
        }
        
        @media (max-width: 576px) {
            .admin-main-content {
                padding: 10px;
            }
            
            .page-header h1 {
                font-size: 1.4rem;
            }
            
            .pagination {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .pagination .page-item {
                margin: 2px;
            }
            
            .table td:nth-child(3),
            .table th:nth-child(3) {
                display: none;
            }
        }
        
        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Smooth transitions */
        * {
            transition: all 0.3s ease;
        }
        
        /* Action column styling */
        .action-buttons {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                gap: 3px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-users"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center">
                        <h1 class="mb-3 mb-md-0">
                            <i class="fas fa-users mr-2"></i>
                            Quản Lý Người Dùng
                        </h1>
                        <div class="d-flex align-items-center">
                            <div class="stats-card mr-3 d-none d-md-block">
                                <div class="stats-number">${userList.size()}</div>
                                <div class="stats-label">Người dùng</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Footer -->
                <c:if test="${not empty userList}">
                    <div class="content-card mt-4">
                        <div class="row text-center">
                            <div class="col-md-3">
                                <h4 class="text-info">
                                    <c:set var="adminCount" value="0"/>
                                    <c:forEach var="user" items="${userList}">
                                        <c:if test="${user.role == 'ADMIN'}">
                                            <c:set var="adminCount" value="${adminCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${adminCount}
                                </h4>
                                <small class="text-muted">Quản trị viên</small>
                            </div>
                            <div class="col-md-3">
                                <h4 class="text-success">
                                    <c:set var="userCount" value="0"/>
                                    <c:forEach var="user" items="${userList}">
                                        <c:if test="${user.role == 'USER'}">
                                            <c:set var="userCount" value="${userCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${userCount}
                                </h4>
                                <small class="text-muted">Người dùng thường</small>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.successMessage_user}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle mr-2"></i>
                        <c:out value="${sessionScope.successMessage_user}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage_user"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage_user}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <c:out value="${sessionScope.errorMessage_user}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage_user"); %>
                </c:if>

                <!-- Table Container -->
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 60px;">
                                        <i class="fas fa-hashtag"></i>
                                    </th>
                                    <th>
                                        <i class="fas fa-user mr-2"></i>
                                        Thông Tin
                                    </th>
                                    <th class="d-none d-sm-table-cell">
                                        <i class="fas fa-envelope mr-2"></i>
                                        Email
                                    </th>
                                    <th class="d-none d-md-table-cell">
                                        <i class="fas fa-id-card mr-2"></i>
                                        Họ và Tên
                                    </th>
                                    <th class="text-center">
                                        <i class="fas fa-user-tag mr-2"></i>
                                        Vai Trò
                                    </th>
                                    <th class="text-center">
                                        <i class="fas fa-cogs mr-2"></i>
                                        Hành Động
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty userList}">
                                        <c:forEach var="user" items="${userList}">
                                            <tr>
                                                <td class="text-center">
                                                    <div class="user-avatar">
                                                        ${user.username.substring(0,1).toUpperCase()}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="username-cell">
                                                        <strong><c:out value="${user.username}"/></strong>
                                                        <c:if test="${sessionScope.loggedInUser.userId == user.userId}">
                                                            <span class="badge badge-info ml-1">Bạn</span>
                                                        </c:if>
                                                        <!-- Show email on mobile -->
                                                        <div class="d-sm-none text-muted small mt-1">
                                                            <i class="fas fa-envelope mr-1"></i>
                                                            <c:out value="${user.email}"/>
                                                        </div>
                                                        <!-- Show full name on small screens -->
                                                        <div class="d-md-none text-muted small mt-1">
                                                            <i class="fas fa-id-card mr-1"></i>
                                                            <c:out value="${user.fullName}"/>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="email-cell d-none d-sm-table-cell">
                                                    <c:out value="${user.email}"/>
                                                </td>
                                                <td class="fullname-cell d-none d-md-table-cell">
                                                    <c:out value="${user.fullName}"/>
                                                </td>
                                                <!-- Role Column -->
                                                <td class="text-center">
                                                    <c:if test="${sessionScope.loggedInUser.userId != user.userId}">
                                                        <form action="${pageContext.request.contextPath}/admin/update-user-role" method="POST" class="role-select-form">
                                                            <input type="hidden" name="userId" value="${user.userId}">
                                                            <select name="newRole" class="role-select">
                                                                <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>User</option>
                                                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                                            </select>
                                                            <button type="submit" class="btn btn-save-role">
                                                                <i class="fas fa-save mr-1"></i>
                                                                <span class="d-none d-lg-inline">Lưu</span>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${sessionScope.loggedInUser.userId == user.userId}">
                                                        <span class="role-badge role-current-user">
                                                            <i class="fas fa-crown mr-1"></i>
                                                            <c:out value="${user.role}"/>
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <!-- Action Column -->
                                                <td class="text-center">
                                                    <div class="action-buttons">
                                                        <c:if test="${sessionScope.loggedInUser.userId != user.userId}">
                                                            <a href="${pageContext.request.contextPath}/admin/delete-user?userId=${user.userId}" class="btn btn-delete">
                                                                <i class="fas fa-trash-alt mr-1"></i>
                                                                <span class="d-none d-lg-inline">Xóa</span>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${sessionScope.loggedInUser.userId == user.userId}">
                                                            <span class="text-muted small">
                                                                <i class="fas fa-shield-alt mr-1"></i>
                                                                Tài khoản hiện tại
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="empty-state">
                                                <i class="fas fa-users"></i>
                                                <h5>Không có người dùng nào</h5>
                                                <p class="text-muted">Hệ thống chưa có người dùng nào được đăng ký.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex justify-content-center mt-4">
                        <nav aria-label="User pagination">
                            <ul class="pagination">
                                <!-- Previous Button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                        <span class="d-none d-sm-inline ml-1">Trước</span>
                                    </a>
                                </li>

                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${i}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <!-- Next Button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage + 1}">
                                        <span class="d-none d-sm-inline mr-1">Sau</span>
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>

            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Add loading animation to save buttons
        $('.btn-save-role').on('click', function() {
            var $this = $(this);
            var originalText = $this.html();
            $this.html('<span class="loading"></span>').prop('disabled', true);
            
            // Re-enable after form submission
            setTimeout(function() {
                $this.html(originalText).prop('disabled', false);
            }, 2000);
        });

        // Enhanced delete confirmation
        $('.btn-delete').on('click', function(e) {
            e.preventDefault();
            var href = $(this).attr('href');
            var username = $(this).closest('tr').find('.username-cell strong').text();
            
            if (confirm('⚠️ XÁC NHẬN XÓA NGƯỜI DÙNG\n\n' +
                       'Bạn có chắc chắn muốn xóa người dùng "' + username + '" không?\n\n' +
                       '❌ Hành động này sẽ:\n' +
                       '• Xóa vĩnh viễn tài khoản người dùng\n' +
                       '• Xóa tất cả dữ liệu liên quan\n' +
                       '• KHÔNG THỂ hoàn tác\n\n' +
                       'Nhấn OK để tiếp tục hoặc Cancel để hủy.')) {
                
                // Add loading state
                $(this).html('<span class="loading"></span> Đang xóa...').prop('disabled', true);
                window.location.href = href;
            }
        });

        // Role change confirmation
        $('.role-select').on('change', function() {
            var $form = $(this).closest('form');
            var $saveBtn = $form.find('.btn-save-role');
            var username = $(this).closest('tr').find('.username-cell strong').text();
            var newRole = $(this).val();
            
            $saveBtn.addClass('btn-warning').html('<i class="fas fa-exclamation-triangle mr-1"></i><span class="d-none d-lg-inline">Lưu</span>');
        });

        // Smooth scroll to top
        function scrollToTop() {
            $('html, body').animate({scrollTop: 0}, 600);
        }

        // Add scroll to top button if content is long
        if ($(document).height() > $(window).height() * 2) {
            $('body').append('<button onclick="scrollToTop()" class="btn btn-primary" style="position: fixed; bottom: 20px; right: 20px; z-index: 1000; border-radius: 50%; width: 50px; height: 50px;"><i class="fas fa-arrow-up"></i></button>');
        }

        // Initialize tooltips if using Bootstrap tooltips
        $('[data-toggle="tooltip"]').tooltip();
    </script>
</body>
</html>