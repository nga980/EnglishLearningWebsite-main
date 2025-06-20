package controller;

import dao.QuizDAO;
import model.QuizOption;
import model.QuizQuestion;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateQuizQuestionServlet", urlPatterns = {"/admin/update-quiz-question"})
public class UpdateQuizQuestionServlet extends HttpServlet {
    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy các tham số từ form
        String questionIdStr = request.getParameter("questionId");
        String lessonIdStr = request.getParameter("lessonId");
        String questionText = request.getParameter("questionText");
        String[] optionIds = request.getParameterValues("optionId");
        String[] optionTexts = request.getParameterValues("optionText");
        String correctOptionIndexStr = request.getParameter("correctOptionIndex");

        // URL để redirect lại đúng trang quản lý quiz
        String redirectURL = request.getContextPath() + "/admin/manage-quiz?lessonId=" + lessonIdStr;

        try {
            int questionId = Integer.parseInt(questionIdStr);
            int lessonId = Integer.parseInt(lessonIdStr);
            int correctOptionIndex = Integer.parseInt(correctOptionIndexStr);

            // --- Validation ---
            if (questionText == null || questionText.trim().isEmpty()) {
                session.setAttribute("errorMessage_quiz", "Nội dung câu hỏi không được để trống.");
                response.sendRedirect(redirectURL); // Redirect để tránh lỗi lặp lại form
                return;
            }

            // Tạo đối tượng câu hỏi
            QuizQuestion questionToUpdate = new QuizQuestion(questionId, lessonId, questionText);
            List<QuizOption> optionsToUpdate = new ArrayList<>();

            // Tạo danh sách các lựa chọn đã cập nhật
            for (int i = 0; i < optionIds.length; i++) {
                int optionId = Integer.parseInt(optionIds[i]);
                String optionText = optionTexts[i];

                if (optionText == null || optionText.trim().isEmpty()) {
                     session.setAttribute("errorMessage_quiz", "Nội dung các lựa chọn không được để trống.");
                     response.sendRedirect(request.getContextPath() + "/admin/edit-quiz-question-form?questionId=" + questionId);
                     return;
                }

                QuizOption option = new QuizOption();
                option.setOptionId(optionId);
                option.setOptionText(optionText);
                option.setIsCorrect(i == correctOptionIndex); // Đánh dấu đáp án đúng
                optionsToUpdate.add(option);
            }
            questionToUpdate.setOptions(optionsToUpdate);

            // Gọi DAO để thực hiện cập nhật
            boolean success = quizDAO.updateQuestionWithOptions(questionToUpdate);

            if (success) {
                session.setAttribute("successMessage_quiz", "Cập nhật câu hỏi ID " + questionId + " thành công!");
            } else {
                session.setAttribute("errorMessage_quiz", "Cập nhật câu hỏi ID " + questionId + " thất bại.");
            }
            response.sendRedirect(redirectURL);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_quiz", "Dữ liệu ID không hợp lệ.");
            response.sendRedirect(redirectURL);

        }
    }
}