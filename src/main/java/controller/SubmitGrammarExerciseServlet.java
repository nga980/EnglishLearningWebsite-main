package controller;

import dao.QuizDAO;
import model.QuizOption;
import model.QuizQuestion;
import model.User;
import model.UserQuizAttempt;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizResultDetail; // Đã thêm import QuizResultDetail

@WebServlet(name = "SubmitGrammarExerciseServlet", urlPatterns = {"/submit-grammar-exercise"})
public class SubmitGrammarExerciseServlet extends HttpServlet {
    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String grammarTopicIdStr = request.getParameter("grammarTopicId");
        if (grammarTopicIdStr == null) {
            // Nếu không có grammarTopicId, chuyển hướng về trang danh sách ngữ pháp
            response.sendRedirect(request.getContextPath() + "/grammar");
            return;
        }

        try {
            int grammarTopicId = Integer.parseInt(grammarTopicIdStr);
            List<QuizQuestion> correctQuestions = quizDAO.getQuestionsByGrammarTopicId(grammarTopicId);

            int score = 0;
            int totalQuestions = correctQuestions.size();
            List<QuizResultDetail> detailedResults = new ArrayList<>();

            for (QuizQuestion question : correctQuestions) {
                QuizResultDetail resultDetail = new QuizResultDetail();
                resultDetail.setQuestion(question); // Đặt đối tượng câu hỏi gốc vào chi tiết kết quả

                // Lấy lựa chọn của người dùng cho câu hỏi này
                String selectedOptionIdStr = request.getParameter("question_" + question.getQuestionId());
                boolean isAnswerCorrect = false;
                int selectedOptionId = -1; // Mặc định là không trả lời hoặc trả lời không hợp lệ

                if (selectedOptionIdStr != null) {
                    try {
                        selectedOptionId = Integer.parseInt(selectedOptionIdStr);
                        resultDetail.setSelectedOptionId(selectedOptionId); // Đặt ID lựa chọn của người dùng
                        
                        // Kiểm tra xem lựa chọn của người dùng có đúng không
                        for (QuizOption option : question.getOptions()) {
                            if (option.isIsCorrect() && option.getOptionId() == selectedOptionId) {
                                score++;
                                isAnswerCorrect = true;
                                break;
                            }
                        }
                        resultDetail.setWasCorrect(isAnswerCorrect); // Đặt kết quả đúng/sai
                    } catch (NumberFormatException e) {
                        // Xử lý trường hợp selectedOptionIdStr không phải là số (coi như không trả lời đúng)
                        resultDetail.setSelectedOptionId(-1);
                        resultDetail.setWasCorrect(false);
                        // Log lỗi nếu cần thiết
                    }
                } else {
                    // Người dùng không chọn đáp án nào cho câu hỏi này
                    resultDetail.setSelectedOptionId(-1);
                    resultDetail.setWasCorrect(false);
                }
                
                // Lưu lại lần làm bài của người dùng vào lịch sử (nếu có đáp án được chọn hợp lệ)
                if (selectedOptionId != -1) {
                    UserQuizAttempt attempt = new UserQuizAttempt();
                    attempt.setUserId(loggedInUser.getUserId());
                    attempt.setQuizQuestionId(question.getQuestionId());
                    attempt.setSelectedOptionId(selectedOptionId);
                    attempt.setIsAnswerCorrect(isAnswerCorrect);
                    quizDAO.saveUserAttempt(attempt);
                }
                
                detailedResults.add(resultDetail); // Thêm chi tiết kết quả vào danh sách
            }

            // Đặt các thuộc tính vào request để truyền sang trang JSP
            request.setAttribute("score", score);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("grammarTopicId", grammarTopicId); // Truyền lại grammarTopicId để các nút action có thể sử dụng
            request.setAttribute("detailedResults", detailedResults);

            // Chuyển tiếp đến trang kết quả
            request.getRequestDispatcher("/grammarExerciseResult.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu grammarTopicId không hợp lệ, chuyển hướng về trang danh sách ngữ pháp
            response.sendRedirect(request.getContextPath() + "/grammar");
        } catch (Exception e) {
            // Bắt các lỗi khác có thể xảy ra (ví dụ: lỗi DAO)
            e.printStackTrace(); // In stack trace để gỡ lỗi
            // Có thể đặt một thông báo lỗi vào session hoặc request rồi chuyển hướng
            response.sendRedirect(request.getContextPath() + "/grammar?error=Lỗi hệ thống khi xử lý bài tập.");
        }
    }
}