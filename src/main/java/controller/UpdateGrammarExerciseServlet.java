package controller;

import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizOption;
import model.QuizQuestion;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet này xử lý việc cập nhật một câu hỏi bài tập ngữ pháp đã có.
 */
@WebServlet(name = "UpdateGrammarExerciseServlet", urlPatterns = {"/admin/update-grammar-exercise"})
public class UpdateGrammarExerciseServlet extends HttpServlet {
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
        String grammarTopicIdStr = request.getParameter("grammarTopicId"); // Cần cho việc redirect
        String questionText = request.getParameter("questionText");
        String[] optionIds = request.getParameterValues("optionId");
        String[] optionTexts = request.getParameterValues("optionText");
        String correctOptionIdStr = request.getParameter("correctOption"); // Lấy ID của đáp án đúng

        // URL để redirect lại đúng trang quản lý bài tập
        String redirectURL = request.getContextPath() + "/admin/manage-grammar-exercises?grammarTopicId=" + grammarTopicIdStr;

        try {
            int questionId = Integer.parseInt(questionIdStr);
            int correctOptionId = Integer.parseInt(correctOptionIdStr);

            // Validation
            if (questionText == null || questionText.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Nội dung câu hỏi không được để trống.");
                response.sendRedirect(redirectURL);
                return;
            }

            // Tạo đối tượng câu hỏi để cập nhật
            QuizQuestion questionToUpdate = new QuizQuestion();
            questionToUpdate.setQuestionId(questionId);
            questionToUpdate.setQuestionText(questionText);

            List<QuizOption> optionsToUpdate = new ArrayList<>();
            for (int i = 0; i < optionIds.length; i++) {
                int optionId = Integer.parseInt(optionIds[i]);
                String optionText = optionTexts[i];

                if (optionText == null || optionText.trim().isEmpty()) {
                     session.setAttribute("errorMessage", "Nội dung các lựa chọn không được để trống.");
                     // Redirect về trang edit để người dùng sửa
                     response.sendRedirect(request.getContextPath() + "/admin/edit-grammar-exercise-form?questionId=" + questionId + "&grammarTopicId=" + grammarTopicIdStr);
                     return;
                }

                QuizOption option = new QuizOption();
                option.setOptionId(optionId);
                option.setOptionText(optionText);
                option.setIsCorrect(optionId == correctOptionId); // So sánh ID để xác định đáp án đúng
                optionsToUpdate.add(option);
            }
            questionToUpdate.setOptions(optionsToUpdate);

            // Gọi DAO để thực hiện cập nhật
            boolean success = quizDAO.updateQuestionWithOptions(questionToUpdate);

            if (success) {
                session.setAttribute("successMessage", "Cập nhật bài tập ID " + questionId + " thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật bài tập ID " + questionId + " thất bại.");
            }
            response.sendRedirect(redirectURL);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu ID không hợp lệ.");
            response.sendRedirect(redirectURL);
        }
    }
}