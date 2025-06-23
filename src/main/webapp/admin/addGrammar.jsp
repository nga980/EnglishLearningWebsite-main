<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm Chủ Đề Ngữ Pháp Mới - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    <style>
        .admin-main-content {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        
        .content-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 20px 30px;
        }
        
        .card-header-custom h1 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .card-body-custom {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            color: #495057;
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }
        
        .form-label i {
            margin-right: 8px;
            color: #667eea;
        }
        
        .form-control-enhanced {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fff;
            width: 100%;
            min-height: 50px;
            line-height: 1.6;
        }
        
        /* Fix cho select box - Desktop */
        select.form-control-enhanced {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px 12px;
            padding: 15px 50px 15px 15px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            min-height: 55px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        /* Style cho options */
        select.form-control-enhanced option {
            padding: 12px 15px;
            background: #fff;
            color: #495057;
            font-size: 1rem;
            line-height: 1.8;
            font-weight: 500;
            white-space: normal;
            word-wrap: break-word;
            min-height: 45px;
        }
        
        /* Fix cho các browser khác nhau */
        select.form-control-enhanced::-ms-expand {
            display: none;
        }
        
        /* Đảm bảo dropdown hiển thị đúng trên tất cả browsers */
        @supports (-webkit-appearance: none) or (-moz-appearance: none) {
            select.form-control-enhanced {
                background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23495057' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3E%3C/svg%3E");
            }
        }
        
        .form-control-enhanced:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            background: #fff;
            outline: none;
        }
        
        .form-control-enhanced:hover {
            border-color: #adb5bd;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
        }
        
        .btn-secondary-custom {
            background: #6c757d;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-secondary-custom:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        
        .alert-enhanced {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(220, 53, 69, 0.15);
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: flex-start;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .difficulty-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
            border-radius: 4px;
            margin-left: 8px;
        }
        
        .difficulty-info {
            margin-top: 10px;
            padding: 10px;
            border-radius: 6px;
            font-size: 0.85rem;
            display: none;
        }
        
        .difficulty-beginner {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .difficulty-intermediate {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .difficulty-advanced {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @media (max-width: 768px) {
            .admin-main-content {
                padding: 15px;
            }
            
            .card-body-custom {
                padding: 20px;
            }
            
            .card-header-custom {
                padding: 15px 20px;
            }
            
            .card-header-custom h1 {
                font-size: 1.3rem;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                margin-bottom: 10px;
            }
            
            /* Mobile select box adjustments */
            select.form-control-enhanced {
                font-size: 0.95rem;
                padding: 12px 45px 12px 12px;
                min-height: 50px;
                background-size: 14px 10px;
                background-position: right 12px center;
            }
            
            select.form-control-enhanced option {
                font-size: 0.95rem;
                padding: 10px 12px;
                line-height: 1.6;
            }
        }
        
        @media (max-width: 576px) {
            .form-label {
                font-size: 0.9rem;
            }
            
            .form-control-enhanced {
                font-size: 0.9rem;
                padding: 10px 12px;
            }
            
            select.form-control-enhanced {
                padding: 10px 40px 10px 12px;
                font-size: 0.9rem;
                min-height: 48px;
                background-size: 12px 8px;
                background-position: right 10px center;
            }
            
            select.form-control-enhanced option {
                font-size: 0.9rem;
                padding: 8px 10px;
                line-height: 1.5;
            }
        }
        
        .textarea-container {
            position: relative;
        }
        
        .character-count {
            position: absolute;
            bottom: 10px;
            right: 15px;
            font-size: 0.8rem;
            color: #6c757d;
            background: rgba(255,255,255,0.9);
            padding: 2px 6px;
            border-radius: 4px;
        }
        
        .form-floating {
            position: relative;
        }
        
        .form-floating .form-control-enhanced {
            padding: 20px 15px 10px 15px;
        }
        
        .form-floating label {
            position: absolute;
            top: 15px;
            left: 15px;
            transition: all 0.3s ease;
            pointer-events: none;
            color: #6c757d;
        }
        
        .form-floating .form-control-enhanced:focus ~ label,
        .form-floating .form-control-enhanced:not(:placeholder-shown) ~ label {
            top: 5px;
            font-size: 0.8rem;
            color: #667eea;
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>
    
    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="container-fluid px-0">
            <div class="content-card">
                <div class="card-header-custom">
                    <h1><i class="fas fa-plus-circle mr-2"></i>Thêm Chủ Đề Ngữ Pháp Mới</h1>
                </div>
                
                <div class="card-body-custom">
                    <c:if test="${not empty requestScope.errorMessage_addGrammar}">
                        <div class="alert alert-danger alert-enhanced" role="alert">
                            <i class="fas fa-exclamation-triangle mr-2"></i>
                            <c:out value="${requestScope.errorMessage_addGrammar}"/>
                        </div>
                    </c:if>
                    
                    <form method="POST" action="${pageContext.request.contextPath}/admin/add-grammar-action" id="grammarForm">
                        <div class="row">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="title" class="form-label">
                                        <i class="fas fa-heading"></i>Tiêu đề
                                    </label>
                                    <input type="text" 
                                           class="form-control form-control-enhanced" 
                                           id="title" 
                                           name="title" 
                                           required 
                                           placeholder="Nhập tiêu đề chủ đề ngữ pháp..."
                                           value="<c:out value='${param.title}'/>"
                                           maxlength="200">
                                    <div class="invalid-feedback">
                                        Vui lòng nhập tiêu đề.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="form-group">
                                    <label for="content" class="form-label">
                                        <i class="fas fa-file-alt"></i>Nội dung
                                    </label>
                                    <div class="textarea-container">
                                        <textarea class="form-control form-control-enhanced" 
                                                  id="content" 
                                                  name="content" 
                                                  rows="12" 
                                                  required
                                                  placeholder="Nhập nội dung chi tiết về chủ đề ngữ pháp..."><c:out value='${param.content}'/></textarea>
                                    </div>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập nội dung.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-lg-4">
                                <div class="form-group">
                                    <label for="difficultyLevel" class="form-label">
                                        <i class="fas fa-layer-group"></i>Mức độ khó
                                    </label>
                                    <select class="form-control form-control-enhanced" id="difficultyLevel" name="difficultyLevel">
                                        <option value="Beginner" ${param.difficultyLevel == 'Beginner' ? 'selected' : ''}>
                                            🟢 Beginner - Dễ
                                        </option>
                                        <option value="Intermediate" ${param.difficultyLevel == 'Intermediate' ? 'selected' : ''}>
                                            🟡 Intermediate - Trung Bình 
                                        </option>
                                        <option value="Advanced" ${param.difficultyLevel == 'Advanced' ? 'selected' : ''}>
                                            🔴 Advanced - Khó
                                        </option>
                                    </select>
                                    
                                    <!-- Thông tin mức độ khó -->
                                    <div id="difficulty-beginner" class="difficulty-info difficulty-beginner">
                                        <strong>Beginner:</strong> Dễ
                                    </div>
                                    <div id="difficulty-intermediate" class="difficulty-info difficulty-intermediate">
                                        <strong>Intermediate:</strong> Trung Bình
                                    </div>
                                    <div id="difficulty-advanced" class="difficulty-info difficulty-advanced">
                                        <strong>Advanced:</strong> Khó
                                    </div>
                                </div>
                                
                                <div class="card border-left-primary shadow-sm h-100">
                                    <div class="card-body">
                                        <h6 class="text-primary mb-2">
                                            <i class="fas fa-lightbulb mr-1"></i>Gợi ý viết nội dung
                                        </h6>
                                        <ul class="list-unstyled small text-muted mb-0">
                                            <li><i class="fas fa-check text-success mr-1"></i> Sử dụng ví dụ cụ thể và dễ hiểu</li>
                                            <li><i class="fas fa-check text-success mr-1"></i> Giải thích ngữ pháp một cách rõ ràng</li>
                                            <li><i class="fas fa-check text-success mr-1"></i> Cấu trúc nội dung logic và khoa học</li>
                                            <li><i class="fas fa-check text-success mr-1"></i> Thêm bảng công thức nếu cần thiết</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="exampleSentences" class="form-label">
                                        <i class="fas fa-quote-left"></i>Ví dụ minh họa
                                    </label>
                                    <div class="textarea-container">
                                        <textarea class="form-control form-control-enhanced" 
                                                  id="exampleSentences" 
                                                  name="exampleSentences" 
                                                  rows="8"
                                                  placeholder="Nhập các câu ví dụ minh họa cho chủ đề ngữ pháp. Mỗi ví dụ một dòng..."><c:out value='${param.exampleSentences}'/></textarea>
                                    </div>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-info-circle mr-1"></i>
                                        Gợi ý: Mỗi ví dụ nên có cả tiếng Anh và tiếng Việt để dễ hiểu
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary-custom">
                                <i class="fas fa-save mr-2"></i>Thêm Chủ Đề
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/manage-grammar" class="btn btn-secondary-custom">
                                <i class="fas fa-times mr-2"></i>Hủy Bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>
    
    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize Feather Icons
            feather.replace();
            
            // Show difficulty info based on selection
            function showDifficultyInfo() {
                $('.difficulty-info').hide();
                const selectedValue = $('#difficultyLevel').val();
                $(`#difficulty-${selectedValue.toLowerCase()}`).show();
            }
            
            // Initialize difficulty info
            showDifficultyInfo();
            
            // Handle difficulty level change
            $('#difficultyLevel').on('change', function() {
                showDifficultyInfo();
            });
            
            // Initialize TinyMCE
            tinymce.init({
                selector: 'textarea#content, textarea#exampleSentences',
                height: 300,
                plugins: [
                    'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 
                    'preview', 'anchor', 'searchreplace', 'visualblocks', 'code', 
                    'fullscreen', 'insertdatetime', 'media', 'table', 'help', 'wordcount'
                ],
                toolbar: 'undo redo | blocks | bold italic forecolor backcolor | ' +
                         'alignleft aligncenter alignright alignjustify | ' +
                         'bullist numlist outdent indent | removeformat | help',
                content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; font-size:14px }',
                branding: false,
                statusbar: true,
                resize: true,
                setup: function(editor) {
                    editor.on('change', function() {
                        editor.save();
                    });
                }
            });
            
            // Form validation
            $('#grammarForm').on('submit', function(e) {
                let isValid = true;
                
                // Validate title
                const title = $('#title').val().trim();
                if (title.length === 0) {
                    $('#title').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#title').removeClass('is-invalid').addClass('is-valid');
                }
                
                // Validate content (TinyMCE)
                const content = tinymce.get('content').getContent();
                if (content.trim().length === 0) {
                    $('#content').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#content').removeClass('is-invalid').addClass('is-valid');
                }
                
                if (!isValid) {
                    e.preventDefault();
                    $('html, body').animate({
                        scrollTop: $('.is-invalid').first().offset().top - 100
                    }, 500);
                    return false;
                }
                
                // Show loading overlay
                $('#loadingOverlay').show();
            });
            
            // Real-time validation
            $('#title').on('input', function() {
                const value = $(this).val().trim();
                if (value.length > 0) {
                    $(this).removeClass('is-invalid').addClass('is-valid');
                } else {
                    $(this).removeClass('is-valid').addClass('is-invalid');
                }
            });
            
            // Character counter for title
            $('#title').on('input', function() {
                const maxLength = 200;
                const currentLength = $(this).val().length;
                const remaining = maxLength - currentLength;
                
                if (!$('#title-counter').length) {
                    $(this).after('<small id="title-counter" class="form-text text-muted"></small>');
                }
                
                $('#title-counter').text(`${currentLength}/${maxLength} ký tự`);
                
                if (remaining < 20) {
                    $('#title-counter').removeClass('text-muted').addClass('text-warning');
                }
                if (remaining < 0) {
                    $('#title-counter').removeClass('text-warning').addClass('text-danger');
                }
                if (remaining >= 20) {
                    $('#title-counter').removeClass('text-warning text-danger').addClass('text-muted');
                }
            });
            
            // Auto-save draft functionality (optional)
            let autoSaveTimer;
            function autoSaveDraft() {
                const formData = {
                    title: $('#title').val(),
                    content: tinymce.get('content') ? tinymce.get('content').getContent() : '',
                    exampleSentences: tinymce.get('exampleSentences') ? tinymce.get('exampleSentences').getContent() : '',
                    difficultyLevel: $('#difficultyLevel').val()
                };
                
                // Save to sessionStorage as backup (không dùng localStorage)
                sessionStorage.setItem('grammar_draft', JSON.stringify(formData));
                
                // Show auto-save indicator
                if (!$('#autosave-indicator').length) {
                    $('.card-header-custom h1').after('<small id="autosave-indicator" class="ml-2 text-light"><i class="fas fa-save mr-1"></i>Đã lưu tự động</small>');
                }
                
                setTimeout(function() {
                    $('#autosave-indicator').fadeOut();
                }, 2000);
            }
            
            // Trigger auto-save on input
            $('#title, #difficultyLevel').on('input change', function() {
                clearTimeout(autoSaveTimer);
                autoSaveTimer = setTimeout(autoSaveDraft, 3000);
            });
            
            // Load draft on page load
            const savedDraft = sessionStorage.getItem('grammar_draft');
            if (savedDraft && !$('#title').val()) {
                const draft = JSON.parse(savedDraft);
                if (confirm('Có bản nháp đã lưu. Bạn có muốn khôi phục không?')) {
                    $('#title').val(draft.title);
                    $('#difficultyLevel').val(draft.difficultyLevel).trigger('change');
                    // TinyMCE content will be restored after initialization
                }
            }
            
            // Clear draft on successful submission
            $('#grammarForm').on('submit', function() {
                sessionStorage.removeItem('grammar_draft');
            });
            
            // Smooth scrolling for anchor links
            $('a[href^="#"]').on('click', function(e) {
                e.preventDefault();
                const target = $(this.getAttribute('href'));
                if (target.length) {
                    $('html, body').animate({
                        scrollTop: target.offset().top - 100
                    }, 1000);
                }
            });
            
            // Add tooltips to buttons
            $('[data-toggle="tooltip"]').tooltip();
            
            // Enhanced mobile experience
            if ($(window).width() < 768) {
                $('.form-control-enhanced').addClass('form-control-sm');
            }
        });
        
        // Prevent accidental page leave
        window.addEventListener('beforeunload', function(e) {
            const title = document.getElementById('title').value;
            const content = tinymce.get('content') ? tinymce.get('content').getContent() : '';
            
            if (title.trim() || content.trim()) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
    </script>
</body>
</html>