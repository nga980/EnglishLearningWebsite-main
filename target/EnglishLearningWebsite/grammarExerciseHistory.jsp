<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Làm Bài Tập Ngữ Pháp - English Learning</title>
    <jsp:include page="/common/head.jsp"/>
    <style>
        .table-hover tbody tr:hover {
            background-color: #f1f3f5;
        }
        .score-badge {
            font-size: 0.9rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp"/>

    <div class="container my-5">
        <h1 class="text-center mb-4">Lịch Sử Làm Bài Tập Ngữ Pháp</h1>

        <c:choose>
            <c:when test="${not empty grammarHistory}">
                <div class="table-responsive shadow-sm rounded">
                    <table class="table table-hover align-middle">
                        <thead class="thead-light">
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Chủ Đề Ngữ Pháp</th>
                                <th scope="col" class="text-center">Điểm Số</th>
                                <th scope="col" class="text-center">Ngày Làm Bài</th>
                                <th scope="col" class="text-right">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${grammarHistory}" varStatus="loop">
                                <tr>
                                    <th scope="row">${loop.count}</th>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${item.topicId}" class="font-weight-bold">
                                            <c:out value="${item.topicTitle}"/>
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <c:set var="percentage" value="${(item.score / item.totalQuestions) * 100}" />
                                        <c:choose>
                                            <c:when test="${percentage >= 80}">
                                                <span class="badge badge-success p-2 score-badge">${item.score}/${item.totalQuestions}</span>
                                            </c:when>
                                            <c:when test="${percentage >= 50}">
                                                <span class="badge badge-warning p-2 score-badge">${item.score}/${item.totalQuestions}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger p-2 score-badge">${item.score}/${item.totalQuestions}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${item.attemptedAt}" pattern="HH:mm, dd/MM/yyyy" />
                                    </td>
                                    <td class="text-right">
                                        <a href="${pageContext.request.contextPath}/grammar-detail?topicId=${item.topicId}" class="btn btn-sm btn-primary">
                                            <i class="fas fa-redo"></i> Luyện tập lại
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <h4 class="alert-heading">Chưa có lịch sử!</h4>
                    <p>Bạn chưa hoàn thành bài tập ngữ pháp nào. Hãy bắt đầu luyện tập ngay thôi!</p>
                    <a href="${pageContext.request.contextPath}/grammar" class="btn btn-primary">Xem các chủ đề ngữ pháp</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="/common/footer.jsp"/>
</body>
</html>