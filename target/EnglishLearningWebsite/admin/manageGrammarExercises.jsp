<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, model.GrammarTopic, model.QuizQuestion, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bài Tập: <c:out value="${topic.title}"/></title>
    
    <!-- Bootstrap 4.5.2 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <!-- TinyMCE -->
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            --warning-gradient: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            --danger-gradient: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --card-shadow: 0 8px 25px rgba(0,0,0,0.1);
            --hover-shadow: 0 12px 35px rgba(0,0,0,0.15);
            --border-radius: 12px;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .admin-main-content {
            padding: 2rem;
            margin-top: 1rem;
        }

        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .page-header h1 {
            margin: 0;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            color: white;
            transform: translateY(-2px);
        }

        .card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .card:hover {
            box-shadow: var(--hover-shadow);
            transform: translateY(-5px);
        }

        .card-header {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 1.5rem;
            font-weight: 600;
        }

        .card-header h4 {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .question-card {
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .question-card:hover {
            border-left-color: #4ecdc4;
            transform: translateX(5px);
        }

        .question-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 1px solid #dee2e6;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .question-title {
            font-weight: 600;
            color: #495057;
            margin: 0;
            flex: 1;
            min-width: 200px;
        }

        .question-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-warning {
            background: var(--warning-gradient);
            border: none;
            color: #333;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(252, 182, 159, 0.4);
        }

        .btn-danger {
            background: var(--danger-gradient);
            border: none;
            color: #fff;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 154, 158, 0.4);
        }

        .list-group-item {
            border: none;
            padding: 1rem 1.5rem;
            transition: all 0.3s ease;
        }

        .list-group-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }

        .list-group-item-success {
            background: var(--success-gradient);
            color: white;
            font-weight: 500;
        }

        .badge-success {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }

        .form-control {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .input-group {
            border-radius: 8px;
            overflow: hidden;
        }

        .input-group-text {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-left: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary-gradient);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            padding: 0.5rem 1.5rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
        }

        .alert {
            border: none;
            border-radius: var(--border-radius);
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
        }

        .alert-success {
            background: var(--success-gradient);
            color: white;
        }

        .alert-danger {
            background: var(--danger-gradient);
            color: white;
        }

        .option-row {
            margin-bottom: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .option-row:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .remove-option-btn {
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .remove-option-btn:hover {
            transform: scale(1.1);
        }

        .form-check-input {
            transform: scale(1.2);
            margin-right: 0.5rem;
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }

        .question-counter {
            background: rgba(255,255,255,0.1);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            margin-left: 1rem;
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
            
            .question-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .question-actions {
                justify-content: center;
            }
        }

        .fade-in {
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="page-header animate__animated animate__fadeInDown">
            <div>
                <h1 class="h2">
                    <i class="fas fa-graduation-cap"></i>
                    Bài Tập Ngữ Pháp: "<c:out value="${topic.title}"/>"
                    <span class="question-counter">
                        <i class="fas fa-question-circle"></i>
                        ${not empty questionList ? questionList.size() : 0} câu hỏi
                    </span>
                </h1>
            </div>
            <a href="${pageContext.request.contextPath}/admin/manage-grammar" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success animate__animated animate__fadeInDown">
                <i class="fas fa-check-circle"></i>
                ${sessionScope.successMessage}
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger animate__animated animate__fadeInDown">
                <i class="fas fa-exclamation-circle"></i>
                ${sessionScope.errorMessage}
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <!-- Questions List -->
        <div class="card fade-in">
            <div class="card-header">
                <h4>
                    <i class="fas fa-list-ul"></i>
                    Danh sách câu hỏi
                </h4>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty questionList}">
                        <div id="questionsList">
                            <c:forEach var="question" items="${questionList}" varStatus="loop">
                                <div class="card question-card mb-3 animate__animated animate__fadeInUp" style="animation-delay: ${loop.index * 0.1}s">
                                    <div class="question-header">
                                        <h5 class="question-title">
                                            <span class="badge badge-primary mr-2">${loop.count}</span>
                                            <c:out value="${question.questionText}" escapeXml="false"/>
                                        </h5>
                                        <div class="question-actions">
                                            <a href="${pageContext.request.contextPath}/admin/edit-grammar-exercise-form?questionId=${question.questionId}" 
                                               class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <button onclick="confirmDelete(${question.questionId}, ${topic.topicId})" 
                                                    class="btn btn-sm btn-danger">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </div>
                                    </div>
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="option" items="${question.options}" varStatus="optionLoop">
                                            <div class="list-group-item ${option.isCorrect ? 'list-group-item-success' : ''}">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span>
                                                        <strong>${String.valueOf(65 + optionLoop.index).charAt(0)}.</strong>
                                                        <c:out value="${option.optionText}"/>
                                                    </span>
                                                    <c:if test="${option.isCorrect}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check"></i> Đáp án đúng
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-question-circle fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Chưa có câu hỏi nào cho chủ đề này</h5>
                            <p class="text-muted">Hãy thêm câu hỏi đầu tiên bên dưới!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Add New Question Form -->
        <div class="card fade-in">
            <div class="card-header">
                <h4>
                    <i class="fas fa-plus-circle"></i>
                    Thêm câu hỏi mới
                </h4>
            </div>
            <div class="card-body">
                <form method="POST" action="${pageContext.request.contextPath}/admin/add-grammar-exercise" id="questionForm" onsubmit="return validateForm();">
                    <input type="hidden" name="grammarTopicId" value="${topic.topicId}">
                    
                    <div class="form-group">
                        <label for="questionText">
                            <i class="fas fa-question"></i>
                            Nội dung câu hỏi:
                        </label>
                        <textarea id="questionText" name="questionText" class="form-control" rows="3" 
                                  placeholder="Nhập nội dung câu hỏi..." required></textarea>
                    </div>

                    <div class="form-group">
                        <label>
                            <i class="fas fa-list"></i>
                            Các lựa chọn:
                        </label>
                        <div id="optionsContainer"></div>
                        <button type="button" id="addOptionBtn" class="btn btn-secondary mt-2">
                            <i class="fas fa-plus"></i> Thêm lựa chọn
                        </button>
                    </div>

                    <div class="form-group text-center">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save"></i> Lưu câu hỏi
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Loading Spinner -->
        <div class="loading-spinner" id="loadingSpinner">
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Đang tải...</span>
            </div>
            <p class="mt-2 text-muted">Đang xử lý...</p>
        </div>
    </main>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        const maxOptions = 4;

        // HÀM 1: ĐỊNH NGHĨA Ở PHẠM VI TOÀN CỤC
        function reindexOptions() {
            let visibleIndex = 0;
            $('.option-row').each(function() {
                const optionLabelChar = String.fromCharCode(65 + visibleIndex);
                $(this).find('label:first').html(`<i class="fas fa-check-circle"></i> Lựa chọn ${optionLabelChar}:`);
                $(this).find('input[name="optionText"]').attr('placeholder', `Nội dung lựa chọn ${optionLabelChar}`);
                $(this).find('input[name="correctOptionIndex"]').val(visibleIndex);
                visibleIndex++;
            });
        }

        // HÀM 2: ĐỊNH NGHĨA Ở PHẠM VI TOÀN CỤC
        function createOptionRow() {
            if ($('.option-row').length >= maxOptions) {
                Swal.fire({ icon: 'warning', title: 'Giới hạn lựa chọn', text: 'Bạn chỉ có thể thêm tối đa 4 lựa chọn cho mỗi câu hỏi.' });
                return;
            }
            const displayIndex = $('.option-row').length;
            const optionLabelChar = String.fromCharCode(65 + displayIndex);
            const optionRow = $(`
                <div class="option-row animate__animated animate__fadeInUp">
                    <label><i class="fas fa-check-circle"></i> Lựa chọn ${optionLabelChar}:</label>
                    <div class="input-group">
                        <input type="text" class="form-control" name="optionText" placeholder="Nội dung lựa chọn ${optionLabelChar}" required>
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <input class="form-check-input" type="radio" name="correctOptionIndex" value="${displayIndex}" required>
                                <span class="ml-2">Đáp án đúng</span>
                            </div>
                            <button type="button" class="btn btn-outline-danger remove-option-btn"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>
            `);
            $('#optionsContainer').append(optionRow);
            optionRow.find('input[type="text"]').focus();
        }

        // HÀM 3: ĐỊNH NGHĨA Ở PHẠM VI TOÀN CỤC
        function validateForm() {
            const questionText = tinymce.get('questionText').getContent();
            if (!questionText.trim()) {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Vui lòng nhập nội dung câu hỏi.' });
                return false;
            }
            const options = $('input[name="optionText"]');
            if (options.length < 2) {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Câu hỏi phải có ít nhất 2 lựa chọn.' });
                return false;
            }
            let emptyOptions = false;
            options.each(function() { if (!$(this).val().trim()) { emptyOptions = true; return false; } });
            if (emptyOptions) {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Vui lòng điền đầy đủ nội dung cho tất cả lựa chọn.' });
                return false;
            }
            const correctOption = $('input[name="correctOptionIndex"]:checked');
            if (correctOption.length === 0) {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Vui lòng chọn đáp án đúng.' });
                return false;
            }
            return true;
        }

        // HÀM 4: ĐỊNH NGHĨA Ở PHẠM VI TOÀN CỤC
        function confirmDelete(questionId, grammarTopicId) {
            Swal.fire({
                title: 'Xác nhận xóa',
                text: 'Bạn có chắc chắn muốn xóa câu hỏi này? Hành động này không thể hoàn tác.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    const contextPath = $('body').data('context-path');
                    window.location.href = `${contextPath}/admin/delete-grammar-exercise?questionId=${questionId}&grammarTopicId=${grammarTopicId}`;
                }
            });
        }


        // CHỈ SỬ DỤNG DOCUMENT.READY ĐỂ GẮN SỰ KIỆN VÀ GỌI HÀM KHỞI TẠO
        $(document).ready(function() {
            // Khởi tạo TinyMCE
            tinymce.init({
                selector: 'textarea#questionText',
                height: 300,
                plugins: 'advlist lists link image media table code help wordcount',
                toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image media | code',
                setup: function (editor) { editor.on('change', function () { editor.save(); }); }
            });

            // Gắn sự kiện click
            $('#addOptionBtn').click(function() { createOptionRow(); });

            $(document).on('click', '.remove-option-btn', function() {
                if ($('.option-row').length <= 2) {
                    Swal.fire({ icon: 'warning', title: 'Không thể xóa', text: 'Câu hỏi phải có ít nhất 2 lựa chọn.' });
                    return;
                }
                const wasChecked = $(this).closest('.option-row').find('input[type="radio"]').is(':checked');
                $(this).closest('.option-row').addClass('animate__fadeOutUp');
                setTimeout(() => {
                    $(this).closest('.option-row').remove();
                    reindexOptions();
                    if(wasChecked || $('input[name="correctOptionIndex"]:checked').length === 0) {
                        $('.option-row').first().find('input[type="radio"]').prop('checked', true);
                    }
                }, 300);
            });
            
            // Khởi tạo form với 2 lựa chọn ban đầu
            createOptionRow();
            createOptionRow();

            // Tự động chọn đáp án đúng đầu tiên
            setTimeout(() => {
                $('input[name="correctOptionIndex"]').first().prop('checked', true);
            }, 100);
        });
    </script>
</body>
</html>