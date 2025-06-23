<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Vocabulary" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Từ Vựng - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <style>
        .admin-main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
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
        
        .btn-add-new {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-add-new:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
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
        
        .btn-action {
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 2px;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
        }
        
        .btn-edit:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(23, 162, 184, 0.4);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
        }
        
        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.4);
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
        
        .word-cell {
            font-weight: 600;
            color: #495057;
        }
        
        .meaning-cell {
            color: #6c757d;
            font-style: italic;
        }
        
        .example-cell {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .lesson-badge {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #212529;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
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
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                text-align: center;
                padding: 20px 15px;
            }
            
            .page-header .btn-toolbar {
                margin-top: 15px;
            }
            
            .table-responsive {
                border-radius: 15px;
            }
            
            .table td, .table th {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
            
            .btn-action {
                padding: 4px 8px;
                font-size: 0.7rem;
                margin: 1px;
            }
            
            .content-card {
                padding: 15px;
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
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-vocabulary"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center">
                        <h1 class="mb-3 mb-md-0">
                            <i class="fas fa-book-open mr-2"></i>
                            Quản Lý Từ Vựng
                        </h1>
                        <div class="btn-toolbar">
                            <a href="${pageContext.request.contextPath}/admin/addVocabulary.jsp" class="btn btn-add-new text-white">
                                <i class="fas fa-plus-circle mr-2"></i>
                                Thêm Từ Vựng Mới
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.successMessage_vocab}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle mr-2"></i>
                        <c:out value="${sessionScope.successMessage_vocab}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage_vocab"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage_vocab}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <c:out value="${sessionScope.errorMessage_vocab}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage_vocab"); %>
                </c:if>

                <c:if test="${not empty vocabularyList}">
                    <div class="content-card mt-4">
                        <div class="row text-center">
                            <div class="col-md-4">
                                <h4 class="text-primary">${totalVocabulary}</h4>
                                <small class="text-muted">Tổng Số Từ Vựng</small>
                            </div>
                            <div class="col-md-4">
                                <h4 class="text-info">${currentPage} / ${totalPages > 0 ? totalPages : 1}</h4>
                                <small class="text-muted">Trang Hiện Tại</small>
                            </div>
                            <div class="col-md-4">
                                <h4 class="text-success">${vocabularyList.size()}</h4>
                                <small class="text-muted">Từ Vựng Đang Hiển Thị</small>
                            </div>
                        </div>
                    </div>
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
                                        <i class="fas fa-spell-check mr-2"></i>
                                        Từ Vựng
                                    </th>
                                    <th class="d-none d-md-table-cell">
                                        <i class="fas fa-language mr-2"></i>
                                        Nghĩa
                                    </th>
                                    <th class="d-none d-lg-table-cell">
                                        <i class="fas fa-quote-left mr-2"></i>
                                        Ví Dụ
                                    </th>
                                    <th class="d-none d-md-table-cell text-center">
                                        <i class="fas fa-layer-group mr-2"></i>
                                        Bài Học
                                    </th>
                                    <th class="d-none d-lg-table-cell text-center">
                                        <i class="fas fa-calendar-alt mr-2"></i>
                                        Ngày Tạo
                                    </th>
                                    <th class="text-center">
                                        <i class="fas fa-cogs mr-2"></i>
                                        Hành Động
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty vocabularyList}">
                                        <c:forEach var="vocab" items="${vocabularyList}">
                                            <tr>
                                                <td class="text-center">
                                                    <span class="badge badge-secondary">
                                                        <c:out value="${vocab.vocabId}"/>
                                                    </span>
                                                </td>
                                                <td class="word-cell">
                                                    <div>
                                                        <strong><c:out value="${vocab.word}"/></strong>
                                                        <!-- Show meaning on mobile -->
                                                        <div class="d-md-none text-muted small mt-1">
                                                            <c:out value="${vocab.meaning}"/>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="meaning-cell d-none d-md-table-cell">
                                                    <c:out value="${vocab.meaning}"/>
                                                </td>
                                                <td class="example-cell d-none d-lg-table-cell">
                                                    <div style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${vocab.example}">
                                                        <c:out value="${vocab.example}"/>
                                                    </div>
                                                </td>
                                                <td class="text-center d-none d-md-table-cell">
                                                    <c:choose>
                                                        <c:when test="${not empty vocab.lessonId}">
                                                            <span class="lesson-badge">
                                                                <c:out value="${vocab.lessonId}"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center d-none d-lg-table-cell">
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${vocab.createdAt}" pattern="dd/MM/yyyy"/>
                                                        <br>
                                                        <fmt:formatDate value="${vocab.createdAt}" pattern="HH:mm"/>
                                                    </small>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group-vertical btn-group-sm d-lg-none">
                                                        <a href="${pageContext.request.contextPath}/admin/edit-vocabulary-form?vocabId=${vocab.vocabId}" 
                                                           class="btn btn-edit btn-action">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/delete-vocabulary?vocabId=${vocab.vocabId}" 
                                                           class="btn btn-delete btn-action" 
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa từ vựng này không?');">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </a>
                                                    </div>
                                                    <div class="d-none d-lg-block">
                                                        <a href="${pageContext.request.contextPath}/admin/edit-vocabulary-form?vocabId=${vocab.vocabId}" 
                                                           class="btn btn-edit btn-action">
                                                            <i class="fas fa-edit mr-1"></i>Sửa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/delete-vocabulary?vocabId=${vocab.vocabId}" 
                                                           class="btn btn-delete btn-action" 
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa từ vựng này không?');">
                                                            <i class="fas fa-trash-alt mr-1"></i>Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="empty-state">
                                                <i class="fas fa-book-open"></i>
                                                <h5>Không có từ vựng nào</h5>
                                                <p class="text-muted">Hãy thêm từ vựng đầu tiên để bắt đầu!</p>
                                                <a href="${pageContext.request.contextPath}/admin/addVocabulary.jsp" 
                                                   class="btn btn-add-new text-white">
                                                    <i class="fas fa-plus-circle mr-2"></i>
                                                    Thêm Từ Vựng Ngay
                                                </a>
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
                        <nav aria-label="Vocabulary pagination">
                            <ul class="pagination">
                                <!-- Previous Button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                        <span class="d-none d-sm-inline ml-1">Trước</span>
                                    </a>
                                </li>

                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${i}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <!-- Next Button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-vocabulary?page=${currentPage + 1}">
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

        // Add loading animation to buttons on click
        $('.btn').on('click', function() {
            if (!$(this).hasClass('btn-delete')) {
                $(this).html('<span class="loading"></span> Đang xử lý...');
            }
        });

        // Smooth scroll to top
        function scrollToTop() {
            $('html, body').animate({scrollTop: 0}, 600);
        }

        // Add scroll to top button if content is long
        if ($(document).height() > $(window).height() * 2) {
            $('body').append('<button onclick="scrollToTop()" class="btn btn-primary" style="position: fixed; bottom: 20px; right: 20px; z-index: 1000; border-radius: 50%; width: 50px; height: 50px;"><i class="fas fa-arrow-up"></i></button>');
        }
    </script>
</body>
</html>