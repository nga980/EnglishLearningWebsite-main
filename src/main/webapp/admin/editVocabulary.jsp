<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Từ Vựng - Admin</title>
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
                    <h3><i class="fas fa-edit"></i> Sửa Từ Vựng: <c:out value="${vocabToEdit.word}"/></h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty requestScope.errorMessage_editVocab}">
                        <div class="alert alert-danger" role="alert">
                            <c:out value="${requestScope.errorMessage_editVocab}"/>
                        </div>
                    </c:if>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/update-vocabulary-action" enctype="multipart/form-data">
                        
                        <%-- Hidden input để gửi vocabId --%>
                        <input type="hidden" name="vocabId" value="${vocabToEdit.vocabId}">

                        <div class="form-group">
                            <label for="vocabWord"><strong>Từ vựng (*)</strong></label>
                            <input type="text" class="form-control" id="vocabWord" name="vocabWord" value="<c:out value='${vocabToEdit.word}'/>" required>
                        </div>

                        <div class="form-group">
                            <label for="vocabMeaning"><strong>Nghĩa (*)</strong></label>
                            <input type="text" class="form-control" id="vocabMeaning" name="vocabMeaning" value="<c:out value='${vocabToEdit.meaning}'/>" required>
                        </div>

                        <div class="form-group">
                            <label for="vocabExample">Ví dụ</label>
                            <textarea class="form-control" id="vocabExample" name="vocabExample" rows="3"><c:out value='${vocabToEdit.example}'/></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="lessonId">Thuộc bài học (Tùy chọn)</label>
                            <input type="number" class="form-control" id="lessonId" name="lessonId" value="${vocabToEdit.lessonId}" placeholder="Nhập ID bài học nếu có">
                        </div>
                        
                        <hr>
                        
                        <%-- Phần hiển thị và upload ảnh --%>
                        <div class="form-group">
                            <label><i class="fas fa-image"></i> Ảnh minh họa hiện tại</label>
                            <div>
                                <c:if test="${not empty vocabToEdit.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/${vocabToEdit.imageUrl}" alt="Ảnh minh họa" style="max-width: 200px; max-height: 150px; border-radius: 5px; border: 1px solid #ddd;">
                                    <input type="hidden" name="existingImageUrl" value="${vocabToEdit.imageUrl}">
                                </c:if>
                                <c:if test="${empty vocabToEdit.imageUrl}">
                                    <p class="text-muted">Chưa có ảnh.</p>
                                </c:if>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="imageFile">Tải lên ảnh mới (để thay thế)</label>
                            <input type="file" class="form-control-file" id="imageFile" name="imageFile" accept="image/*">
                        </div>

                        <%-- Phần hiển thị và upload audio --%>
                         <div class="form-group">
                            <label><i class="fas fa-volume-up"></i> File phát âm hiện tại</label>
                            <div>
                                <c:if test="${not empty vocabToEdit.audioUrl}">
                                    <audio controls src="${pageContext.request.contextPath}/${vocabToEdit.audioUrl}"></audio>
                                    <input type="hidden" name="existingAudioUrl" value="${vocabToEdit.audioUrl}">
                                </c:if>
                                <c:if test="${empty vocabToEdit.audioUrl}">
                                    <p class="text-muted">Chưa có audio.</p>
                                </c:if>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="audioFile">Tải lên file phát âm mới (để thay thế)</label>
                            <input type="file" class="form-control-file" id="audioFile" name="audioFile" accept="audio/*">
                        </div>

                        <hr>

                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Cập Nhật</button>
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