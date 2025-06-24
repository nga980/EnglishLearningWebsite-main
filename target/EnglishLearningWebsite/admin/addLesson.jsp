<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Bài Học Mới - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --sidebar-bg: #2c3e50;
            --sidebar-hover: #34495e;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
        }
       

        /* Main Content */
        .admin-main-content {
            margin-left: 16.66667%;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .content-header {
            background: linear-gradient(135deg, #fff, #f8f9fa);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border-left: 5px solid var(--primary-color);
        }

        .content-header h1 {
            color: var(--dark-color);
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
        }

        .content-header h1 i {
            margin-right: 15px;
            color: var(--primary-color);
        }

        /* Form Styles */
        .form-container {
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .form-group label i {
            margin-right: 8px;
            color: var(--primary-color);
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
            transform: translateY(-2px);
        }

        .form-control-lg {
            font-size: 18px;
            padding: 20px;
        }

        /* Button Styles */
        .btn-custom {
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s ease;
            margin-right: 10px;
            margin-bottom: 10px;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-custom i {
            margin-right: 8px;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), #0056b3);
            border: none;
            color: white;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #0056b3, var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,123,255,0.4);
        }

        .btn-secondary-custom {
            background: linear-gradient(135deg, var(--secondary-color), #5a6268);
            border: none;
            color: white;
        }

        .btn-secondary-custom:hover {
            background: linear-gradient(135deg, #5a6268, var(--secondary-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108,117,125,0.4);
        }

        /* Alert Styles */
        .alert-custom {
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border: none;
            font-weight: 500;
        }

        .alert-danger-custom {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 5px solid var(--danger-color);
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .admin-sidebar {
                position: fixed;
                top: 0;
                left: -100%;
                width: 280px;
                transition: left 0.3s ease;
            }
            
            .admin-sidebar.show {
                left: 0;
            }
            
            .admin-main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .content-header {
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .form-container {
                padding: 25px;
            }
            
            .mobile-toggle {
                display: block !important;
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: var(--primary-color);
                color: white;
                border: none;
                padding: 10px;
                border-radius: 5px;
            }
        }

        @media (min-width: 769px) {
            .mobile-toggle {
                display: none !important;
            }
        }

        /* Loading Animation */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.9);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>

    <!-- Mobile Toggle Button -->
    <button class="btn mobile-toggle d-md-none" id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>

    <div class="container-fluid">
        <div class="row">
            <!-- Main Content -->
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <!-- Content Header -->
                <div class="content-header">
                    <h1>
                        <i class="fas fa-plus-circle"></i>
                        Thêm Bài Học Mới
                    </h1>
                    <p class="mb-0 text-muted">Tạo bài học mới cho hệ thống học tập</p>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty requestScope.errorMessage_addLesson}">
                    <div class="alert alert-danger alert-custom alert-danger-custom" role="alert">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Lỗi!</strong> <c:out value="${requestScope.errorMessage_addLesson}"/>
                    </div>
                </c:if>

                <!-- Form Container -->
                <div class="form-container">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/add-lesson-action" id="lessonForm">
                        <div class="form-group">
                            <label for="lessonTitle">
                                <i class="fas fa-heading"></i>
                                <strong>Tiêu đề bài học:</strong>
                            </label>
                            <input type="text" 
                                   class="form-control form-control-lg" 
                                   id="lessonTitle" 
                                   name="lessonTitle" 
                                   required 
                                   placeholder="Nhập tiêu đề bài học..."
                                   value="<c:out value='${param.lessonTitle}'/>">
                            <div class="invalid-feedback">
                                Vui lòng nhập tiêu đề bài học.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="lessonContent">
                                <i class="fas fa-file-alt"></i>
                                <strong>Nội dung bài học:</strong>
                            </label>
                            <textarea class="form-control form-control-lg" 
                                      id="lessonContent" 
                                      name="lessonContent" 
                                      rows="15"
                                      placeholder="Nhập nội dung bài học..."><c:out value='${param.lessonContent}'/></textarea>
                            <div class="invalid-feedback">
                                Vui lòng nhập nội dung bài học.
                            </div>
                        </div>

                        <div class="form-group text-center">
                            <button type="submit" class="btn btn-custom btn-primary-custom">
                                <i class="fas fa-save"></i> Thêm Bài Học
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/manage-lessons" 
                               class="btn btn-custom btn-secondary-custom">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        $(document).ready(function() {
            // Mobile sidebar toggle
            $('#sidebarToggle').click(function() {
                $('#sidebar').toggleClass('show d-block');
            });

            // Close sidebar when clicking outside on mobile
            $(document).click(function(event) {
                if (!$(event.target).closest('#sidebar, #sidebarToggle').length) {
                    $('#sidebar').removeClass('show d-block');
                }
            });

            // Form validation
            $('#lessonForm').on('submit', function(e) {
                var isValid = true;
                
                // Validate title
                var title = $('#lessonTitle').val().trim();
                if (title === '') {
                    $('#lessonTitle').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#lessonTitle').removeClass('is-invalid').addClass('is-valid');
                }

                // Validate content (TinyMCE)
                var content = tinymce.get('lessonContent').getContent().trim();
                if (content === '' || content === '<p><br data-mce-bogus="1"></p>') {
                    $('#lessonContent').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#lessonContent').removeClass('is-invalid').addClass('is-valid');
                }

                if (!isValid) {
                    e.preventDefault();
                    $('html, body').animate({
                        scrollTop: $('.is-invalid').first().offset().top - 100
                    }, 500);
                } else {
                    // Show loading overlay
                    $('#loadingOverlay').show();
                }
            });

            // Real-time validation
            $('#lessonTitle').on('input', function() {
                var value = $(this).val().trim();
                if (value !== '') {
                    $(this).removeClass('is-invalid').addClass('is-valid');
                } else {
                    $(this).removeClass('is-valid').addClass('is-invalid');
                }
            });

            // Smooth scrolling for navigation
            $('.admin-nav-link').click(function(e) {
                if ($(window).width() < 768) {
                    $('#sidebar').removeClass('show d-block');
                }
            });

            // Add loading state to form submission
            $('#lessonForm').on('submit', function() {
                $(this).find('button[type="submit"]').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');
            });
        });

        // Cấu hình TinyMCE
        tinymce.init({
            selector: 'textarea#lessonContent', // Áp dụng cho textarea có id="lessonContent"
            height: 500,
            plugins: 'advlist lists link image media table code help wordcount',
            toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image media | code | help',
            
            // Cấu hình upload file
            images_upload_url: '${pageContext.request.contextPath}/admin/upload-media',
            automatic_uploads: true,
            file_picker_types: 'image media',
            file_picker_callback: function (cb, value, meta) {
                var input = document.createElement('input');
                input.setAttribute('type', 'file');
                input.setAttribute('accept', meta.filetype === 'image' ? 'image/*' : 'video/*,audio/*');

                input.onchange = function () {
                    var file = this.files[0];
                    var reader = new FileReader();
                    reader.onload = function () {
                        var id = 'blobid' + (new Date()).getTime();
                        var blobCache = tinymce.activeEditor.editorUpload.blobCache;
                        var base64 = reader.result.split(',')[1];
                        var blobInfo = blobCache.create(id, file, base64);
                        blobCache.add(blobInfo);
                        cb(blobInfo.blobUri(), { title: file.name });
                    };
                    reader.readAsDataURL(file);
                };
                input.click();
            }
        });

        // Hide loading overlay when page is fully loaded
        $(window).on('load', function() {
            $('#loadingOverlay').fadeOut();
        });
    </script>
</body>
</html>