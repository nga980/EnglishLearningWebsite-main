<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Làm Bài Trắc Nghiệm: <c:out value="${lesson.title}"/></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .quiz-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .quiz-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: repeating-linear-gradient(
                45deg,
                transparent,
                transparent 10px,
                rgba(255,255,255,0.05) 10px,
                rgba(255,255,255,0.05) 20px
            );
            animation: slide 20s linear infinite;
        }
        
        @keyframes slide {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }
        
        .quiz-header h2 {
            position: relative;
            z-index: 2;
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .quiz-header .icon {
            position: relative;
            z-index: 2;
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }
        
        .quiz-question {
            background: white;
            border: 2px solid #e9ecef;
            padding: 25px;
            margin-bottom: 25px;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .quiz-question:hover {
            border-color: #667eea;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.15);
            transform: translateY(-2px);
        }
        
        .quiz-question::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(45deg, #667eea, #764ba2);
            transition: width 0.3s ease;
        }
        
        .quiz-question:hover::before {
            width: 6px;
        }
        
        .question-number {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            text-align: center;
            line-height: 35px;
            font-weight: bold;
            margin-right: 15px;
            box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
        }
        
        .question-text {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .form-check {
            margin: 12px 0;
            padding-left: 0;
        }
        
        .custom-radio {
            position: relative;
            padding-left: 35px;
            cursor: pointer;
            font-size: 1.1rem;
            line-height: 1.5;
            color: #495057;
            transition: all 0.2s ease;
        }
        
        .custom-radio:hover {
            color: #667eea;
            padding-left: 40px;
        }
        
        .custom-radio input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        
        .custom-radio .checkmark {
            position: absolute;
            top: 3px;
            left: 0;
            height: 20px;
            width: 20px;
            background-color: #fff;
            border: 2px solid #ddd;
            border-radius: 50%;
            transition: all 0.3s ease;
        }
        
        .custom-radio:hover input ~ .checkmark {
            border-color: #667eea;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.3);
        }
        
        .custom-radio input:checked ~ .checkmark {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-color: #667eea;
            box-shadow: 0 0 15px rgba(102, 126, 234, 0.5);
        }
        
        .custom-radio .checkmark:after {
            content: "";
            position: absolute;
            display: none;
        }
        
        .custom-radio input:checked ~ .checkmark:after {
            display: block;
        }
        
        .custom-radio .checkmark:after {
            top: 3px;
            left: 3px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: white;
        }
        
        .submit-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            margin-top: 30px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(102, 126, 234, 0.6);
            color: white;
        }
        
        .btn-submit:active {
            transform: translateY(-1px);
        }
        
        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-submit:hover::before {
            left: 100%;
        }
        
        .progress-bar-custom {
            background: #e9ecef;
            height: 6px;
            border-radius: 3px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 3px;
            transition: width 0.3s ease;
        }
        
        .question-counter {
            text-align: center;
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
        
        @media (max-width: 768px) {
            .quiz-container {
                padding: 20px;
                margin: 10px;
            }
            
            .quiz-header {
                padding: 20px;
            }
            
            .quiz-header h2 {
                font-size: 1.5rem;
            }
            
            .quiz-question {
                padding: 20px;
            }
            
            .question-text {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="activePage" value="lessons"/>
    </jsp:include>
    
    <div class="container mt-4">
        <div class="quiz-header">
            <div class="icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <h2>Bài Trắc Nghiệm: <c:out value="${lesson.title}"/></h2>
        </div>
        
        <div class="quiz-container">
            <div class="question-counter">
                <span id="current-question">0</span> / <span id="total-questions">${questionList.size()}</span> câu hỏi
            </div>
            
            <div class="progress-bar-custom">
                <div class="progress-fill" id="progress-fill" style="width: 0%"></div>
            </div>
            
            <form method="POST" action="${pageContext.request.contextPath}/submit-quiz" id="quiz-form">
                <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                
                <c:forEach var="question" items="${questionList}" varStatus="loop">
                    <div class="quiz-question" data-question="${loop.count}">
                        <div class="question-text">
                            <span class="question-number">${loop.count}</span>
                            <c:out value="${question.questionText}"/>
                        </div>
                        
                        <c:forEach var="option" items="${question.options}">
                            <div class="form-check">
                                <label class="custom-radio">
                                    <c:out value="${option.optionText}"/>
                                    <input type="radio" 
                                           name="question_${question.questionId}" 
                                           value="${option.optionId}" 
                                           required>
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </form>
        </div>
        
        <div class="submit-section">
            <p class="mb-3">
                <i class="fas fa-info-circle text-info"></i>
                Hãy kiểm tra lại câu trả lời trước khi nộp bài
            </p>
            <button type="submit" form="quiz-form" class="btn btn-submit">
                <i class="fas fa-paper-plane mr-2"></i>
                Nộp Bài
            </button>
        </div>
    </div>
    
    <jsp:include page="/common/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        $(document).ready(function() {
            const totalQuestions = ${questionList.size()};
            let answeredQuestions = 0;
            
            // Cập nhật progress bar
            function updateProgress() {
                const progress = (answeredQuestions / totalQuestions) * 100;
                $('#progress-fill').css('width', progress + '%');
                $('#current-question').text(answeredQuestions);
            }
            
            // Lắng nghe sự kiện chọn đáp án
            $('input[type="radio"]').on('change', function() {
                const questionDiv = $(this).closest('.quiz-question');
                const questionNumber = questionDiv.data('question');
                
                // Đánh dấu câu hỏi đã được trả lời
                if (!questionDiv.hasClass('answered')) {
                    questionDiv.addClass('answered');
                    answeredQuestions++;
                    updateProgress();
                }
                
                // Hiệu ứng khi chọn đáp án
                $(this).closest('.custom-radio').addClass('selected');
                $(this).closest('.form-check').siblings().find('.custom-radio').removeClass('selected');
            });
            
            // Hiệu ứng scroll mượt khi nhấn số câu hỏi
            $('.question-number').on('click', function() {
                const questionDiv = $(this).closest('.quiz-question');
                $('html, body').animate({
                    scrollTop: questionDiv.offset().top - 100
                }, 500);
            });
            
            // Xác nhận trước khi submit
            $('#quiz-form').on('submit', function(e) {
                if (answeredQuestions < totalQuestions) {
                    e.preventDefault();
                    
                    const unanswered = totalQuestions - answeredQuestions;
                    const message = `Bạn còn ${unanswered} câu hỏi chưa trả lời. Bạn có chắc chắn muốn nộp bài?`;
                    
                    if (confirm(message)) {
                        this.submit();
                    }
                } else {
                    if (!confirm('Bạn có chắc chắn muốn nộp bài?')) {
                        e.preventDefault();
                    }
                }
            });
            
            // Hiệu ứng hover cho các câu hỏi
            $('.quiz-question').hover(
                function() {
                    $(this).find('.question-number').css('transform', 'scale(1.1)');
                },
                function() {
                    $(this).find('.question-number').css('transform', 'scale(1)');
                }
            );
            
            // Auto-save (optional - lưu tạm thời trong localStorage)
            $('input[type="radio"]').on('change', function() {
                const formData = $('#quiz-form').serialize();
                localStorage.setItem('quiz_progress_' + ${lesson.lessonId}, formData);
            });
            
            // Khôi phục dữ liệu đã lưu (nếu có)
            const savedData = localStorage.getItem('quiz_progress_' + ${lesson.lessonId});
            if (savedData) {
                const params = new URLSearchParams(savedData);
                params.forEach((value, key) => {
                    if (key.startsWith('question_')) {
                        $(`input[name="${key}"][value="${value}"]`).prop('checked', true).trigger('change');
                    }
                });
            }
            
            // Xóa dữ liệu lưu tạm khi nộp bài thành công
            $('#quiz-form').on('submit', function() {
                localStorage.removeItem('quiz_progress_' + ${lesson.lessonId});
            });
        });
    </script>
</body>
</html>