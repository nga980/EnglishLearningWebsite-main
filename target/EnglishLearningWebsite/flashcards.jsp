<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List, model.Vocabulary, com.google.gson.Gson" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Học với Flashcard - English Learning</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        
        body {
            background-color: #eef2f3;
            font-family: 'Segoe UI', sans-serif;
            overflow-x: hidden;
        }
        .flashcard-wrapper {
            min-height: calc(100vh - 200px); /* Điều chỉnh chiều cao */
        }
        .flashcard-container {
            perspective: 1500px;
            min-height: 450px;
            max-width: 600px;
            margin: auto;
        }
        .flashcard {
            width: 100%;
            height: 450px;
            position: relative;
            transform-style: preserve-3d;
            transition: transform 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
        }
        .flashcard.is-flipped {
            transform: rotateY(180deg);
        }
        .flashcard-face {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            -webkit-backface-visibility: hidden; /* Tăng tương thích */
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.05);
            text-align: center;
        }
        .flashcard-front { background: white; }
        .flashcard-back { background: #f8f9fa; transform: rotateY(180deg); }
        .flashcard-word { font-size: 3.5rem; font-weight: 700; color: #2c3e50; }
        .flashcard-meaning { font-size: 2rem; font-style: italic; color: #2980b9; }
        .flashcard-example { font-size: 1.1rem; color: #7f8c8d; margin-top: 1rem; }
        .flashcard-img { max-height: 120px; max-width: 100%; border-radius: 10px; margin-bottom: 1rem; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .audio-player { margin-top: 1rem; height: 40px; border-radius: 50px; filter: sepia(20%) saturate(70%) grayscale(1) contrast(97%) brightness(90%); }
        .controls { margin-top: 2rem; max-width: 600px; margin-left: auto; margin-right: auto; }
        .controls .btn { font-weight: 600; padding: 0.75rem 1.5rem; border-radius: 50px; transition: all 0.3s ease; }
        .controls .btn:hover { transform: translateY(-3px); box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    <div class="container py-4">
        <div class="text-center mb-4">
            <c:choose>
                <c:when test="${not empty lessonTitle}">
                    <h1 class="mb-1">Flashcard: <span class="text-primary"><c:out value="${lessonTitle}"/></span></h1>
                </c:when>
                <c:otherwise>
                    <h1 class="mb-1">Ôn tập Toàn bộ Từ vựng</h1>
                </c:otherwise>
            </c:choose>
            <p class="text-muted">Nhấn vào thẻ để xem nghĩa hoặc dùng phím cách. Dùng phím mũi tên để chuyển thẻ.</p>
        </div>

        <div class="flashcard-wrapper d-flex align-items-center">
             <c:choose>
                <c:when test="${not empty vocabularyList}">
                    <div class="w-100">
                        <div class="flashcard-container" id="flashcardContainer">
                            <div class="flashcard" id="flashcard">
                                <div class="flashcard-face flashcard-front" id="cardFront"></div>
                                <div class="flashcard-face flashcard-back" id="cardBack"></div>
                            </div>
                        </div>
                        <div class="controls text-center d-flex justify-content-between align-items-center mt-4">
                            <button id="prevBtn" class="btn btn-outline-secondary"><i class="fas fa-arrow-left"></i> Trước</button>
                            <span id="progress" class="text-muted fw-bold"></span>
                            <button id="nextBtn" class="btn btn-primary">Tiếp <i class="fas fa-arrow-right"></i></button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center">
                        <div class="alert alert-warning">Không có từ vựng nào để học trong mục này.</div>
                        <a href="${pageContext.request.contextPath}/vocabulary" class="btn btn-primary mt-3">Quay lại danh sách từ vựng</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%
        List<Vocabulary> vocabList = (List<Vocabulary>) request.getAttribute("vocabularyList");
        Gson gson = new Gson();
        String vocabListJson = (vocabList != null) ? gson.toJson(vocabList) : "[]";
    %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const vocabData = <%= vocabListJson %>;
            
            if (vocabData && vocabData.length > 0) {
                let currentIndex = 0;
                const flashcard = document.getElementById('flashcard');
                const cardFront = document.getElementById('cardFront');
                const cardBack = document.getElementById('cardBack');
                const prevBtn = document.getElementById('prevBtn');
                const nextBtn = document.getElementById('nextBtn');
                const progress = document.getElementById('progress');

                function showCard(index) {
                    flashcard.classList.remove('is-flipped');
                    const vocab = vocabData[index];
                    const contextPath = '<%= request.getContextPath() %>';


                    // === SỬA LỖI HIỂN THỊ TẠI ĐÂY ===
                    // Luôn đảm bảo các biến có giá trị trước khi sử dụng
                    const word = vocab.word || 'N/A';
                    const meaning = vocab.meaning || 'Chưa có nghĩa';
                    const example = vocab.example || '';
                    const hasImage = vocab.hasImage; // Lấy từ helper method trong model
                    const hasAudio = vocab.hasAudio; // Lấy từ helper method trong model
                    
                    // Gán nội dung mặt trước
                    cardFront.innerHTML = '<h2 class="flashcard-word">' + word + '</h2><small class="text-muted">Nhấn để xem nghĩa</small>';
                    
                    // Xây dựng nội dung mặt sau
                    let backHtml = '<h3 class="flashcard-meaning">' + meaning + '</h3>';
                    if (vocab.hasImage) {
                        const imageUrl = `${contextPath}/media?id=${vocab.vocabId}&type=image`;
                        $cardBack.append($('<img>').addClass('flashcard-img').attr('src', imageUrl));
                    }
                    if (example) {
                        backHtml += '<p class="flashcard-example">"' + example + '"</p>';
                    }
                    if (vocab.hasAudio) {
                        const audioUrl = `${contextPath}/media?id=${vocab.vocabId}&type=audio`;
                        $cardBack.append($('<audio>').addClass('audio-player').attr('controls', true).attr('src', audioUrl));
                    }
                    cardBack.innerHTML = backHtml;
                    
                    // Cập nhật giao diện
                    progress.innerText = (index + 1) + ' / ' + vocabData.length;
                    prevBtn.disabled = index === 0;
                    nextBtn.disabled = index === vocabData.length - 1;
                }

                // Gán sự kiện
                flashcard.addEventListener('click', () => flashcard.classList.toggle('is-flipped'));
                prevBtn.addEventListener('click', () => { if (currentIndex > 0) showCard(--currentIndex); });
                nextBtn.addEventListener('click', () => { if (currentIndex < vocabData.length - 1) showCard(++currentIndex); });
                
                document.addEventListener('keydown', function(e) {
                    if (e.key === 'ArrowLeft') prevBtn.click();
                    else if (e.key === 'ArrowRight') nextBtn.click();
                    else if (e.key === ' ') {
                        e.preventDefault();
                        flashcard.click();
                    }
                });

                // Hiển thị thẻ đầu tiên
                showCard(currentIndex);
            }
        });
    </script>
</body>
</html>