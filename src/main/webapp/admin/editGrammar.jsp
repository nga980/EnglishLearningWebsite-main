<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- THÊM DÒNG NÀY ĐỂ SỬA LỖI --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sửa Chủ Đề Ngữ Pháp - Admin</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        .admin-main-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .content-wrapper {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin: 0 auto;
            padding: 2.5rem;
            max-width: 1000px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
        }
        
        .page-header .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 0.5rem;
            position: relative;
            z-index: 1;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        .form-group {
            margin-bottom: 2rem;
        }
        
        .form-group label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.75rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
        }
        
        .form-group label i {
            margin-right: 0.5rem;
            color: #667eea;
        }
        
        .form-control {
            font-size: 1rem;
            padding: 0.875rem 1.25rem;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #495057 !important; /* Force text color */
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            background: white;
            transform: translateY(-2px);
        }
        
        .form-control-lg {
            font-size: 1.1rem;
            padding: 1rem 1.5rem;
        }
        
        /* Fix for select dropdown */
        select.form-control {
            background-color: #f8f9fa !important;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.75rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 2.5rem;
            color: #495057 !important;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        
        select.form-control:focus {
            background-color: white !important;
        }
        
        /* Fix for option text */
        select.form-control option {
            color: #495057 !important;
            background-color: white !important;
            padding: 8px 12px;
            font-size: 1rem;
        }
        
        .difficulty-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }
        
        .difficulty-beginner { background: #d4edda; color: #155724; }
        .difficulty-intermediate { background: #fff3cd; color: #856404; }
        .difficulty-advanced { background: #f8d7da; color: #721c24; }
        
        .btn-group-custom {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2.5rem;
            flex-wrap: wrap;
        }
        
        .btn {
            font-weight: 600;
            padding: 0.875rem 2rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
            min-width: 140px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            border: none;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.4);
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.6);
        }
        
        .form-floating {
            position: relative;
        }
        
        .form-floating > .form-control {
            height: calc(3.5rem + 2px);
            line-height: 1.25;
            padding: 1rem 0.75rem;
        }
        
        .form-floating > label {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            padding: 1rem 0.75rem;
            pointer-events: none;
            border: 1px solid transparent;
            transform-origin: 0 0;
            transition: opacity .1s ease-in-out,transform .1s ease-in-out;
        }
        
        .textarea-wrapper {
            position: relative;
        }
        
        .textarea-counter {
            position: absolute;
            bottom: 10px;
            right: 15px;
            font-size: 0.8rem;
            color: #6c757d;
            background: rgba(255, 255, 255, 0.9);
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            backdrop-filter: blur(5px);
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(102, 126, 234, 0.9);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        
        .loading-spinner {
            width: 3rem;
            height: 3rem;
            border: 0.25rem solid rgba(255, 255, 255, 0.25);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .form-help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .content-wrapper {
                margin: 1rem;
                padding: 1.5rem;
                border-radius: 15px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .btn-group-custom {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
            }
        }
        
        @media (max-width: 576px) {
            .admin-main-content {
                padding: 1rem 0;
            }
            
            .content-wrapper {
                margin: 0.5rem;
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-header h1 {
                font-size: 1.75rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>
    
    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="container-fluid">
            <div class="content-wrapper">
                <div class="page-header">
                    <h1><i class="fas fa-edit mr-3"></i>Sửa Chủ Đề Ngữ Pháp</h1>
                    <p class="subtitle">Chỉnh sửa thông tin chi tiết của chủ đề ngữ pháp</p>
                </div>

                <c:if test="${not empty topicToEdit}">
                    <div class="form-container">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/update-grammar-action" id="grammarForm">
                            <input type="hidden" name="topicId" value="<c:out value='${topicToEdit.topicId}'/>">
                            
                            <div class="form-group">
                                <label for="title">
                                    <i class="fas fa-heading"></i>
                                    Tiêu đề chủ đề
                                </label>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="title" 
                                       name="title" 
                                       required 
                                       maxlength="200"
                                       value="<c:out value='${topicToEdit.title}'/>"
                                       placeholder="Nhập tiêu đề cho chủ đề ngữ pháp...">
                                <div class="form-help-text">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Tiêu đề nên ngắn gọn, rõ ràng và thu hút người học
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="content">
                                    <i class="fas fa-file-alt"></i>
                                    Nội dung bài học
                                </label>
                                <div class="textarea-wrapper">
                                    <textarea class="form-control form-control-lg" 
                                              id="content" 
                                              name="content" 
                                              rows="12" 
                                              required
                                              placeholder="Nhập nội dung chi tiết của bài học..."><c:out value='${topicToEdit.content}'/></textarea>
                                </div>
                                <div class="form-help-text">
                                    <i class="fas fa-lightbulb mr-1"></i>
                                    Sử dụng editor để định dạng văn bản, thêm hình ảnh và liên kết
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="exampleSentences">
                                    <i class="fas fa-quote-left"></i>
                                    Câu ví dụ minh họa
                                </label>
                                <div class="textarea-wrapper">
                                    <textarea class="form-control form-control-lg" 
                                              id="exampleSentences" 
                                              name="exampleSentences" 
                                              rows="8"
                                              placeholder="Thêm các câu ví dụ để minh họa cách sử dụng..."><c:out value='${topicToEdit.exampleSentences}'/></textarea>
                                </div>
                                <div class="form-help-text">
                                    <i class="fas fa-graduation-cap mr-1"></i>
                                    Câu ví dụ giúp học viên hiểu rõ hơn về cách áp dụng ngữ pháp
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="difficultyLevel">
                                    <i class="fas fa-layer-group"></i>
                                    Mức độ khó
                                    <c:if test="${not empty topicToEdit.difficultyLevel}">
                                        <span class="difficulty-badge difficulty-${fn:toLowerCase(topicToEdit.difficultyLevel)}" id="currentDifficultyBadge">
                                            <c:out value="${topicToEdit.difficultyLevel}"/>
                                        </span>
                                    </c:if>
                                </label>
                                <select class="form-control form-control-lg" id="difficultyLevel" name="difficultyLevel" required>
                                    <option value="">-- Chọn mức độ khó --</option>
                                    <option value="Beginner" ${topicToEdit.difficultyLevel eq 'Beginner' ? 'selected' : ''}>
                                        📚 Beginner (Người mới bắt đầu)
                                    </option>
                                    <option value="Intermediate" ${topicToEdit.difficultyLevel eq 'Intermediate' ? 'selected' : ''}>
                                        📖 Intermediate (Trung cấp)
                                    </option>
                                    <option value="Advanced" ${topicToEdit.difficultyLevel eq 'Advanced' ? 'selected' : ''}>
                                        📕 Advanced (Nâng cao)
                                    </option>
                                </select>
                                <div class="form-help-text">
                                    <i class="fas fa-chart-line mr-1"></i>
                                    Chọn mức độ phù hợp với độ phức tạp của nội dung
                                </div>
                            </div>

                            <div class="btn-group-custom">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-save mr-2"></i>
                                    Cập Nhật Chủ Đề
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/manage-grammar" 
                                   class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times mr-2"></i>
                                    Hủy Bỏ
                                </a>
                            </div>
                        </form>
                    </div>
                </c:if>
                
                <c:if test="${empty topicToEdit}">
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        Không tìm thấy chủ đề cần chỉnh sửa. Vui lòng thử lại.
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    
    <script>
        // Initialize Feather Icons
        feather.replace();
        
        // Initialize TinyMCE
        tinymce.init({
            selector: 'textarea#content, textarea#exampleSentences',
            height: 400,
            menubar: false,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount', 'emoticons'
            ],
            toolbar: 'undo redo | blocks fontfamily fontsize | ' +
                     'bold italic underline strikethrough | link image media table | ' +
                     'alignleft aligncenter alignright alignjustify | ' +
                     'bullist numlist outdent indent | forecolor backcolor removeformat | ' +
                     'pagebreak | charmap emoticons | fullscreen preview save print | ' +
                     'insertfile undo redo | help',
            content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; line-height: 1.6; }',
            branding: false,
            promotion: false,
            setup: function (editor) {
                editor.on('change', function () {
                    editor.save();
                });
            }
        });

        $(document).ready(function() {
            // Fix select appearance on different browsers
            function fixSelectDisplay() {
                const select = $('#difficultyLevel');
                
                // Force refresh the select element
                select.trigger('change');
                
                // Ensure proper styling
                select.css({
                    'color': '#495057',
                    'background-color': '#f8f9fa'
                });
            }
            
            // Call fix on page load
            setTimeout(fixSelectDisplay, 100);
            
            // Update difficulty badge when selection changes
            $('#difficultyLevel').on('change', function() {
                const selectedValue = $(this).val();
                const selectedText = $(this).find('option:selected').text();
                let badge = $('#currentDifficultyBadge');
                
                // If badge doesn't exist, create it
                if (badge.length === 0) {
                    $(this).closest('label').append('<span class="difficulty-badge" id="currentDifficultyBadge"></span>');
                    badge = $('#currentDifficultyBadge');
                }
                
                // Remove old classes
                badge.removeClass('difficulty-beginner difficulty-intermediate difficulty-advanced');
                
                // Add new class and text
                if (selectedValue) {
                    badge.addClass('difficulty-' + selectedValue.toLowerCase());
                    badge.text(selectedValue);
                    badge.show();
                } else {
                    badge.hide();
                }
                
                // Debug log
                console.log('Selected value:', selectedValue);
                console.log('Selected text:', selectedText);
            });

            // Form validation and submission
            $('#grammarForm').on('submit', function(e) {
                // Show loading overlay
                $('#loadingOverlay').fadeIn(300);
                
                // Basic validation
                const title = $('#title').val().trim();
                const content = tinymce.get('content').getContent();
                const difficultyLevel = $('#difficultyLevel').val();
                
                if (!title || !content || !difficultyLevel) {
                    e.preventDefault();
                    $('#loadingOverlay').fadeOut(300);
                    
                    if (typeof Swal !== 'undefined') {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi!',
                            text: 'Vui lòng điền đầy đủ thông tin bắt buộc.',
                            confirmButtonColor: '#667eea'
                        });
                    } else {
                        alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
                    }
                    return false;
                }
                
                // If validation passes, form will submit normally
                // Loading overlay will be hidden by page redirect
            });
            
            // Auto-save functionality (optional)
            let autoSaveTimer;
            
            function autoSave() {
                const formData = {
                    title: $('#title').val(),
                    content: tinymce.get('content') ? tinymce.get('content').getContent() : '',
                    exampleSentences: tinymce.get('exampleSentences') ? tinymce.get('exampleSentences').getContent() : '',
                    difficultyLevel: $('#difficultyLevel').val()
                };
                
                // Save to sessionStorage as backup
                sessionStorage.setItem('grammarEditDraft', JSON.stringify(formData));
                
                // Show auto-save indicator
                if (!$('.auto-save-indicator').length) {
                    $('body').append('<div class="auto-save-indicator position-fixed" style="top: 20px; right: 20px; z-index: 1000; background: #28a745; color: white; padding: 8px 16px; border-radius: 20px; font-size: 12px; opacity: 0.8;"><i class="fas fa-check mr-1"></i>Đã lưu tự động</div>');
                    
                    setTimeout(function() {
                        $('.auto-save-indicator').fadeOut(function() {
                            $(this).remove();
                        });
                    }, 2000);
                }
            }
            
            // Trigger auto-save on form changes
            $('#title, #difficultyLevel').on('input change', function() {
                clearTimeout(autoSaveTimer);
                autoSaveTimer = setTimeout(autoSave, 2000);
            });
            
            // Load draft if available
            const savedDraft = sessionStorage.getItem('grammarEditDraft');
            if (savedDraft && confirm('Có dữ liệu đã lưu tạm thời. Bạn có muốn khôi phục?')) {
                try {
                    const draft = JSON.parse(savedDraft);
                    $('#title').val(draft.title || '');
                    $('#difficultyLevel').val(draft.difficultyLevel || '').trigger('change');
                    
                    // Set TinyMCE content after initialization
                    setTimeout(function() {
                        if (tinymce.get('content')) {
                            tinymce.get('content').setContent(draft.content || '');
                        }
                        if (tinymce.get('exampleSentences')) {
                            tinymce.get('exampleSentences').setContent(draft.exampleSentences || '');
                        }
                    }, 1000);
                } catch (e) {
                    console.error('Error loading draft:', e);
                }
            }
            
            // Clear draft on successful submission
            $('#grammarForm').on('submit', function() {
                sessionStorage.removeItem('grammarEditDraft');
            });
            
            // Character counter for title
            $('#title').on('input', function() {
                const maxLength = $(this).attr('maxlength');
                const currentLength = $(this).val().length;
                
                if (!$('.title-counter').length) {
                    $(this).after('<div class="title-counter text-muted small mt-1"></div>');
                }
                
                $('.title-counter').text(currentLength + '/' + maxLength + ' ký tự');
                
                if (currentLength > maxLength * 0.9) {
                    $('.title-counter').addClass('text-warning');
                } else {
                    $('.title-counter').removeClass('text-warning');
                }
            });
            
            // Initialize character counter
            $('#title').trigger('input');
            
            // Smooth scrolling for better UX
            $('html').css('scroll-behavior', 'smooth');
            
            // Add focus effects
            $('.form-control').on('focus', function() {
                $(this).closest('.form-group').addClass('focused');
            }).on('blur', function() {
                $(this).closest('.form-group').removeClass('focused');
            });
            
            // Additional debugging for select
            $('#difficultyLevel').on('click focus', function() {
                console.log('Select clicked/focused');
                console.log('Current value:', $(this).val());
                console.log('Options:', $(this).find('option').map(function() {
                    return $(this).val() + ': ' + $(this).text();
                }).get());
            });
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>