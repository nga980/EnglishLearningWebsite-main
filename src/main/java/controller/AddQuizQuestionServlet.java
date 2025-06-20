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

@WebServlet(name = "AddQuizQuestionServlet", urlPatterns = {"/admin/add-quiz-question"})
public class AddQuizQuestionServlet extends HttpServlet {

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

        String lessonIdStr = request.getParameter("lessonId");
        String questionText = request.getParameter("questionText");
        String[] optionTexts = request.getParameterValues("optionText"); // Lấy tất cả các lựa chọn
        String correctOptionIndexStr = request.getParameter("correctOption");

        String redirectURL = request.getContextPath() + "/admin/manage-lessons"; // Mặc định về trang quản lý bài học nếu có lỗi

        // Validation cơ bản
        if (lessonIdStr == null || questionText == null || questionText.trim().isEmpty() ||
            optionTexts == null || correctOptionIndexStr == null) {
            session.setAttribute("errorMessage_quiz", "Dữ liệu không hợp lệ. Vui lòng điền đầy đủ thông tin.");
            response.sendRedirect(redirectURL);
            return;
        }

        int lessonId = 0;
        int correctOptionIndex = -1;
        try {
            lessonId = Integer.parseInt(lessonIdStr);
            correctOptionIndex = Integer.parseInt(correctOptionIndexStr);
            redirectURL = request.getContextPath() + "/admin/manage-quiz?lessonId=" + lessonId; // Cập nhật URL redirect
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_quiz", "Dữ liệu ID không hợp lệ.");
            response.sendRedirect(redirectURL);
            return;
        }

        // Tạo đối tượng QuizQuestion và các QuizOption
        QuizQuestion newQuestion = new QuizQuestion();
        newQuestion.setLessonId(lessonId);
        newQuestion.setQuestionText(questionText);

        List<QuizOption> options = new ArrayList<>();
        for (int i = 0; i < optionTexts.length; i++) {
            String optionText = optionTexts[i];
            if (optionText != null && !optionText.trim().isEmpty()) {
                QuizOption option = new QuizOption();
                option.setOptionText(optionText);
                // Đánh dấu đáp án đúng
                if (i == correctOptionIndex) {
                    option.setIsCorrect(true);
                } else {
                    option.setIsCorrect(false);
                }
                options.add(option);
            }
        }

        // Kiểm tra phải có ít nhất 2 lựa chọn
        if (options.size() < 2) {
             session.setAttribute("errorMessage_quiz", "Một câu hỏi phải có ít nhất 2 lựa chọn.");
             response.sendRedirect(redirectURL);
             return;
        }

        newQuestion.setOptions(options);

        // Gọi DAO để thêm vào CSDL (với transaction)
        boolean success = quizDAO.addQuestionWithOptions(newQuestion);

        if (success) {
            session.setAttribute("successMessage_quiz", "Thêm câu hỏi mới thành công!");
        } else {
            session.setAttribute("errorMessage_quiz", "Thêm câu hỏi thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(redirectURL);
    }
}