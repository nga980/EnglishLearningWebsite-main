<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Vocabulary"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Game Nối Từ - English Learning</title>
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
        }
        .game-header {
            text-align: center;
            color: white;
            margin-bottom: 20px;
        }
        .game-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
        }
        .game-header p {
            font-size: 1.2rem;
            margin-bottom: 10px;
        }
        .game-info {
            color: white;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .game-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 900px;
            width: 100%;
            display: flex;
            justify-content: space-around;
            position: relative;
        }
        .game-column {
            width: 45%;
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .game-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            padding: 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-weight: 500;
            text-align: center;
            min-height: 60px; /* Giữ chiều cao cố định để không bị xê dịch khi mất item */
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 1;
            visibility: visible;
        }
        .game-item.selected {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.3);
            background: #e6f0ff;
        }
        .game-item.matched { /* Used to temporarily disable clicks during processing */
            pointer-events: none;
        }
        .game-item.correct { /* For the successful match visual */
            background: #dcfce7;
            border-color: #10b981;
            color: #166534;
        }
        .game-item.incorrect { /* For the failed match visual */
            background: #ffe6e6;
            border-color: #dc3545;
            color: #b02a37;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease-out, visibility 0.3s ease-out;
        }
        .overlay.show {
            opacity: 1;
            visibility: visible;
        }
        .completion-modal {
            background: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            color: #333;
        }
        .completion-modal h2 {
            font-size: 2.2rem;
            color: #28a745;
            margin-bottom: 20px;
        }
        .completion-modal p {
            font-size: 1.2rem;
            margin-bottom: 15px;
        }
        .completion-modal a {
            background: linear-gradient(135deg, #10b981, #059669);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            margin-top: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .completion-modal a:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16,185,129,0.4);
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="vocabulary"/>
    </jsp:include>

    <div class="game-header">
        <h1>Nối Từ Vựng và Nghĩa</h1>
        <p>Bài học: <c:out value="${lessonId == 0 ? 'Ngẫu nhiên' : lessonId}"/></p>
        <div class="game-info">
            <p>Số cặp còn lại: <span id="remainingPairs"></span></p>
            <p>Số lần sai: <span id="incorrectAttempts">0</span></p>
        </div>
    </div>

    <div class="game-container">
        <div class="game-column words-column" id="wordsColumn">
            <c:forEach var="vocab" items="${wordsColumn}">
                <div class="game-item" data-id="${vocab.vocabId != null && vocab.vocabId != 0 ? vocab.vocabId : ''}" data-type="word">
                    <c:out value="${vocab.word != null && !vocab.word.isEmpty() ? vocab.word : 'Từ không xác định'}"/>
                </div>
            </c:forEach> 
        </div> 
        <div class="game-column meanings-column" id="meaningsColumn">
            <c:forEach var="vocab" items="${meaningsColumn}">
                <div class="game-item" data-id="${vocab.vocabId != null && vocab.vocabId != 0 ? vocab.vocabId : ''}" data-type="meaning">
                    <c:out value="${vocab.meaning != null && !vocab.meaning.isEmpty() ? vocab.meaning : 'Nghĩa không xác định'}"/>
                </div>
            </c:forEach>
        </div>
    </div>

    <div id="completionOverlay" class="overlay">
        <div class="completion-modal">
            <h2>Hoàn thành trò chơi!</h2>
            <p>Bạn đã hoàn thành tất cả các cặp từ.</p>
            <p>Tổng số lần thử sai: <span id="finalIncorrectAttempts">0</span></p>
            <a href="#" id="viewResultBtn">Xem Kết Quả Chi Tiết</a>
        </div>
    </div>

    <form id="gameForm" action="${pageContext.request.contextPath}/matching-game" method="POST" style="display: none;">
        <input type="hidden" name="action" value="submitFinalResult">
        <input type="hidden" name="lessonId" value="${lessonId}">
        <input type="hidden" name="totalIncorrectAttempts" id="totalIncorrectAttemptsInput">
    </form>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function() {
            let selectedItem = null; // Lưu trữ phần tử được chọn đầu tiên
            let incorrectAttemptsCount = 0; // Tổng số lần người dùng nối sai
            let completedPairs = 0; // Số cặp đã hoàn thành (đúng) trong toàn bộ game
            const totalGamePairs = <c:out value="${totalGameVocabularies}"/>; // Tổng số cặp từ trong toàn bộ game

            // Cập nhật hiển thị thông tin game (số cặp còn lại, số lần sai)
            function updateGameInfoDisplay() {
                $('#incorrectAttempts').text(incorrectAttemptsCount);
                $('#remainingPairs').text(totalGamePairs - completedPairs);
            }

            // Gọi lần đầu để hiển thị thông tin game khi trang tải
            updateGameInfoDisplay();

            /**
             * Render lại các cột từ và nghĩa với dữ liệu mới từ server.
             * Hàm này xóa toàn bộ nội dung hiện có và thêm lại các phần tử mới.
             * @param {Array} wordsColumnData Dữ liệu từ vựng cho cột từ.
             * @param {Array} meaningsColumnData Dữ liệu từ vựng cho cột nghĩa.
             */
            /**
             * Render lại các cột từ và nghĩa với dữ liệu mới từ server.
             */
            /**
             * Render lại các cột từ và nghĩa với dữ liệu mới từ server.
             */
            /**
             * Render lại các cột từ và nghĩa với dữ liệu mới từ server.
             */
            function renderNewPairs(wordsColumnData, meaningsColumnData) {
                console.log("renderNewPairs được gọi.");
                console.log("wordsColumnData nhận được:", wordsColumnData);
                console.log("meaningsColumnData nhận được:", meaningsColumnData);

                const $wordsColumn = $('#wordsColumn');
                const $meaningsColumn = $('#meaningsColumn');

                console.log("wordsColumn HTML trước khi empty:", $wordsColumn.html());
                console.log("meaningsColumn HTML trước khi empty:", $meaningsColumn.html());

                $wordsColumn.empty();
                $meaningsColumn.empty();

                console.log("wordsColumn HTML sau khi empty:", $wordsColumn.html());
                console.log("meaningsColumn HTML sau khi empty:", $meaningsColumn.html());


                // Thêm các phần tử mới vào cột từ
                wordsColumnData.forEach(vocab => {
                    console.log("Thêm word:", vocab.vocabId, vocab.word);
                    $wordsColumn.append(`
                        <div class="game-item" data-id="\${(vocab.vocabId === null || vocab.vocabId === 0) ? '' : vocab.vocabId}" data-type="word">
                            \${(vocab.word === null || vocab.word === '') ? 'Từ không xác định' : vocab.word}
                        </div>
                    `);
                });

                // Thêm các phần tử mới vào cột nghĩa
                meaningsColumnData.forEach(vocab => {
                    console.log("Thêm meaning:", vocab.vocabId, vocab.meaning);
                    $meaningsColumn.append(`
                        <div class="game-item" data-id="\${(vocab.vocabId === null || vocab.vocabId === 0) ? '' : vocab.vocabId}" data-type="meaning">
                            \${(vocab.meaning === null || vocab.meaning === '') ? 'Nghĩa không xác định' : vocab.meaning}
                        </div>
                    `);
                });

                console.log("wordsColumn HTML sau khi append:", $wordsColumn.html());
                console.log("meaningsColumn HTML sau khi append:", $meaningsColumn.html());

                attachClickHandlers();
                console.log("attachClickHandlers đã được gọi lại.");
            }

            /**
             * Gắn trình xử lý sự kiện click cho các game-item.
             * Được gọi ban đầu và sau mỗi lần render lại giao diện.
             */
            function attachClickHandlers() {
                // Hủy bỏ các trình xử lý cũ trước khi gắn lại để tránh gắn trùng lặp sự kiện
                $('.game-item').off('click').on('click', function() {
                    const currentItem = $(this);

                    // Nếu item đang trong quá trình xử lý (đã được chọn làm cặp hoặc đang có hiệu ứng)
                    if (currentItem.hasClass('matched')) {
                        return; // Không cho phép click
                    }

                    // Logic chọn item đầu tiên
                    if (selectedItem === null) {
                        selectedItem = currentItem;
                        selectedItem.addClass('selected');
                    } else {
                        // Nếu click lại chính item đã chọn, bỏ chọn
                        if (selectedItem[0] === currentItem[0]) {
                            selectedItem.removeClass('selected');
                            selectedItem = null;
                            return;
                        }

                        // Nếu click 2 item cùng loại (word-word hoặc meaning-meaning), bỏ chọn cái cũ, chọn cái mới
                        if (selectedItem.data('type') === currentItem.data('type')) {
                            selectedItem.removeClass('selected');
                            selectedItem = currentItem;
                            selectedItem.addClass('selected');
                            return;
                        }

                        // Đã chọn 2 item khác loại -> Tạo cặp thử và gửi yêu cầu AJAX để kiểm tra
                        const item1 = selectedItem;
                        const item2 = currentItem;

                        // Tắt tương tác cho tất cả các item trong khi xử lý cặp này
                        $('.game-item').addClass('matched');

                        const wordId = item1.data('type') === 'word' ? item1.data('id') : item2.data('id');
                        const meaningId = item1.data('type') === 'meaning' ? item1.data('id') : item2.data('id');

                        const attemptData = {
                            wordId: wordId,
                            meaningId: meaningId
                        };

                        // Gửi yêu cầu POST AJAX đến servlet
                        fetch('${pageContext.request.contextPath}/matching-game?action=matchAttempt', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(attemptData)
                        })
                        .then(response => {
                            // Kiểm tra phản hồi mạng có thành công không
                            if (!response.ok) {
                                // Nếu có lỗi HTTP (4xx, 5xx), ném lỗi để bắt ở .catch()
                                // Cố gắng đọc body phản hồi để lấy thông báo lỗi từ server
                                return response.json().then(errorData => {
                                    throw new Error(errorData.error || 'Network response was not ok: ' + response.statusText);
                                }).catch(() => {
                                    // Trường hợp server không trả về JSON hợp lệ trong lỗi
                                    throw new Error('Network response was not ok, and no valid error message received. Status: ' + response.status);
                                });
                            }
                            return response.json(); // Chuyển đổi phản hồi sang JSON
                        })
                        .then(data => {
                            if (data.isCorrect) {
                                // Nếu cặp đúng: thêm hiệu ứng đúng và tăng số cặp hoàn thành
                                item1.addClass('correct');
                                item2.addClass('correct');
                                completedPairs++; // Tăng số cặp hoàn thành trong frontend
                                updateGameInfoDisplay(); // Cập nhật hiển thị số cặp còn lại

                                setTimeout(() => {
                                    // Sau một khoảng thời gian ngắn để thấy hiệu ứng
                                    // Render lại toàn bộ bảng với dữ liệu mới từ server
                                    renderNewPairs(data.wordsColumn, data.meaningsColumn);
                                    
                                    selectedItem = null; // Đặt lại item đã chọn
                                    // Bỏ tất cả các class tạm thời (selected, matched, correct, incorrect) khỏi các item cũ/mới
                                    $('.game-item').removeClass('matched'); // Bật lại tương tác cho các item (mới)

                                    // Kiểm tra xem game đã kết thúc dựa trên thông tin từ server
                                    if (data.gameFinished) {
                                        checkGameCompletion();
                                    }
                                }, 500); // Hiệu ứng đúng nhanh hơn

                            } else {
                                // Nếu cặp sai: tăng số lần sai và thêm hiệu ứng sai
                                incorrectAttemptsCount++;
                                updateGameInfoDisplay(); // Cập nhật hiển thị số lần sai
                                item1.addClass('incorrect');
                                item2.addClass('incorrect');

                                setTimeout(() => {
                                    // Sau một khoảng thời gian để thấy hiệu ứng rung
                                    item1.removeClass('selected incorrect'); // Bỏ chọn và bỏ hiệu ứng sai
                                    item2.removeClass('selected incorrect'); // Bỏ chọn và bỏ hiệu ứng sai
                                    selectedItem = null; // Đặt lại item đã chọn
                                    $('.game-item').removeClass('matched'); // Bật lại tương tác
                                }, 800); // Hiệu ứng sai lâu hơn để người dùng nhận biết
                            }
                        })
                        .catch(error => {
                            // Xử lý lỗi trong quá trình fetch API
                            console.error('Error during match attempt:', error);
                            alert('Đã xảy ra lỗi khi xử lý cặp từ: ' + error.message + '. Vui lòng thử lại.');
                            // Đảm bảo giao diện trở lại trạng thái bình thường sau lỗi
                            // Loại bỏ các class lỗi và bật lại tương tác
                            item1.removeClass('selected matched correct incorrect');
                            item2.removeClass('selected matched correct incorrect');
                            selectedItem = null;
                            $('.game-item').removeClass('matched');
                        });
                    }
                });
            }

            // Initial attachment of click handlers when the page loads
            attachClickHandlers();

            /**
             * Kiểm tra xem game đã hoàn thành chưa.
             * Nếu hoàn thành, hiển thị modal kết thúc game.
             */
            function checkGameCompletion() {
                // Kiểm tra nếu số cặp đã hoàn thành bằng tổng số cặp của toàn bộ game
                if (completedPairs === totalGamePairs) {
                    $('#finalIncorrectAttempts').text(incorrectAttemptsCount); // Cập nhật số lần sai cuối cùng
                    $('#completionOverlay').addClass('show'); // Hiển thị modal

                    // Gửi tổng số lần sai lên form ẩn để servlet có thể nhận
                    $('#totalIncorrectAttemptsInput').val(incorrectAttemptsCount);

                    // Gắn trình xử lý cho nút "Xem Kết Quả Chi Tiết"
                    $('#viewResultBtn').off('click').on('click', function(e) {
                        e.preventDefault(); // Ngăn chặn hành vi mặc định của thẻ <a>
                        $('#gameForm').submit(); // Nộp form để chuyển hướng sang trang kết quả cuối cùng
                    });
                }
            }
        });
    </script>
</body>
</html>