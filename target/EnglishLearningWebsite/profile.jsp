<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- SỬA LỖI 1: Sử dụng URI JSTL chính xác và tương thích --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Của Tôi</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <jsp:include page="/common/header.jsp"/>

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --border-color: #e5e7eb;
            --bg-light: #f8fafc;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -1px rgb(0 0 0 / 0.06);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -2px rgb(0 0 0 / 0.05);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 10px 10px -5px rgb(0 0 0 / 0.04);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .main-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            box-shadow: var(--shadow-xl);
            margin: 2rem auto;
            overflow: hidden;
            max-width: 900px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 50%, var(--accent-color) 100%);
            color: white;
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.1"><circle cx="30" cy="30" r="4"/></g></svg>');
            opacity: 0.3;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.25) 0%, rgba(255, 255, 255, 0.1) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 3rem;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .profile-avatar:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        .profile-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
        }

        .profile-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }

        .content-section {
            padding: 2.5rem 2rem;
            background: var(--bg-light);
        }

        .info-card {
            background: white;
            border-radius: 20px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color) 0%, var(--accent-color) 100%);
        }

        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .card-title {
            font-weight: 600;
            font-size: 1.4rem;
            margin-bottom: 2rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }

        .card-title i {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-right: 0.75rem;
            font-size: 1.2em;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
            transition: all 0.2s ease;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-item:hover {
            background: rgba(102, 126, 234, 0.02);
            margin: 0 -1rem;
            padding: 1rem;
            border-radius: 12px;
        }

        .info-label {
            font-weight: 500;
            color: var(--text-secondary);
            min-width: 140px;
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }

        .info-label i {
            margin-right: 0.5rem;
            color: var(--primary-color);
            width: 16px;
        }

        .info-value {
            font-weight: 600;
            color: var(--text-primary);
            flex: 1;
        }

        .role-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 0.375rem 0.875rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: var(--shadow-sm);
        }

        .form-group {
            margin-bottom: 1.75rem;
        }

        .form-group label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .form-group label i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 0.875rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            border: none;
            border-radius: 12px;
            padding: 0.875rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .alert {
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            border: none;
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(16, 185, 129, 0.05) 100%);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(239, 68, 68, 0.05) 100%);
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        .alert i {
            font-size: 1.2em;
            margin-right: 0.75rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                border-radius: 16px;
            }

            .profile-header {
                padding: 2rem 1rem;
            }

            .profile-title {
                font-size: 2rem;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
            }

            .content-section {
                padding: 1.5rem 1rem;
            }

            .info-card {
                padding: 1.5rem;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .info-label {
                min-width: auto;
            }
        }

        /* Animation cho page load */
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

        .info-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .info-card:nth-child(2) {
            animation-delay: 0.1s;
        }

        .info-card:nth-child(3) {
            animation-delay: 0.2s;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h1 class="profile-title"><c:out value="${sessionScope.loggedInUser.fullName}"/></h1>
                <p class="profile-subtitle">Chào mừng đến với hồ sơ cá nhân của bạn</p>
            </div>

            <div class="content-section">
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle"></i>
                        <c:out value="${sessionScope.successMessage}"/>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:out value="${requestScope.errorMessage}"/>
                    </div>
                </c:if>

                <div class="info-card">
                    <h5 class="card-title">
                        <i class="fas fa-id-card"></i>
                        Thông Tin Tài Khoản
                    </h5>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user"></i> 
                            Tên đăng nhập:
                        </div>
                        <div class="info-value">
                            <c:out value="${sessionScope.loggedInUser.username}"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-id-badge"></i> 
                            Họ và tên:
                        </div>
                        <div class="info-value">
                            <c:out value="${sessionScope.loggedInUser.fullName}"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-envelope"></i> 
                            Email:
                        </div>
                        <div class="info-value">
                            <c:out value="${sessionScope.loggedInUser.email}"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-shield-alt"></i> 
                            Vai trò:
                        </div>
                        <div class="info-value">
                            <span class="role-badge">
                                <c:out value="${sessionScope.loggedInUser.role}"/>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <h5 class="card-title">
                        <i class="fas fa-key"></i>
                        Đổi Mật Khẩu
                    </h5>
                    <form method="POST" action="${pageContext.request.contextPath}/change-password" id="changePasswordForm">
                        <div class="form-group">
                            <label for="currentPassword">
                                <i class="fas fa-lock"></i>
                                Mật khẩu hiện tại
                            </label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">
                                <i class="fas fa-key"></i>
                                Mật khẩu mới
                            </label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Ít nhất 8 ký tự" required minlength="8">
                        </div>
                        <div class="form-group">
                            <label for="confirmNewPassword">
                                <i class="fas fa-check-double"></i>
                                Xác nhận mật khẩu mới
                            </label>
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-save mr-2"></i>
                            Lưu Thay Đổi
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp" />

    <%-- SỬA LỖI 3: Sử dụng các CDN chính xác cho jQuery, Popper.js và Bootstrap 4.5.2 JS --%>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>