<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Chủ Đề Ngữ Pháp Mới - Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    <script src="https://cdn.tiny.cloud/1/vn0hiraxxi1kjrfnyjmwv5qey0src7qravqh77cccznwy44x/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="manage-grammar"/>
    </jsp:include>
    <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Thêm Chủ Đề Ngữ Pháp Mới</h1>
        </div>
        <c:if test="${not empty requestScope.errorMessage_addGrammar}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${requestScope.errorMessage_addGrammar}"/>
            </div>
        </c:if>
        <form method="POST" action="${pageContext.request.contextPath}/admin/add-grammar-action">
            <div class="form-group">
                <label for="title"><strong>Tiêu đề:</strong></label>
                <input type="text" class="form-control form-control-lg" id="title" name="title" required value="<c:out value='${param.title}'/>">
            </div>
            <div class="form-group">
                <label for="content"><strong>Nội dung:</strong></label>
                <textarea class="form-control form-control-lg" id="content" name="content" rows="10" required><c:out value='${param.content}'/></textarea>
            </div>
            <div class="form-group">
                <label for="exampleSentences"><strong>Ví dụ:</strong></label>
                <textarea class="form-control form-control-lg" id="exampleSentences" name="exampleSentences" rows="5"><c:out value='${param.exampleSentences}'/></textarea>
            </div>
             <div class="form-group">
                <label for="difficultyLevel"><strong>Mức độ:</strong></label>
                <select class="form-control form-control-lg" id="difficultyLevel" name="difficultyLevel">
                    <option value="Beginner" ${param.difficultyLevel == 'Beginner' ? 'selected' : ''}>Beginner</option>
                    <option value="Intermediate" ${param.difficultyLevel == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                    <option value="Advanced" ${param.difficultyLevel == 'Advanced' ? 'selected' : ''}>Advanced</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-lg">Thêm Chủ Đề</button>
            <a href="${pageContext.request.contextPath}/admin/manage-grammar" class="btn btn-secondary btn-lg">Hủy</a>
        </form>
    </main>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script>feather.replace();</script>
    <script>
      tinymce.init({
        selector: 'textarea#content, textarea#exampleSentences', // Tìm đến các textarea có ID là 'content' và 'exampleSentences'
        plugins: [
          'advlist', 'lists', 'link', 'image', 'charmap', 'preview',
          'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
          'insertdatetime', 'media', 'table', 'help', 'wordcount'
        ],
        toolbar: 'undo redo | blocks | ' +
          'bold italic backcolor | alignleft aligncenter ' +
          'alignright alignjustify | bullist numlist outdent indent | ' +
          'removeformat | help'
      });
    </script>
</body>
</html>