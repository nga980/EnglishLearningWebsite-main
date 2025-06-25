<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sửa Câu Hỏi Quiz - Admin Dashboard</title>
    
    <!-- Bootstrap 4.5.2 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- TinyMCE -->
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    
    <!-- Custom Admin Styles -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #4338ca;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --dark-color: #1f2937;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --border-radius: 12px;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            color: var(--dark-color);
            line-height: 1.6;
        }

        .admin-main-content {
            padding: 2rem;
            min-height: 100vh;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .page-header h1 {
            margin: 0;
            font-weight: 600;
            font-size: 2rem;
        }

        .breadcrumb-nav {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 0.5rem 1rem;
            margin-top: 1rem;
        }

        .breadcrumb-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .breadcrumb-nav a:hover {
            color: white;
        }

        .form-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }

        .form-control {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
        }

        .option-row {
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .option-row:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--card-shadow);
        }

        .option-row.correct-answer {
            background: linear-gradient(135deg, #ecfdf5, #f0fdf4);
            border-color: var(--success-color);
        }

        .option-label {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 2.5rem;
            height: 2.5rem;
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            font-weight: 600;
            font-size: 0.9rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .correct-indicator {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--success-color);
            color: white;
            border-radius: 50%;
            width: 2rem;
            height: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            opacity: 0;
            transform: scale(0);
            transition: all 0.3s ease;
        }

        .option-row.correct-answer .correct-indicator {
            opacity: 1;
            transform: scale(1);
        }

        .custom-radio {
            position: relative;
            display: inline-block;
        }

        .custom-radio input[type="radio"] {
            opacity: 0;
            position: absolute;
        }

        .custom-radio-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            font-weight: 500;
            color: var(--dark-color);
        }

        .custom-radio-indicator {
            width: 1.5rem;
            height: 1.5rem;
            border: 2px solid #d1d5db;
            border-radius: 50%;
            margin-right: 0.5rem;
            position: relative;
            transition: all 0.3s ease;
        }

        .custom-radio input[type="radio"]:checked + .custom-radio-label .custom-radio-indicator {
            border-color: var(--success-color);
            background: var(--success-color);
        }

        .custom-radio input[type="radio"]:checked + .custom-radio-label .custom-radio-indicator::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 0.5rem;
            height: 0.5rem;
            background: white;
            border-radius: 50%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            border-radius: 8px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(79, 70, 229, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(79, 70, 229, 0.4);
        }

        .btn-secondary {
            background: #6b7280;
            border: none;
            border-radius: 8px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-light {
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-outline-light:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.5);
            color: white;
        }

        .alert {
            border: none;
            border-radius: var(--border-radius);
            padding: 1rem 1.5rem;
            font-weight: 500;
        }

        .alert-danger {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #dc2626;
            border-left: 4px solid var(--danger-color);
        }

        .form-actions {
            background: #f9fafb;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .question-preview {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-left: 4px solid var(--primary-color);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

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
            
            .option-row {
                padding: 1rem;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions .btn {
                width: 100%;
            }
        }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        .loading-spinner {
            background: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Đang tải...</span>
            </div>
            <p class="mt-3 mb-0">Đang xử lý...</p>
        </div>
    </div>

    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-start flex-wrap">
                <div>
                    <h1><i class="fas fa-edit mr-3"></i>Sửa Câu Hỏi Quiz</h1>
                </div>
                <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${questionToEdit.lessonId}" 
                   class="btn btn-outline-light">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Quay lại
                </a>
            </div>
        </div>

        <c:if test="${not empty questionToEdit}">
            <div class="form-card">
                <form method="POST" action="${pageContext.request.contextPath}/admin/update-quiz-question" id="editQuizForm">
                    <!-- Hidden Fields -->
                    <input type="hidden" name="questionId" value="<c:out value='${questionToEdit.questionId}'/>">
                    <input type="hidden" name="lessonId" value="<c:out value='${questionToEdit.lessonId}'/>">
                    
                    <!-- Question Text -->
                    <div class="form-group">
                        <label for="questionText">
                            <i class="fas fa-question-circle text-primary mr-2"></i>
                            Nội dung câu hỏi:
                        </label>
                        <textarea class="form-control" id="questionText" name="questionText" 
                                  rows="4" required placeholder="Nhập nội dung câu hỏi..."><c:out value='${questionToEdit.questionText}'/></textarea>
                        <small class="form-text text-muted">
                            <i class="fas fa-info-circle mr-1"></i>
                            Hãy viết câu hỏi rõ ràng và dễ hiểu
                        </small>
                    </div>

                    <!-- Question Preview -->
                    <div class="question-preview">
                        <h6><i class="fas fa-eye mr-2"></i>Xem trước câu hỏi:</h6>
                        <p id="questionPreview" class="mb-0"><c:out value='${questionToEdit.questionText}' escapeXml="false"/></p>
                    </div>

                    <!-- Options Section -->
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-list-ul text-primary mr-2"></i>
                            Các lựa chọn và đáp án đúng:
                        </h5>
                        <small class="text-muted mb-3 d-block">
                            <i class="fas fa-lightbulb mr-1"></i>
                            Chọn đáp án đúng bằng cách click vào nút radio bên phải
                        </small>

                        <c:forEach var="option" items="${questionToEdit.options}" varStatus="loop">
                            <div class="option-row ${option.isCorrect ? 'correct-answer' : ''}" data-option-index="${loop.index}">
                                <div class="correct-indicator">
                                    <i class="fas fa-check"></i>
                                </div>
                                
                                <div class="d-flex align-items-center">
                                    <div class="option-label">
                                        ${loop.count}
                                    </div>
                                    
                                    <div class="flex-grow-1 mr-3">
                                        <input type="hidden" name="optionId" value="${option.optionId}">
                                        <input type="text" class="form-control option-input" 
                                               name="optionText" 
                                               value="<c:out value='${option.optionText}'/>" 
                                               required 
                                               placeholder="Nhập lựa chọn ${loop.count}...">
                                    </div>
                                    
                                    <div class="custom-radio">
                                        <input class="form-check-input" type="radio" 
                                               name="correctOptionIndex" 
                                               value="${loop.index}" 
                                               id="option${loop.index}"
                                               ${option.isCorrect ? 'checked' : ''} required>
                                        <label class="custom-radio-label" for="option${loop.index}">
                                            <span class="custom-radio-indicator"></span>
                                            Đáp án đúng
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save mr-2"></i>
                            Cập Nhật Câu Hỏi
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/manage-quiz?lessonId=${questionToEdit.lessonId}" 
                           class="btn btn-secondary btn-lg">
                            <i class="fas fa-times mr-2"></i>
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </c:if>

        <c:if test="${empty questionToEdit}">
            <div class="form-card">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    <strong>Lỗi!</strong> Không tìm thấy câu hỏi để sửa. Vui lòng thử lại.
                </div>
                <a href="${pageContext.request.contextPath}/admin/manage-quiz" class="btn btn-primary">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Quay lại Quản lý Quiz
                </a>
            </div>
        </c:if>
    </main>

    <!-- jQuery 3.7.1 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <!-- Bootstrap 4.5.2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <!-- Feather Icons -->
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>

    <script>
         // Cấu hình TinyMCE với chức năng upload file
        tinymce.init({
            selector: 'textarea#questionText',
            height: 350,
            plugins: 'advlist lists link image media table code help wordcount',
            toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image media | code',
            
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

        // Form validation
        $(document).ready(function() {
            $('#editQuizForm').on('submit', function() {
                // Trigger save to ensure textarea has the latest content from TinyMCE
                tinymce.triggerSave();
            });
        });
    </script>
</body>
</html>