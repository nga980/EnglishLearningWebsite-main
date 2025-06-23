<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Admin Dashboard - English Learning</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-style.css">
    
    <style>
        .admin-main-content {
            background-color: #f4f7f6;
        }
        .stat-card {
            background-color: #fff;
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease-in-out;
            margin-bottom: 20px;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
        }
        .stat-card .card-body {
            padding: 25px;
            position: relative;
            z-index: 2;
        }
        .stat-card .stat-icon {
            position: absolute;
            top: 50%;
            right: 25px;
            transform: translateY(-50%);
            font-size: 4rem;
            color: rgba(0, 0, 0, 0.07);
            transition: all 0.4s ease;
        }
        .stat-card:hover .stat-icon {
            transform: translateY(-50%) scale(1.1);
            color: rgba(0, 0, 0, 0.1);
        }
        .stat-card .card-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .stat-card .card-text {
            font-size: 1rem;
            font-weight: 500;
            color: #6c757d;
        }
        .stat-card.lessons .card-title { color: #007bff; }
        .stat-card.vocabulary .card-title { color: #28a745; }
        .stat-card.users .card-title { color: #17a2b8; }
        .stat-card.grammar .card-title { color: #6f42c1; }

        .chart-container {
            background-color: #fff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
            margin-top: 20px;
            height: 400px; /* Cố định chiều cao cho biểu đồ */
        }
        .chart-container h5 {
            font-weight: 600;
            color: #343a40;
            margin-bottom: 20px;
        }
        @media (max-width: 991px) {
             .chart-container {
                margin-top: 30px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="_adminLayout.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <div class="container-fluid">
        <div class="row">
            <main role="main" class="col-md-10 ml-sm-auto admin-main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Dashboard</h1>
                </div>
                
                <div class="row">
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card lessons">
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalLessons}"/></h5>
                                <p class="card-text">Bài Học</p>
                            </div>
                            <i class="fas fa-chalkboard-teacher stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card vocabulary">
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalVocabulary}"/></h5>
                                <p class="card-text">Từ Vựng</p>
                            </div>
                             <i class="fas fa-book-open stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card users">
                             <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalUsers}"/></h5>
                                <p class="card-text">Người Dùng</p>
                            </div>
                             <i class="fas fa-users stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card grammar">
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${totalGrammarTopics}"/></h5>
                                <p class="card-text">Chủ Đề Ngữ Pháp</p>
                            </div>
                             <i class="fas fa-spell-check stat-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-7">
                        <div class="chart-container">
                            <h5><i class="fas fa-chart-line mr-2"></i>Thống Kê Tăng Trưởng (6 Tháng Gần Nhất)</h5>
                            <canvas id="monthlyGrowthChart"></canvas>
                        </div>
                    </div>
                     <div class="col-lg-5">
                        <div class="chart-container">
                             <h5><i class="fas fa-chart-pie mr-2"></i>Phân Bố Nội Dung</h5>
                             <canvas id="contentDistributionChart"></canvas>
                        </div>
                    </div>
                </div>
                
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    
    <script>
        feather.replace();

        $(document).ready(function() {
            // --- Biểu đồ 1: Phân bố nội dung (Doughnut Chart) ---
            const ctxDoughnut = document.getElementById('contentDistributionChart');
            if (ctxDoughnut) {
                new Chart(ctxDoughnut, {
                    type: 'doughnut',
                    data: {
                        labels: ['Bài Học', 'Từ Vựng', 'Ngữ Pháp'],
                        datasets: [{
                            label: 'Số lượng',
                            data: [
                                <c:out value="${totalLessons > 0 ? totalLessons : 0}"/>, 
                                <c:out value="${totalVocabulary > 0 ? totalVocabulary : 0}"/>, 
                                <c:out value="${totalGrammarTopics > 0 ? totalGrammarTopics : 0}"/>
                            ],
                            backgroundColor: ['#007bff', '#28a745', '#6f42c1'],
                            hoverOffset: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });
            }

            // --- Biểu đồ 2: Tăng trưởng theo tháng (Line Chart) ---
            const ctxLine = document.getElementById('monthlyGrowthChart');
            if(ctxLine) {
                // ***** DỮ LIỆU MẪU - BẠN SẼ CẦN THAY THẾ BẰNG DỮ LIỆU THẬT TỪ SERVLET *****
                const monthLabels = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'];
                const newUsersData = [5, 10, 8, 15, 12, 20];
                const newLessonsData = [2, 3, 2, 5, 4, 6];
                // **************************************************************************

                new Chart(ctxLine, {
                    type: 'line',
                    data: {
                        labels: monthLabels,
                        datasets: [
                        {
                            label: 'Người dùng mới',
                            data: newUsersData,
                            borderColor: '#17a2b8',
                            backgroundColor: 'rgba(23, 162, 184, 0.1)',
                            fill: true,
                            tension: 0.4 // Làm cho đường cong mượt hơn
                        },
                        {
                            label: 'Bài học mới',
                            data: newLessonsData,
                            borderColor: '#007bff',
                            backgroundColor: 'rgba(0, 123, 255, 0.1)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    precision: 0
                                }
                            }
                        },
                        plugins: {
                            legend: { position: 'top' }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>