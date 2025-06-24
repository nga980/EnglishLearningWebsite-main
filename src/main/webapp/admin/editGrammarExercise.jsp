<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sửa Bài Tập Ngữ Pháp - Admin</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <script src="https://cdn.tiny.cloud/1/YOUR_API_KEY/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

    <style>
        /* Bạn có thể sao chép CSS từ trang editQuizQuestion.jsp nếu muốn giao diện tương tự */
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>

    <main role="main" class="col-md-10 ml-sm-auto admin-main-content p-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2"><i class="fas fa-edit"></i> Sửa Bài Tập Ngữ Pháp</h1>
        </div>

        <c:if test="${not empty requestScope.errorMessage}">
             <div class="alert alert-danger" role="alert">${requestScope.errorMessage}</div>
        </c:if>

        <c:if test="${not empty questionToEdit}">
            <div class="card">
                <div class="card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/update-grammar-exercise">
                        <input type="hidden" name="questionId" value="${questionToEdit.questionId}">
                        <input type="hidden" name="grammarTopicId" value="${questionToEdit.grammarTopicId}">
                        
                        <div class="form-group">
                            <label for="questionText">Nội dung câu hỏi:</label>
                            <textarea id="questionText" name="questionText" class="form-control" rows="8"><c:out value='${questionToEdit.questionText}'/></textarea>
                        </div>

                        <h5 class="mt-4">Các lựa chọn:</h5>
                        <c:forEach var="option" items="${questionToEdit.options}" varStatus="loop">
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" name="correctOption" value="${option.optionId}" ${option.isCorrect() ? 'checked' : ''} required>
                                    </div>
                                </div>
                                <input type="hidden" name="optionId" value="${option.optionId}">
                                <input type="text" class="form-control" name="optionText" value="<c:out value='${option.optionText}'/>" required>
                            </div>
                        </c:forEach>
                        
                        <hr>
                        <a href="${pageContext.request.contextPath}/admin/manage-grammar-exercises?grammarTopicId=${questionToEdit.grammarTopicId}" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Cập Nhật
                        </button>
                    </form>
                </div>
            </div>
        </c:if>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        tinymce.init({
            selector: 'textarea#questionText',
            height: 300,
            plugins: 'advlist lists link image media table code help wordcount',
            toolbar: 'undo redo | blocks | bold italic | alignleft aligncenter alignright | bullist numlist | link image media | code',
            images_upload_url: '${pageContext.request.contextPath}/admin/upload-media',
            automatic_uploads: true,
            file_picker_types: 'image media',
            file_picker_callback: function (cb, value, meta) {
                // ... (sao chép mã file_picker_callback từ các trang khác)
            }
        });
        
        document.getElementById('editQuizForm').addEventListener('submit', function() {
            tinymce.triggerSave();
        });
    </script>
</body>
</html>