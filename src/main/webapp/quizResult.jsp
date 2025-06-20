<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Trắc Nghiệm - English Learning</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #06b6d4;
            --light-bg: #f8fafc;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --hover-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #1f2937;
        }

        .main-container {
            background: var(--light-bg);
            min-height: 100vh;
            padding: 2rem 0;
        }

        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 2rem 2rem;
            position: relative;
            overflow: hidden;
        }

        .result-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }

        .result-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
            z-index: 2;
        }

        .result-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 2;
        }

        .score-card {
            background: white;
            border-radius: 2rem;
            padding: 3rem;
            box-shadow: var(--hover-shadow);
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .score-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(102, 126, 234, 0.1), transparent);
            animation: rotate 10s linear infinite;
        }

        @keyframes rotate {
            to { transform: rotate(360deg); }
        }

        .score-display {
            position: relative;
            z-index: 2;
        }

        .score-circle {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            position: relative;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .score-number {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
        }

        .score-percentage {
            font-size: 4rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .score-description {
            font-size: 1.2rem;
            color: #6b7280;
            margin-bottom: 2rem;
        }

        .performance-badge {
            padding: 0.75rem 1.5rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 1.1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
        }

        .badge-excellent {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .badge-good {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
            color: white;
        }

        .badge-average {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .badge-poor {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }

        .btn-modern {
            padding: 0.75rem 2rem;
            border-radius: 1rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-secondary-modern {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: white;
        }

        .btn-secondary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(107, 114, 128, 0.4);
            color: white;
        }

        .btn-info-modern {
            background: linear-gradient(135deg, var(--info-color), #0891b2);
            color: white;
        }

        .btn-info-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(6, 182, 212, 0.4);
            color: white;
        }

        .review-section {
            background: white;
            border-radius: 1.5rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-top: 2rem;
        }

        .review-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 2rem;
            border-bottom: 1px solid #e5e7eb;
            text-align: center;
        }

        .review-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .question-item {
            padding: 2rem;
            border-bottom: 1px solid #f3f4f6;
            transition: all 0.3s ease;
        }

        .question-item:last-child {
            border-bottom: none;
        }

        .question-item:hover {
            background: #f9fafb;
        }

        .question-number {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .question-text {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            line-height: 1.6;
        }

        .options-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .option-item {
            padding: 1rem 1.5rem;
            margin-bottom: 0.75rem;
            border-radius: 0.75rem;
            border-left: 4px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .option-text {
            flex: 1;
            font-size: 1rem;
            line-height: 1.5;
        }

        .option-correct {
            border-left-color: var(--success-color);
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #166534;
            font-weight: 600;
        }

        .option-correct::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--success-color);
            border-radius: 0 4px 4px 0;
        }

        .option-wrong {
            border-left-color: var(--danger-color);
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            text-decoration: line-through;
            opacity: 0.8;
        }

        .option-wrong::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--danger-color);
            border-radius: 0 4px 4px 0;
        }

        .option-neutral {
            background: #f9fafb;
            color: #6b7280;
            border-left-color: #d1d5db;
        }

        .user-choice-badge {
            background: #374151;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .option-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 0.75rem;
        }

        .icon-correct {
            background: var(--success-color);
            color: white;
        }

        .icon-wrong {
            background: var(--danger-color);
            color: white;
        }

        .icon-neutral {
            background: #d1d5db;
            color: #6b7280;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .result-title {
                font-size: 2rem;
            }

            .score-card {
                padding: 2rem 1rem;
            }

            .score-circle {
                width: 150px;
                height: 150px;
            }

            .score-number {
                font-size: 2rem;
            }

            .score-percentage {
                font-size: 3rem;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn-modern {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }

            .question-item {
                padding: 1.5rem;
            }

            .question-text {
                flex-direction: column;
                align-items: flex-start;
            }

            .question-number {
                margin-bottom: 0.5rem;
            }

            .option-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .user-choice-badge {
                align-self: flex-end;
            }
        }

        @media (max-width: 576px) {
            .main-container {
                padding: 1rem 0;
            }

            .result-header {
                padding: 2rem 0;
            }

            .review-header {
                padding: 1.5rem;
            }

            .question-item {
                padding: 1rem;
            }
        }

        /* Animation */
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

        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes countUp {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out;
        }

        .bounce-in {
            animation: bounceIn 0.8s ease-out;
        }

        .count-up {
            animation: countUp 0.5s ease-out;
        }

        .stagger-1 { animation-delay: 0.1s; }
        .stagger-2 { animation-delay: 0.2s; }
        .stagger-3 { animation-delay: 0.3s; }
        .stagger-4 { animation-delay: 0.4s; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>

    <div class="main-container">
        <!-- Result Header -->
        <div class="result-header">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 text-center">
                        <h1 class="result-title fade-in-up">
                            <i class="fas fa-trophy me-3"></i>
                            Kết Quả Bài Trắc Nghiệm
                        </h1>
                        <p class="result-subtitle fade-in-up stagger-1">
                            Chúc mừng bạn đã hoàn thành bài kiểm tra!
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Score Card -->
            <div class="score-card bounce-in stagger-2">
                <div class="score-display">
                    <!-- Calculate percentage -->
                    <c:set var="percentage" value="${(score / totalQuestions) * 100}" />
                    
                    <div class="score-percentage count-up">
                        <fmt:formatNumber value="${percentage}" maxFractionDigits="0" />%
                    </div>
                    
                    <div class="score-circle">
                        <div class="score-number">
                            <c:out value="${score}"/> / <c:out value="${totalQuestions}"/>
                        </div>
                    </div>

                    <p class="score-description">
                        Bạn đã trả lời đúng <strong><c:out value="${score}"/></strong> trên tổng số <strong><c:out value="${totalQuestions}"/></strong> câu hỏi.
                    </p>

                    <!-- Performance Badge -->
                    <c:choose>
                        <c:when test="${percentage >= 80}">
                            <div class="performance-badge badge-excellent">
                                <i class="fas fa-star"></i>
                                Xuất sắc! Bạn đã làm rất tốt!
                            </div>
                        </c:when>
                        <c:when test="${percentage >= 60}">
                            <div class="performance-badge badge-good">
                                <i class="fas fa-thumbs-up"></i>
                                Tốt! Tiếp tục phát huy nhé!
                            </div>
                        </c:when>
                        <c:when test="${percentage >= 40}">
                            <div class="performance-badge badge-average">
                                <i class="fas fa-chart-line"></i>
                                Khá ổn! Hãy cố gắng hơn nữa!
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="performance-badge badge-poor">
                                <i class="fas fa-redo"></i>
                                Cần cải thiện! Đừng nản lòng nhé!
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/take-quiz?lessonId=${lessonId}" 
                           class="btn-modern btn-primary-modern">
                            <i class="fas fa-redo"></i>
                            Làm lại bài này
                        </a>
                        <a href="${pageContext.request.contextPath}/lesson-detail?lessonId=${lessonId}" 
                           class="btn-modern btn-secondary-modern">
                            <i class="fas fa-book-open"></i>
                            Quay lại bài học
                        </a>
                        <a href="${pageContext.request.contextPath}/lessons" 
                           class="btn-modern btn-info-modern">
                            <i class="fas fa-list"></i>
                            Xem các bài học khác
                        </a>
                    </div>
                </div>
            </div>

            <!-- Review Section -->
            <div class="review-section fade-in-up stagger-3">
                <div class="review-header">
                    <h3 class="review-title">
                        <i class="fas fa-clipboard-list"></i>
                        Xem Lại Bài Làm Chi Tiết
                    </h3>
                </div>
                
                <c:forEach var="result" items="${detailedResults}" varStatus="loop">
                    <div class="question-item fade-in-up stagger-${(loop.index % 4) + 1}">
                        <div class="question-text">
                            <span class="question-number">${loop.count}</span>
                            <span><c:out value="${result.question.questionText}"/></span>
                        </div>
                        
                        <ul class="options-list">
                            <c:forEach var="option" items="${result.question.options}">
                                <c:set var="optionClass" value="option-neutral"/>
                                <c:set var="iconClass" value="icon-neutral"/>
                                <c:set var="iconSymbol" value="○"/>
                                
                                <c:if test="${option.isCorrect}">
                                    <c:set var="optionClass" value="option-correct"/>
                                    <c:set var="iconClass" value="icon-correct"/>
                                    <c:set var="iconSymbol" value="✓"/>
                                </c:if>
                                
                                <c:if test="${option.optionId == result.selectedOptionId && !option.isCorrect}">
                                    <c:set var="optionClass" value="option-wrong"/>
                                    <c:set var="iconClass" value="icon-wrong"/>
                                    <c:set var="iconSymbol" value="✗"/>
                                </c:if>

                                <li class="option-item ${optionClass}">
                                    <div style="display: flex; align-items: center; flex: 1;">
                                        <div class="option-icon ${iconClass}">
                                            ${iconSymbol}
                                        </div>
                                        <span class="option-text">
                                            <c:out value="${option.optionText}"/>
                                        </span>
                                    </div>
                                    
                                    <c:if test="${option.optionId == result.selectedOptionId}">
                                        <span class="user-choice-badge">
                                            <i class="fas fa-user"></i>
                                            Lựa chọn của bạn
                                        </span>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate score counting
            const scorePercentage = document.querySelector('.score-percentage');
            if (scorePercentage) {
                const finalScore = parseInt(scorePercentage.textContent);
                let currentScore = 0;
                const increment = finalScore / 50;
                
                const timer = setInterval(() => {
                    currentScore += increment;
                    if (currentScore >= finalScore) {
                        scorePercentage.textContent = finalScore + '%';
                        clearInterval(timer);
                    } else {
                        scorePercentage.textContent = Math.floor(currentScore) + '%';
                    }
                }, 30);
            }

            // Add click effects to buttons
            const buttons = document.querySelectorAll('.btn-modern');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // Create ripple effect
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.classList.add('ripple-effect');
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });

            // Add hover effects to question items
            const questionItems = document.querySelectorAll('.question-item');
            questionItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });

            // Celebrate if score is excellent
            const percentage = ${percentage};
            if (percentage >= 80) {
                // Add confetti or celebration effect
                setTimeout(() => {
                    createConfetti();
                }, 1000);
            }
        });

        function createConfetti() {
            const colors = ['#667eea', '#764ba2', '#10b981', '#f59e0b'];
            const confettiCount = 50;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.borderRadius = '50%';
                confetti.style.pointerEvents = 'none';
                confetti.style.zIndex = '9999';
                
                document.body.appendChild(confetti);
                
                const animation = confetti.animate([
                    { transform: 'translateY(0) rotate(0deg)', opacity: 1 },
                    { transform: `translateY(100vh) rotate(${Math.random() * 360}deg)`, opacity: 0 }
                ], {
                    duration: Math.random() * 2000 + 1000,
                    easing: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)'
                });
                
                animation.onfinish = () => confetti.remove();
            }
        }
    </style>

    <style>
        .ripple-effect {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    </style>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>