<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@page import="model.Lesson" %>
<%@page import="model.QuizQuestion" %>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Quiz cho: <c:out value="${lesson.title}"/></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <!-- TinyMCE -->
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        :root {
            --primary-color: #007bff;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
        }

        .admin-main-content {
            padding: 0 15px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #0056b3 100%);
            color: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.2);
        }

        .page-header h1 {
            margin: 0;
            font-weight: 600;
            font-size: 1.8rem;
        }

        .page-header .btn {
            border: 2px solid white;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .page-header .btn:hover {
            background: white;
            color: var(--primary-color);
            transform: translateY(-2px);
        }

        .section-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            border: none;
            margin-bottom: 30px;
            overflow: hidden;
        }

        .section-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px 25px;
            border-bottom: 3px solid var(--primary-color);
        }

        .section-header h4 {
            margin: 0;
            color: var(--dark-color);
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .section-header i {
            margin-right: 10px;
            color: var(--primary-color);
        }

        .question-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .question-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .question-header {
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
            color: white;
            padding: 15px 20px;
            font-weight: 500;
        }

        .question-number {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-right: 10px;
        }

        .option-item {
            border: none;
            padding: 12px 20px;
            transition: all 0.2s ease;
            border-left: 4px solid transparent;
        }

        .option-item:hover {
            background-color: rgba(0, 123, 255, 0.05);
            border-left-color: var(--primary-color);
        }

        .correct-answer {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(40, 167, 69, 0.05) 100%);
            border-left: 4px solid var(--success-color) !important;
            font-weight: 500;
        }

        .correct-badge {
            background: var(--success-color);
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            margin-left: 10px;
        }

        .btn-action {
            border-radius: 8px;
            padding: 8px 15px;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0 2px;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .form-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        .option-row {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .option-row:hover {
            border-color: var(--primary-color);
            background: rgba(0, 123, 255, 0.02);
        }

        .option-label {
            background: var(--primary-color);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            flex-shrink: 0;
        }

        .radio-wrapper {
            display: flex;
            align-items: center;
            flex-shrink: 0;
            min-width: 70px;
            margin-left: 10px; /* MODIFICATION: Added to increase space from input field */
        }

        .custom-radio {
            width: 20px;
            height: 20px;
            margin-right: 5px;
            margin-bottom: 0;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(40, 167, 69, 0.05) 100%);
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1) 0%, rgba(220, 53, 69, 0.05) 100%);
            border-left: 4px solid var(--danger-color);
        }

        .submit-btn {
            background: linear-gradient(135deg, var(--success-color) 0%, #1e7e34 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 20px 15px;
                text-align: center;
            }

            .page-header h1 {
                font-size: 1.5rem;
                margin-bottom: 15px;
            }

            .question-header {
                padding: 12px 15px;
            }

            .question-header .btn-group {
                flex-direction: column;
                width: 100%;
            }

            .btn-action {
                margin: 2px 0;
                width: 100%;
            }

            .option-row {
                padding: 10px;
            }

            .option-row .d-flex {
                flex-wrap: wrap;
                gap: 10px;
            }

            .option-label {
                width: 35px;
                height: 35px;
                font-size: 0.9rem;
                flex-shrink: 0;
            }

            .radio-wrapper {
                min-width: auto; /* This override will still inherit margin-left: 10px */
            }

            .form-section {
                padding: 20px 15px;
            }
        }

        @media (max-width: 576px) {
            .admin-main-content {
                padding: 0 10px;
            }

            .section-header {
                padding: 15px;
            }

            .question-card {
                margin-bottom: 15px;
            }
            
            .option-item {
                padding: 10px 15px;
            }
        }

        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-lessons"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <!-- Page Header -->
        <div class="page-header fade-in">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center">
                <h1 class="mb-3 mb-md-0">
                    <i class="fas fa-question-circle"></i>
                    Quản Lý Quiz: "<c:out value="${lesson.title}"/>"
                </h1>
                <a href="${pageContext.request.contextPath}/admin/manage-lessons" class="btn btn-outline-light btn-action">
                    <i class="fas fa-arrow-left"></i>
                    <span class="d-none d-sm-inline ml-2">Quay lại Danh sách</span>
                </a>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.successMessage_quiz}">
            <div class="alert alert-success fade-in" role="alert">
                <i class="fas fa-check-circle mr-2"></i>
                <c:out value="${sessionScope.successMessage_quiz}"/>
            </div>
            <% session.removeAttribute("successMessage_quiz"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage_quiz}">
            <div class="alert alert-danger fade-in" role="alert">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                <c:out value="${sessionScope.errorMessage_quiz}"/>
            </div>
            <% session.removeAttribute("errorMessage_quiz"); %>
        </c:if>

        <!-- Questions List Section -->
        <div class="section-card fade-in">
            <div class="section-header">
                <h4>
                    <i class="fas fa-list-ul"></i>
                    Các câu hỏi hiện có
                    <c:if test="${not empty questionList}">
                        <span class="badge badge-primary ml-2">${questionList.size()}</span>
                    </c:if>
                </h4>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty questionList}">
                        <div class="row">
                            <c:forEach var="question" items="${questionList}" varStatus="loop">
                                <div class="col-12 col-xl-6 mb-4">
                                    <div class="question-card">
                                        <div class="question-header d-flex flex-column flex-sm-row justify-content-between align-items-start">
                                            <div class="mb-2 mb-sm-0">
                                                <span class="question-number">Câu ${loop.count}</span>
                                                <span><c:out value="${question.questionText}" escapeXml="false"/></span>
                                            </div>
                                            <div class="btn-group flex-shrink-0">
                                                <a href="${pageContext.request.contextPath}/admin/edit-quiz-question-form?questionId=${question.questionId}" 
                                                   class="btn btn-sm btn-info btn-action">
                                                    <i class="fas fa-edit"></i>
                                                    <span class="d-none d-sm-inline ml-1">Sửa</span>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-outline-danger btn-action" 
                                                        onclick="confirmDelete(${question.questionId}, ${lesson.lessonId})">
                                                    <i class="fas fa-trash"></i>
                                                    <span class="d-none d-sm-inline ml-1">Xóa</span>
                                                </button>
                                            </div>
                                        </div>                      
                                        <ul class="list-group list-group-flush">
                                            <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
                                                <li class="list-group-item option-item ${option.isCorrect ? 'correct-answer' : ''}">
                                                    <i class="fas fa-${optionStatus.index == 0 ? 'circle' : optionStatus.index == 1 ? 'circle' : optionStatus.index == 2 ? 'circle' : 'circle'} mr-2"></i>
                                                    <c:out value="${option.optionText}"/>
                                                    <c:if test="${option.isCorrect}">
                                                        <span class="correct-badge">
                                                            <i class="fas fa-check"></i> Đúng
                                                        </span>
                                                    </c:if>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-question-circle"></i>
                            <h5>Chưa có câu hỏi nào</h5>
                            <p class="mb-0">Hãy thêm câu hỏi đầu tiên cho bài học này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Add New Question Form -->
        <div class="form-section fade-in">
            <h4 class="mb-4">
                <i class="fas fa-plus-circle text-success mr-2"></i>
                Thêm Câu Hỏi Mới
            </h4>
            <form method="POST" action="${pageContext.request.contextPath}/admin/add-quiz-question" id="addQuestionForm">
                <input type="hidden" name="lessonId" value="<c:out value='${lesson.lessonId}'/>">

                <div class="form-group">
                    <label for="questionText">
                        <i class="fas fa-question mr-2"></i>
                        Nội dung câu hỏi:
                    </label>
                    <textarea class="form-control" id="questionText" name="questionText" rows="3" 
                              placeholder="Nhập nội dung câu hỏi..." ></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-list mr-2"></i>
                        Các lựa chọn và đáp án đúng:
                    </label>
                </div>

                <!-- Option A -->
                <div class="option-row">
                    <div class="d-flex align-items-center">
                        <div class="option-label mr-3">A</div>
                        <div class="flex-grow-1 mr-3">
                            <input type="text" class="form-control" name="optionText" 
                                   placeholder="Nội dung lựa chọn A" required>
                        </div>
                        <div class="radio-wrapper">
                            <input class="form-check-input custom-radio" type="radio" 
                                   name="correctOption" id="correctA" value="0" required>
                            <label class="form-check-label small" for="correctA">Đúng</label>
                        </div>
                    </div>
                </div>

                <!-- Option B -->
                <div class="option-row">
                    <div class="d-flex align-items-center">
                        <div class="option-label mr-3">B</div>
                        <div class="flex-grow-1 mr-3">
                            <input type="text" class="form-control" name="optionText" 
                                   placeholder="Nội dung lựa chọn B" required>
                        </div>
                        <div class="radio-wrapper">
                            <input class="form-check-input custom-radio" type="radio" 
                                   name="correctOption" id="correctB" value="1">
                            <label class="form-check-label small" for="correctB">Đúng</label>
                        </div>
                    </div>
                </div>

                <!-- Option C -->
                <div class="option-row">
                    <div class="d-flex align-items-center">
                        <div class="option-label mr-3">C</div>
                        <div class="flex-grow-1 mr-3">
                            <input type="text" class="form-control" name="optionText" 
                                   placeholder="Nội dung lựa chọn C">
                        </div>
                        <div class="radio-wrapper">
                            <input class="form-check-input custom-radio" type="radio" 
                                   name="correctOption" id="correctC" value="2">
                            <label class="form-check-label small" for="correctC">Đúng</label>
                        </div>
                    </div>
                </div>

                <!-- Option D -->
                <div class="option-row">
                    <div class="d-flex align-items-center">
                        <div class="option-label mr-3">D</div>
                        <div class="flex-grow-1 mr-3">
                            <input type="text" class="form-control" name="optionText" 
                                   placeholder="Nội dung lựa chọn D">
                        </div>
                        <div class="radio-wrapper">
                            <input class="form-check-input custom-radio" type="radio" 
                                   name="correctOption" id="correctD" value="3">
                            <label class="form-check-label small" for="correctD">Đúng</label>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn submit-btn">
                        <i class="fas fa-plus mr-2"></i>
                        Thêm Câu Hỏi
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-warning mr-2"></i>
                        Xác nhận xóa
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Bạn có chắc chắn muốn xóa câu hỏi này không? Hành động này không thể hoàn tác.</p>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <i class="fas fa-times mr-1"></i>Hủy
                    </button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>Xóa
                    </a>
                </div>
            </div>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        // Hàm xác nhận xóa câu hỏi
        function confirmDelete(questionId, lessonId) {
            $('#confirmDeleteBtn').attr('href', 
                '${pageContext.request.contextPath}/admin/delete-quiz-question?questionId=' + questionId + '&lessonId=' + lessonId
            );
            $('#deleteModal').modal('show');
        }

        // Cấu hình TinyMCE với chức năng upload file
        tinymce.init({
            selector: 'textarea#questionText',
            height: 350,
            plugins: 'advlist lists link image media table code help wordcount',
            toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image media | code',
            
            // Đảm bảo có servlet xử lý upload tại URL này
            images_upload_url: '${pageContext.request.contextPath}/admin/upload-media',
            automatic_uploads: true,
            file_picker_types: 'image media',
            forced_root_block: false,
            
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

        // Script để đảm bảo TinyMCE lưu nội dung trước khi submit
        $(document).ready(function() {
            // Sửa từ editQuizForm thành addQuestionForm để phù hợp với form hiện tại
            $('#addQuestionForm').on('submit', function() {
                tinymce.triggerSave();
            });

            // Validation form - đảm bảo ít nhất một đáp án được chọn
            $('#addQuestionForm').on('submit', function(e) {
                if (!$('input[name="correctOption"]:checked').length) {
                    e.preventDefault();
                    alert('Vui lòng chọn đáp án đúng!');
                    return false;
                }
                
                // Kiểm tra ít nhất 2 lựa chọn phải được điền
                var filledOptions = 0;
                $('input[name="optionText"]').each(function() {
                    if ($(this).val().trim() !== '') {
                        filledOptions++;
                    }
                });
                
                if (filledOptions < 2) {
                    e.preventDefault();
                    alert('Vui lòng điền ít nhất 2 lựa chọn!');
                    return false;
                }
                
                tinymce.triggerSave();
            });

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
        });

        // Smooth scroll animation for page elements
        $(window).on('load', function() {
            $('.fade-in').each(function(index) {
                $(this).delay(100 * index).animate({
                    opacity: 1
                }, 600);
            });
        });
    </script>
</body>
</html>