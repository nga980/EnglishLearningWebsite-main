<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@page import="model.Lesson" %>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Bài Học - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <style>
        .admin-main-content {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .header-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .header-card h1 {
            margin: 0;
            font-weight: 300;
            font-size: 2.2rem;
        }
        
        .add-btn {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            color: white;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(255,107,107,0.3);
        }
        
        .add-btn:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255,107,107,0.4);
            text-decoration: none;
        }
        
        .table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .table-header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 20px;
            margin: 0;
        }
        
        .table-responsive {
            border-radius: 0 0 15px 15px;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table thead th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 15px;
            font-size: 0.9rem;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-top: 1px solid #e9ecef;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        
        .action-btn {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            border: none;
            margin: 2px;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: white;
        }
        
        .btn-edit:hover {
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(116,185,255,0.4);
        }
        
        .btn-quiz {
            background: linear-gradient(135deg, #00b894 0%, #00cec9 100%);
            color: white;
        }
        
        .btn-quiz:hover {
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(0,184,148,0.4);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);
            color: white;
        }
        
        .btn-delete:hover {
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(253,121,168,0.4);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-weight: 500;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #00b894 0%, #00cec9 100%);
            color: white;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #e17055 0%, #d63031 100%);
            color: white;
        }
        
        .pagination {
            margin-top: 30px;
        }
        
        .page-link {
            border: none;
            padding: 12px 18px;
            margin: 0 5px;
            border-radius: 25px;
            color: #667eea;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .page-link:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.3);
        }
        
        .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102,126,234,0.3);
        }
        
        .page-item.disabled .page-link {
            background: #e9ecef;
            color: #6c757d;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        
        .search-filter {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .search-input {
            border-radius: 25px;
            border: 1px solid #dee2e6;
            padding: 12px 20px;
            width: 100%;
            height: 45px;
            font-size: 14px;
        }
        
        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        
        .filter-row {
            align-items: center;
        }
        
        .filter-col {
            margin-bottom: 15px;
        }
        
        .reset-btn {
            height: 45px;
            border-radius: 25px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .reset-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-1px);
        }
        
        .lesson-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            flex: 1;
            margin: 0 10px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        /* Mobile responsive */
        @media (max-width: 768px) {
            .admin-main-content {
                padding: 15px;
            }
            
            .header-card {
                padding: 20px;
                text-align: center;
            }
            
            .header-card h1 {
                font-size: 1.8rem;
                margin-bottom: 20px;
            }
            
            .add-btn {
                display: block;
                width: 100%;
                text-align: center;
            }
            
            .search-filter {
                display: block !important;
                padding: 15px;
            }
            
            .filter-col {
                margin-bottom: 15px;
            }
            
            .search-input {
                height: 40px;
                font-size: 14px;
            }
            
            .lesson-stats {
                flex-direction: column;
            }
            
            .stat-card {
                margin: 5px 0;
                width: 100%;
            }
            
            .table-responsive {
                font-size: 0.9rem;
            }
            
            .table thead {
                display: none;
            }
            
            .table tbody td {
                display: block;
                text-align: left;
                border: none;
                padding: 10px 15px;
                position: relative;
                padding-left: 35%;
            }
            
            .table tbody td:before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 30%;
                font-weight: 600;
                color: #495057;
            }
            
            .table tbody tr {
                border: 1px solid #dee2e6;
                border-radius: 10px;
                margin-bottom: 15px;
                display: block;
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .action-btn {
                display: block;
                width: 100%;
                margin: 5px 0;
            }
        }
        
        @media (max-width: 576px) {
            .filter-row {
                margin: 0;
            }
            
            .filter-col {
                padding: 0 5px;
                margin-bottom: 10px;
            }
            
            .search-input {
                height: 38px;
                font-size: 13px;
                padding: 8px 15px;
            }
            
            .reset-btn {
                height: 38px;
                font-size: 13px;
            }
            
            .input-group-text {
                padding: 8px 12px;
            }
            
            .table tbody td {
                padding-left: 15px;
                padding-right: 15px;
            }
            
            .table tbody td:before {
                position: relative;
                display: block;
                width: 100%;
                margin-bottom: 5px;
                font-size: 0.8rem;
                color: #6c757d;
            }
        }
        
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
              <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <div class="header-card">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center">
                        <div>
                            <h1><i class="fas fa-chalkboard-teacher mr-3"></i>Quản Lý Bài Học</h1>
                            <p class="mb-0 opacity-75">Quản lý và tổ chức các bài học trong hệ thống</p>
                        </div>
                        <div class="mt-3 mt-md-0">
                            <a href="${pageContext.request.contextPath}/admin/addLesson.jsp" class="add-btn">
                                <i class="fas fa-plus-circle mr-2"></i>
                                Thêm Bài Học Mới
                            </a>
                        </div>
                    </div>
                </div>

                <div class="lesson-stats d-none d-md-flex">
                    <div class="stat-card">
                        <%-- Sử dụng biến 'totalLessons' đã được gửi từ Servlet --%>
                        <div class="stat-number">${totalLessons}</div>
                        <div class="stat-label">Tổng Số Bài Học</div>
                    </div>
                </div>
                <div class="search-filter">
                    <div class="row filter-row">
                        <div class="col-lg-8 col-md-8 col-sm-12 filter-col">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-light border-right-0" style="border-radius: 25px 0 0 25px; border-color: #dee2e6;">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                </div>
                                <input type="text" class="form-control search-input" 
                                       placeholder="Tìm kiếm bài học theo tiêu đề..." 
                                       id="searchInput"
                                       style="border-left: 0; border-radius: 0 25px 25px 0; padding-left: 0;">
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-12 filter-col">
                            <button class="btn reset-btn btn-block" id="resetFilter">
                                <i class="fas fa-redo mr-2"></i>Reset Tìm Kiếm
                            </button>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle mr-2"></i>
                        <c:out value="${sessionScope.successMessage}"/>
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        <c:out value="${sessionScope.errorMessage}"/>
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>

                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                    <p class="mt-2">Đang tải dữ liệu...</p>
                </div>

                <div class="table-card">
                    <div class="table-header">
                        <h5 class="mb-0"><i class="fas fa-list mr-2"></i>Danh Sách Bài Học</h5>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="d-none d-md-table-header-group">
                                <tr>
                                    <th><i class="fas fa-hashtag mr-1"></i>ID</th>
                                    <th><i class="fas fa-heading mr-1"></i>Tiêu Đề</th>
                                    <th><i class="fas fa-calendar mr-1"></i>Ngày Tạo</th>
                                    <th><i class="fas fa-cogs mr-1"></i>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody id="lessonTableBody">
                                <c:choose>
                                    <c:when test="${not empty lessonList}">
                                        <c:forEach var="lesson" items="${lessonList}">
                                            <tr class="lesson-row">
                                                <td data-label="ID:">
                                                    <span class="badge badge-secondary">#<c:out value="${lesson.lessonId}"/></span>
                                                </td>
                                                <td data-label="Tiêu đề:">
                                                    <strong><c:out value="${lesson.title}"/></strong>
                                                </td>
                                                <td data-label="Ngày tạo:">
                                                    <i class="fas fa-clock mr-1 text-muted"></i>
                                                    <fmt:formatDate value="${lesson.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td data-label="Hành động:">
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/edit-lesson-form?lessonId=${lesson.lessonId}" 
                                                           class="btn action-btn btn-edit">
                                                            <i class="fas fa-edit mr-1"></i>Sửa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${lesson.lessonId}" 
                                                           class="btn action-btn btn-quiz">
                                                            <i class="fas fa-question-circle mr-1"></i>Quiz
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/delete-lesson?lessonId=${lesson.lessonId}" 
                                                           class="btn action-btn btn-delete" 
                                                           onclick="return confirmDelete('${lesson.title}');">
                                                            <i class="fas fa-trash mr-1"></i>Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4">
                                                <div class="empty-state">
                                                    <i class="fas fa-chalkboard-teacher"></i>
                                                    <h5>Chưa có bài học nào</h5>
                                                    <p>Hãy thêm bài học đầu tiên để bắt đầu</p>
                                                    <a href="${pageContext.request.contextPath}/admin/addLesson.jsp" class="btn btn-primary">
                                                        <i class="fas fa-plus mr-2"></i>Thêm Bài Học Đầu Tiên
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left mr-1"></i>Trước
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-lessons?page=${currentPage + 1}">
                                    Sau<i class="fas fa-chevron-right ml-1"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    
    <script>
        // Initialize Feather Icons
        feather.replace();
        
        // Confirm delete function
        function confirmDelete(title) {
            return confirm(`Bạn có chắc chắn muốn xóa bài học "${title}" không?\n\nCác dữ liệu liên quan (từ vựng, câu hỏi quiz) có thể bị ảnh hưởng!\n\nHành động này không thể hoàn tác!`);
        }
        
        // Search and filter functionality
        $(document).ready(function() {
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
            
            // Search functionality
            $('#searchInput').on('keyup', function() {
                var searchTerm = $(this).val().toLowerCase();
                filterTable();
            });
            
            // Reset filter
            $('#resetFilter').on('click', function() {
                $('#searchInput').val('');
                filterTable();
            });
            
            function filterTable() {
                var searchTerm = $('#searchInput').val().toLowerCase();
                var visibleRows = 0;
                
                $('.lesson-row').each(function() {
                    var row = $(this);
                    var title = row.find('td:nth-child(2)').text().toLowerCase();
                    
                    var matchesSearch = title.includes(searchTerm);
                    
                    if (matchesSearch) {
                        row.show();
                        visibleRows++;
                    } else {
                        row.hide();
                    }
                });
                
                // Show/hide empty state
                if (visibleRows === 0 && $('.lesson-row').length > 0) {
                    if ($('.no-results').length === 0) {
                        $('#lessonTableBody').append(`
                            <tr class="no-results">
                                <td colspan="4">
                                    <div class="empty-state">
                                        <i class="fas fa-search"></i>
                                        <h5>Không tìm thấy kết quả</h5>
                                        <p>Hãy thử thay đổi từ khóa tìm kiếm</p>
                                    </div>
                                </td>
                            </tr>
                        `);
                    }
                } else {
                    $('.no-results').remove();
                }
            }
            
            // Add loading effect to buttons
            $('.action-btn').on('click', function() {
                var btn = $(this);
                var originalText = btn.html();
                
                if (!$(this).hasClass('btn-delete')) {
                    btn.html('<i class="fas fa-spinner fa-spin"></i>');
                    
                    setTimeout(function() {
                        btn.html(originalText);
                    }, 1000);
                }
            });
            
            // Add hover effects
            $('.table tbody tr').hover(
                function() {
                    $(this).addClass('table-hover-effect');
                },
                function() {
                    $(this).removeClass('table-hover-effect');
                }
            );
            
            // Smooth scroll to top on pagination click
            $('.pagination a').on('click', function() {
                $('html, body').animate({
                    scrollTop: 0
                }, 300);
            });
        });
        
        // Add some interactive animations
        $(document).ready(function() {
            // Animate cards on load
            $('.table-card, .header-card, .search-filter, .stat-card').hide().fadeIn(800);
            
            // Stagger animation for table rows
            $('.lesson-row').each(function(index) {
                $(this).delay(index * 100).fadeIn(500);
            });
            
            // Add click animation to buttons
            $('.btn').on('click', function() {
                $(this).addClass('btn-clicked');
                setTimeout(() => {
                    $(this).removeClass('btn-clicked');
                }, 150);
            });
        });
    </script>
    
    <style>
        .btn-clicked {
            transform: scale(0.95);
        }
        
        .table-hover-effect {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</body>
</html>