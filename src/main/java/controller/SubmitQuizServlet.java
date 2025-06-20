package controller;

import dao.QuizDAO;
import model.QuizOption;
import model.QuizQuestion;
import model.User;
import model.UserQuizAttempt; // THÊM IMPORT NÀY
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizResultDetail;

@WebServlet(name = "SubmitQuizServlet", urlPatterns = {"/submit-quiz"})
public class SubmitQuizServlet extends HttpServlet {
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

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/lessons");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdStr);
            List<QuizQuestion> correctQuestions = quizDAO.getQuestionsByLessonId(lessonId);

            int score = 0;
            int totalQuestions = correctQuestions.size();
            List<QuizResultDetail> detailedResults = new ArrayList<>();

            for (QuizQuestion question : correctQuestions) {
                QuizResultDetail resultDetail = new QuizResultDetail();
                resultDetail.setQuestion(question);

                String selectedOptionIdStr = request.getParameter("question_" + question.getQuestionId());
                boolean isAnswerCorrect = false;
                int selectedOptionId = -1; // -1 nếu không trả lời

                if (selectedOptionIdStr != null) {
                    selectedOptionId = Integer.parseInt(selectedOptionIdStr);
                    resultDetail.setSelectedOptionId(selectedOptionId);
                    
                    for (QuizOption option : question.getOptions()) {
                        if (option.isIsCorrect() && option.getOptionId() == selectedOptionId) {
                            score++;
                            isAnswerCorrect = true;
                            break;
                        }
                    }
                    resultDetail.setWasCorrect(isAnswerCorrect);
                } else {
                    resultDetail.setSelectedOptionId(-1);
                    resultDetail.setWasCorrect(false);
                }
                
                // === PHẦN QUAN TRỌNG: LƯU LẠI KẾT QUẢ ===
                if (selectedOptionId != -1) { // Chỉ lưu nếu người dùng có trả lời
                    UserQuizAttempt attempt = new UserQuizAttempt(
                        loggedInUser.getUserId(), 
                        question.getQuestionId(), 
                        selectedOptionId, 
                        isAnswerCorrect
                    );
                    quizDAO.saveUserAttempt(attempt); // Gọi DAO để lưu
                }
                // ===========================================
                
                detailedResults.add(resultDetail);
            }

            request.setAttribute("score", score);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("lessonId", lessonId);
            request.setAttribute("detailedResults", detailedResults);

            request.getRequestDispatcher("quizResult.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lessons");
        }
    }
}