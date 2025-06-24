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
import model.QuizResultDetail;

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
                resultDetail.setQuestion(question);

                String selectedOptionIdStr = request.getParameter("question_" + question.getQuestionId());
                boolean isAnswerCorrect = false;
                int selectedOptionId = -1;

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
                
                // Logic lưu lại lần làm bài không thay đổi
                if (selectedOptionId != -1) {
                    UserQuizAttempt attempt = new UserQuizAttempt();
                    attempt.setUserId(loggedInUser.getUserId());
                    attempt.setQuizQuestionId(question.getQuestionId());
                    attempt.setSelectedOptionId(selectedOptionId);
                    attempt.setIsAnswerCorrect(isAnswerCorrect);
                    quizDAO.saveUserAttempt(attempt);
                }
                
                detailedResults.add(resultDetail);
            }

            request.setAttribute("score", score);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("grammarTopicId", grammarTopicId); // Gửi grammarTopicId sang trang kết quả
            request.setAttribute("detailedResults", detailedResults);

            request.getRequestDispatcher("/grammarExerciseResult.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/grammar");
        }
    }
}