<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %> <%-- Giữ nguyên package của bạn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm Từ Vựng Mới - Admin Dashboard</title>
    
    <!-- Bootstrap 4.5.2 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --secondary-color: #6b7280;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --border-radius: 0.75rem;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--light-bg);
            color: #1f2937;
            line-height: 1.6;
        }

        .admin-main-content {
            padding: 2rem;
            min-height: 100vh;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .page-header h1 {
            font-weight: 600;
            margin: 0;
            font-size: 2rem;
        }

        .page-header .breadcrumb {
            background: transparent;
            margin: 0;
            padding: 0;
            margin-top: 0.5rem;
        }

        .page-header .breadcrumb-item,
        .page-header .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.8);
        }

        .page-header .breadcrumb-item.active {
            color: white;
        }

        .form-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .form-group label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }

        .form-control {
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 0.875rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            background-color: #fafafa;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background-color: white;
        }

        .form-control-lg {
            padding: 1rem 1.25rem;
            font-size: 1rem;
        }

        .btn {
            border-radius: 0.5rem;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            border-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .btn-secondary {
            background: var(--secondary-color);
            border-color: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
            border-color: #4b5563;
            transform: translateY(-1px);
        }

        .btn-lg {
            padding: 1rem 2rem;
            font-size: 1rem;
        }

        .alert {
            border: none;
            border-radius: 0.5rem;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: #991b1b;
            border-left: 4px solid var(--danger-color);
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #166534;
            border-left: 4px solid var(--success-color);
        }

        .form-text {
            color: var(--secondary-color);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        .input-group-addon {
            background: white;
            border: 2px solid #e5e7eb;
            border-right: none;
            padding: 0.875rem 1rem;
            border-radius: 0.5rem 0 0 0.5rem;
            color: var(--secondary-color);
        }

        .form-row .form-group {
            margin-bottom: 1.5rem;
        }

        .action-buttons {
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
            margin-top: 1.5rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        /* Responsive improvements */
        @media (max-width: 768px) {
            .admin-main-content {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
                text-align: center;
            }
            
            .page-header h1 {
                font-size: 1.5rem;
            }
            
            .form-card {
                padding: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 576px) {
            .form-card {
                padding: 1rem;
            }
            
            .btn-lg {
                padding: 0.875rem 1.5rem;
                font-size: 0.95rem;
            }
        }

        /* Loading animation */
        .btn.loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .btn.loading::after {
            content: '';
            width: 16px;
            height: 16px;
            margin-left: 8px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        /* Focus indicators for accessibility */
        .form-control:focus,
        .btn:focus {
            outline: 2px solid var(--primary-color);
            outline-offset: 2px;
        }

        /* Enhanced textarea */
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        /* Icon enhancements */
        .input-icon {
            position: relative;
        }

        .input-icon .form-control {
            padding-left: 2.75rem;
        }

        .input-icon .icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
            z-index: 5;
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
                <!-- Enhanced Page Header -->
                <div class="page-header">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
                        <h1><i class="fas fa-plus-circle mr-2"></i>Thêm Từ Vựng Mới</h1>
                    </div>
                </div>

                <!-- Error Alert -->
                <c:if test="${not empty requestScope.errorMessage_addVocab}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <strong>Lỗi!</strong> <c:out value="${requestScope.errorMessage_addVocab}"/>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>

                <!-- Enhanced Form Card -->
                <div class="form-card">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/add-vocabulary-action" id="vocabularyForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vocabWord">
                                        <i class="fas fa-font mr-1"></i>
                                        Từ vựng (Word) <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-icon">
                                        <i class="fas fa-spell-check icon"></i>
                                        <input type="text" 
                                               class="form-control form-control-lg" 
                                               id="vocabWord" 
                                               name="vocabWord" 
                                               required 
                                               value="<c:out value='${param.vocabWord}'/>"
                                               placeholder="Nhập từ vựng...">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vocabMeaning">
                                        <i class="fas fa-language mr-1"></i>
                                        Nghĩa (Meaning) <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-icon">
                                        <i class="fas fa-book icon"></i>
                                        <input type="text" 
                                               class="form-control form-control-lg" 
                                               id="vocabMeaning" 
                                               name="vocabMeaning" 
                                               required 
                                               value="<c:out value='${param.vocabMeaning}'/>"
                                               placeholder="Nhập nghĩa của từ vựng...">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="vocabExample">
                                <i class="fas fa-quote-left mr-1"></i>
                                Ví dụ (Example)
                            </label>
                            <textarea class="form-control form-control-lg" 
                                      id="vocabExample" 
                                      name="vocabExample" 
                                      rows="4"
                                      placeholder="Nhập câu ví dụ sử dụng từ vựng này..."><c:out value='${param.vocabExample}'/></textarea>
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle mr-1"></i>
                                Nhập một hoặc nhiều câu ví dụ để minh họa cách sử dụng từ vựng
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="lessonId">
                                <i class="fas fa-graduation-cap mr-1"></i>
                                Lesson ID (Tùy chọn)
                            </label>
                            <div class="input-icon">
                                <i class="fas fa-hashtag icon"></i>
                                <input type="number" 
                                       class="form-control form-control-lg" 
                                       id="lessonId" 
                                       name="lessonId" 
                                       placeholder="Nhập ID bài học..." 
                                       value="<c:out value='${param.lessonId}'/>"
                                       min="1">
                            </div>
                            <small class="form-text text-muted">
                                <i class="fas fa-lightbulb mr-1"></i>
                                Nếu từ vựng này thuộc một bài học cụ thể, hãy nhập ID của bài học đó. Để trống nếu không thuộc bài học nào.
                            </small>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                <i class="fas fa-save mr-2"></i>
                                Thêm Từ Vựng
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/manage-vocabulary" 
                               class="btn btn-secondary btn-lg">
                                <i class="fas fa-times mr-2"></i>
                                Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <!-- jQuery 3.7.1 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <!-- Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <!-- Bootstrap 4.5.2 JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Feather Icons -->
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize feather icons
            if (typeof feather !== 'undefined') {
                feather.replace();
            }

            // Form validation and enhancement
            const form = $('#vocabularyForm');
            const submitBtn = $('#submitBtn');

            // Real-time validation feedback
            function validateField(field) {
                const value = field.val().trim();
                const isValid = value.length > 0;
                
                field.toggleClass('is-valid', isValid && !field.hasClass('is-invalid'))
                     .toggleClass('is-invalid', !isValid && field.is(':required'));
                
                return isValid;
            }

            // Add real-time validation
            $('input[required], textarea[required]').on('blur keyup', function() {
                validateField($(this));
            });

            // Form submission handling
            form.on('submit', function(e) {
                let isValid = true;
                
                // Validate required fields
                $('input[required], textarea[required]').each(function() {
                    if (!validateField($(this))) {
                        isValid = false;
                    }
                });

                // Additional validation for lesson ID
                const lessonId = $('#lessonId').val();
                if (lessonId && (isNaN(lessonId) || parseInt(lessonId) < 1)) {
                    $('#lessonId').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#lessonId').removeClass('is-invalid');
                }

                if (!isValid) {
                    e.preventDefault();
                    
                    // Show error message
                    if ($('.alert-danger').length === 0) {
                        const errorAlert = `
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle mr-2"></i>
                                <strong>Lỗi!</strong> Vui lòng kiểm tra lại thông tin đã nhập.
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                        `;
                        $('.page-header').after(errorAlert);
                    }
                    
                    // Scroll to first invalid field
                    const firstInvalid = $('.is-invalid').first();
                    if (firstInvalid.length) {
                        $('html, body').animate({
                            scrollTop: firstInvalid.offset().top - 100
                        }, 300);
                        firstInvalid.focus();
                    }
                } else {
                    // Show loading state
                    submitBtn.addClass('loading').prop('disabled', true);
                    submitBtn.find('i').removeClass('fa-save').addClass('fa-spinner fa-spin');
                    submitBtn.find('.btn-text').text('Đang xử lý...');
                }
            });

            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert').not('.alert-permanent').fadeOut();
            }, 5000);

            // Enhance input experience
            $('.form-control').on('focus', function() {
                $(this).parent().addClass('focused');
            }).on('blur', function() {
                $(this).parent().removeClass('focused');
            });

            // Character counter for textarea
            const textarea = $('#vocabExample');
            if (textarea.length) {
                const maxLength = 500;
                const counter = $('<small class="form-text text-muted text-right mt-1"><span class="char-count">0</span>/' + maxLength + ' ký tự</small>');
                textarea.after(counter);
                
                textarea.on('input', function() {
                    const length = $(this).val().length;
                    counter.find('.char-count').text(length);
                    counter.toggleClass('text-warning', length > maxLength * 0.8)
                           .toggleClass('text-danger', length > maxLength);
                });
            }

            // Smooth scrolling for internal links
            $('a[href^="#"]').on('click', function(e) {
                e.preventDefault();
                const target = $(this.getAttribute('href'));
                if (target.length) {
                    $('html, body').animate({
                        scrollTop: target.offset().top - 70
                    }, 300);
                }
            });

            // Add hover effects to buttons
            $('.btn').hover(
                function() { $(this).addClass('shadow'); },
                function() { $(this).removeClass('shadow'); }
            );
        });

        // Prevent form resubmission on page refresh
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }
    </script>
</body>
</html>