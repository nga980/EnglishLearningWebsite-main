<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm Từ Vựng Mới - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-vocabulary"/>
    </jsp:include>
    
    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="container-fluid">
             <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-plus-circle"></i> Thêm Từ Vựng Mới</h3>
                </div>
                <div class="card-body">
                    <%-- Hiển thị thông báo lỗi nếu có --%>
                    <c:if test="${not empty requestScope.errorMessage_addVocab}">
                        <div class="alert alert-danger" role="alert">
                            <c:out value="${requestScope.errorMessage_addVocab}"/>
                        </div>
                    </c:if>

                    <%-- Form thêm từ vựng với enctype để upload file --%>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/add-vocabulary-action" enctype="multipart/form-data">
                        
                        <div class="form-group">
                            <label for="vocabWord"><strong>Từ vựng (*)</strong></label>
                            <input type="text" class="form-control" id="vocabWord" name="vocabWord" required>
                        </div>

                        <div class="form-group">
                            <label for="vocabMeaning"><strong>Nghĩa (*)</strong></label>
                            <input type="text" class="form-control" id="vocabMeaning" name="vocabMeaning" required>
                        </div>

                        <div class="form-group">
                            <label for="vocabExample">Ví dụ</label>
                            <textarea class="form-control" id="vocabExample" name="vocabExample" rows="3"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="lessonId">Thuộc bài học (Tùy chọn)</label>
                            <input type="number" class="form-control" id="lessonId" name="lessonId" placeholder="Nhập ID bài học nếu có">
                        </div>
                        
                        <hr>
                        
                        <div class="form-group">
                            <label for="imageFile"><i class="fas fa-image"></i> Ảnh minh họa (Tùy chọn)</label>
                            <input type="file" class="form-control-file" id="imageFile" name="imageFile" accept="image/*">
                        </div>

                        <div class="form-group">
                            <label for="audioFile"><i class="fas fa-volume-up"></i> File phát âm (Tùy chọn)</label>
                            <input type="file" class="form-control-file" id="audioFile" name="audioFile" accept="audio/*">
                        </div>
                        
                        <hr>
                        
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu Từ Vựng</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-vocabulary" class="btn btn-secondary"><i class="fas fa-times"></i> Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>