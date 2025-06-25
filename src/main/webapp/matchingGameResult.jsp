<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Game Nối Từ - English Learning</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
        }
        .result-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 800px;
            width: 100%;
            text-align: center;
            color: #333;
        }
        .result-container h1 {
            color: #4CAF50; /* Green for success */
            margin-bottom: 20px;
            font-size: 2.8rem;
        }
        .score-display {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 30px;
            color: #059669;
        }
        .score-summary {
            font-size: 1.3rem;
            margin-bottom: 20px;
        }
        .score-summary span {
            font-weight: bold;
            color: #764ba2;
        }
        .incorrect-details, .memorization-stats {
            margin-top: 30px;
            text-align: left;
        }
        .incorrect-details h3, .memorization-stats h3 {
            color: #dc3545;
            margin-bottom: 15px;
            font-size: 1.8rem;
        }
        .memorization-stats h3 {
             color: #667eea;
        }
        .detail-table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
        }
        .detail-table th, .detail-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .detail-table th {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        .detail-table td.status-correct {
            color: green;
            font-weight: bold;
        }
        .detail-table td.status-incorrect {
            color: red;
            font-weight: bold;
        }
        .action-buttons {
            margin-top: 30px;
        }
        .action-buttons .btn {
            margin: 0 10px;
            padding: 12px 30px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #10b981, #059669);
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        .btn-outline-secondary-custom {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
        }
        .btn-outline-secondary-custom:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        .no-data {
            color: #666;
            font-style: italic;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="vocabulary"/>
    </jsp:include>
    <div class="result-container">
        <h1>Kết Quả Game Nối Từ</h1>
        <p class="score-display">
            Bạn đã nối đúng: <span>${finalScore} / ${totalPairs}</span> cặp!
        </p>
        <p class="score-summary">
            Tổng số lần thử sai: <span>${totalIncorrectAttempts}</span>
        </p>

        <div class="incorrect-details">
            <h3>Các từ bạn đã nối sai ít nhất một lần:</h3>
            <c:if test="${not empty incorrectPairsDetails}">
                <table class="detail-table">
                    <thead>
                        <tr>
                            <th>Từ</th>
                            <th>Nghĩa đã chọn</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="pair" items="${incorrectPairsDetails}">
                            <tr>
                                <td><c:out value="${pair.word}"/></td>
                                <td><c:out value="${pair.meaning}"/></td>
                                <td class="status-incorrect"><i class="fas fa-times-circle"></i> Sai</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty incorrectPairsDetails}">
                <p class="no-data">Không có từ nào bạn đã nối sai! Tuyệt vời!</p>
            </c:if>
        </div>

        <div class="memorization-stats">
            <h3>Thống kê mức độ nhớ từ (Số lần sai của mỗi từ):</h3>
            <c:if test="${not empty wordIncorrectCount}">
                <table class="detail-table">
                    <thead>
                        <tr>
                            <th>Từ</th>
                            <th>Số lần sai</th>
                            <th>Đánh giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${wordIncorrectCount}">
                            <tr>
                                <c:set var="vocabId" value="${entry.key}"/>
                                <c:set var="incorrectCount" value="${entry.value}"/>
                                <td>
                                    <c:set var="wordToDisplay" value="N/A"/>
                                    <c:forEach var="pair" items="${allCorrectPairs}">
                                        <c:if test="${pair.wordId == vocabId}">
                                            <c:set var="wordToDisplay" value="${pair.word}"/>
                                            </c:if>
                                    </c:forEach>
                                    <c:if test="${wordToDisplay == 'N/A'}">
                                        <c:forEach var="pair" items="${incorrectPairsDetails}">
                                            <c:if test="${pair.wordId == vocabId}">
                                                <c:set var="wordToDisplay" value="${pair.word}"/>
                                                </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <c:out value="${wordToDisplay}"/>
                                </td>
                                <td><c:out value="${incorrectCount}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${incorrectCount == 1}">
                                            Cần chú ý
                                        </c:when>
                                        <c:when test="${incorrectCount > 1 && incorrectCount <= 3}">
                                            Khó nhớ
                                        </c:when>
                                        <c:when test="${incorrectCount > 3}">
                                            Rất khó nhớ!
                                        </c:when>
                                        <c:otherwise>
                                            Tốt
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty wordIncorrectCount}">
                <p class="no-data">Bạn đã nối đúng tất cả các từ ngay từ lần đầu tiên!</p>
            </c:if>
        </div>


        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/matching-game?lessonId=${lessonId}" class="btn btn-primary-custom">Chơi Lại</a>
            <c:choose>
                <c:when test="${lessonId > 0}">
                    <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lessonId}" class="btn btn-outline-secondary-custom">Quay lại Bài học</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/vocabulary" class="btn btn-outline-secondary-custom">Quay lại Danh sách Từ vựng</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>