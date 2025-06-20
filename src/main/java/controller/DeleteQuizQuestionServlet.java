package controller;

import dao.QuizDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet này xử lý việc xóa một câu hỏi quiz.
 * Được bảo vệ bởi AdminAuthFilter.
 */
@WebServlet(name = "DeleteQuizQuestionServlet", urlPatterns = {"/admin/delete-quiz-question"})
public class DeleteQuizQuestionServlet extends HttpServlet {

    private QuizDAO quizDAO;
    private static final Logger LOGGER = Logger.getLogger(DeleteQuizQuestionServlet.class.getName());

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String questionIdStr = request.getParameter("questionId");
        String lessonIdStr = request.getParameter("lessonId"); // Lấy lessonId để redirect lại đúng trang

        // URL mặc định để redirect nếu có lỗi không xác định được lessonId
        String redirectURL = request.getContextPath() + "/admin/manage-lessons";

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            // URL để redirect lại đúng trang quản lý quiz của bài học
            redirectURL = request.getContextPath() + "/admin/manage-quiz?lessonId=" + lessonIdStr;
        }

        if (questionIdStr == null || questionIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage_quiz", "Thiếu ID câu hỏi để xóa.");
            response.sendRedirect(redirectURL);
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdStr);
            LOGGER.log(Level.INFO, "Attempting to delete question with ID: {0}", questionId);

            // Nhắc lại: CSDL của bạn nên có ON DELETE CASCADE cho khóa ngoại
            // từ quiz_options đến quiz_questions để khi xóa câu hỏi, các lựa chọn cũng bị xóa theo.
            boolean success = quizDAO.deleteQuestion(questionId);

            if (success) {
                session.setAttribute("successMessage_quiz", "Xóa câu hỏi ID " + questionId + " thành công!");
            } else {
                session.setAttribute("errorMessage_quiz", "Xóa câu hỏi ID " + questionId + " thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_quiz", "ID câu hỏi không hợp lệ: " + questionIdStr);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa câu hỏi: ", e);
            session.setAttribute("errorMessage_quiz", "Lỗi hệ thống khi xóa câu hỏi.");
        }

        // Chuyển hướng trở lại trang quản lý quiz
        response.sendRedirect(redirectURL);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thao tác xóa có thể được thực hiện qua GET cho đơn giản trong trường hợp này
        doGet(request, response);
    }
}