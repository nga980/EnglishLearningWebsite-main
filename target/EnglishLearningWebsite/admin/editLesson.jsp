<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@page import="model.Lesson" %> <%-- Giữ nguyên package của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sửa Bài Học - Admin Dashboard</title>
    
    <!-- Bootstrap 4.5.2 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Custom admin styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <!-- TinyMCE -->
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        .admin-main-content {
            padding: 1.5rem;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .content-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            border: none;
            overflow: hidden;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border: none;
        }
        
        .form-group label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-custom {
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            border: none;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-secondary-custom {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary-custom:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
            color: white;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 1rem 1.5rem;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #51cf66 0%, #40c057 100%);
            color: white;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .breadcrumb-custom {
            background: transparent;
            padding: 0;
            margin: 0;
        }
        
        .breadcrumb-custom .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
        }
        
        .breadcrumb-custom .breadcrumb-item.active {
            color: #6c757d;
        }
        
        .form-section {
            padding: 2rem;
        }
        
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .spinner-custom {
            width: 3rem;
            height: 3rem;
            border: 0.3rem solid #f3f3f3;
            border-top: 0.3rem solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .input-group-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: 2px solid #667eea;
            border-right: none;
        }
        
        .input-group .form-control {
            border-left: none;
        }
        
        .input-group .form-control:focus {
            border-left: none;
        }
        
        @media (max-width: 768px) {
            .admin-main-content {
                padding: 1rem;
            }
            
            .btn-custom {
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            .form-section {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner-custom"></div>
    </div>

    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="d-flex justify-content-between align-items-center flex-wrap">
                        <div>
                            <h1 class="h3 mb-2 font-weight-bold">
                                <i class="fas fa-edit text-primary mr-2"></i>
                                Chỉnh Sửa Bài Học
                            </h1>
                        </div>
                        <div class="d-none d-md-block">
                            <span class="badge badge-primary px-3 py-2">
                                <i class="fas fa-calendar-alt mr-2"></i>
                                <span id="currentDate"></span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty requestScope.errorMessage_editLesson}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <strong>Lỗi!</strong> <c:out value="${requestScope.errorMessage_editLesson}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>

                <!-- Main Content Card -->
                <c:if test="${not empty requestScope.lessonToEdit}">
                    <div class="card content-card">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">
                                <i class="fas fa-book-open mr-2"></i>
                                Thông tin bài học
                            </h5>
                        </div>
                        <div class="form-section">
                            <form method="POST" action="${pageContext.request.contextPath}/admin/update-lesson-action" id="lessonForm">
                                <!-- Hidden lesson ID -->
                                <input type="hidden" name="lessonId" value="<c:out value='${lessonToEdit.lessonId}'/>">

                                <!-- Lesson Title -->
                                <div class="form-group">
                                    <label for="lessonTitle">
                                        <i class="fas fa-heading text-primary mr-2"></i>
                                        Tiêu đề bài học <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="fas fa-heading"></i>
                                            </span>
                                        </div>
                                        <input type="text" 
                                               class="form-control" 
                                               id="lessonTitle" 
                                               name="lessonTitle" 
                                               required
                                               placeholder="Nhập tiêu đề bài học..."
                                               value="<c:out value='${lessonToEdit.title}'/>"
                                               maxlength="200">
                                    </div>
                                    <small class="form-text text-muted">
                                        <span id="titleCount">0</span>/200 ký tự
                                    </small>
                                </div>

                                <!-- Lesson Content -->
                                <div class="form-group">
                                    <label for="lessonContent">
                                        <i class="fas fa-file-alt text-primary mr-2"></i>
                                        Nội dung bài học <span class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" 
                                              id="lessonContent" 
                                              name="lessonContent" 
                                              rows="15" 
                                              required
                                              placeholder="Nhập nội dung bài học..."><c:out value='${lessonToEdit.content}'/></textarea>
                                    <small class="form-text text-muted">
                                        Sử dụng trình soạn thảo để định dạng nội dung bài học
                                    </small>
                                </div>

                                <!-- Action Buttons -->
                                <div class="row mt-4">
                                    <div class="col-md-6">
                                        <button type="submit" class="btn btn-custom btn-primary-custom btn-block">
                                            <i class="fas fa-save mr-2"></i>
                                            Cập Nhật Bài Học
                                        </button>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="${pageContext.request.contextPath}/admin/manage-lessons" 
                                           class="btn btn-custom btn-secondary-custom btn-block">
                                            <i class="fas fa-times mr-2"></i>
                                            Hủy Bỏ
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

                <!-- No Lesson Found -->
                <c:if test="${empty requestScope.lessonToEdit}">
                    <div class="card content-card">
                        <div class="card-body text-center py-5">
                            <i class="fas fa-exclamation-circle text-warning" style="font-size: 4rem;"></i>
                            <h4 class="mt-3 mb-3">Không tìm thấy bài học</h4>
                            <p class="text-muted mb-4">
                                Không thể tìm thấy thông tin bài học cần chỉnh sửa. 
                                Vui lòng kiểm tra lại hoặc quay về danh sách bài học.
                            </p>
                            <a href="${pageContext.request.contextPath}/admin/manage-lessons" 
                               class="btn btn-custom btn-primary-custom">
                                <i class="fas fa-arrow-left mr-2"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <!-- jQuery 3.7.1 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <!-- Bootstrap 4.5.2 JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Feather Icons -->
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>

    <script>
        // Initialize Feather Icons
        feather.replace();

        // Set current date
        $(document).ready(function() {
            const today = new Date();
            const formattedDate = today.toLocaleDateString('vi-VN', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            $('#currentDate').text(formattedDate);

            // Character count for title
            const titleInput = $('#lessonTitle');
            const titleCount = $('#titleCount');
            
            function updateTitleCount() {
                const count = titleInput.val().length;
                titleCount.text(count);
                
                if (count > 180) {
                    titleCount.addClass('text-warning');
                } else if (count > 160) {
                    titleCount.addClass('text-info').removeClass('text-warning');
                } else {
                    titleCount.removeClass('text-warning text-info');
                }
            }
            
            titleInput.on('input', updateTitleCount);
            updateTitleCount(); // Initial count

            // Form submission with loading
            $('#lessonForm').on('submit', function() {
                $('#loadingOverlay').css('display', 'flex');
                
                // Disable submit button to prevent double submission
                $(this).find('button[type="submit"]').prop('disabled', true).html(
                    '<i class="fas fa-spinner fa-spin mr-2"></i>Đang cập nhật...'
                );
            });

            // Auto-hide alerts after 5 seconds
            $('.alert').each(function() {
                const alert = $(this);
                setTimeout(function() {
                    alert.fadeOut('slow');
                }, 5000);
            });

            // Smooth scroll to top on page load
            $('html, body').animate({ scrollTop: 0 }, 'slow');
        });

        // Initialize TinyMCE
        tinymce.init({
            selector: 'textarea#lessonContent',
            height: 400,
            menubar: false,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount', 'paste'
            ],
            toolbar: 'undo redo | blocks | ' +
                'bold italic forecolor backcolor | alignleft aligncenter ' +
                'alignright alignjustify | bullist numlist outdent indent | ' +
                'removeformat | link image media | fullscreen code | help',
            content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 14px; line-height: 1.6; }',
            branding: false,
            resize: true,
            paste_data_images: true,
            image_advtab: true,
            link_default_target: '_blank',
            setup: function (editor) {
                editor.on('change', function () {
                    editor.save();
                });
            }
        });

        // Confirm before leaving page with unsaved changes
        let formChanged = false;
        $('#lessonForm input, #lessonForm textarea').on('change input', function() {
            formChanged = true;
        });

        $('#lessonForm').on('submit', function() {
            formChanged = false;
        });

        $(window).on('beforeunload', function() {
            if (formChanged) {
                return 'Bạn có thay đổi chưa được lưu. Bạn có chắc chắn muốn rời khỏi trang này?';
            }
        });
    </script>
</body>
</html>