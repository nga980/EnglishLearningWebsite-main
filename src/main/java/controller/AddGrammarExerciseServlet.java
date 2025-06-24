package controller;

import dao.QuizDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.QuizOption;
import model.QuizQuestion;

/**
 * Servlet này xử lý việc thêm một câu hỏi bài tập mới cho một chủ đề ngữ pháp.
 */
@WebServlet(name = "AddGrammarExerciseServlet", urlPatterns = {"/admin/add-grammar-exercise"})
public class AddGrammarExerciseServlet extends HttpServlet {

    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo request được xử lý với encoding UTF-8 để không lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy các tham số từ form
        String grammarTopicIdStr = request.getParameter("grammarTopicId");
        String questionText = request.getParameter("questionText");
        String[] optionTexts = request.getParameterValues("optionText");
        String correctOptionIndexStr = request.getParameter("correctOptionIndex");
        System.out.println("Received grammarTopicId: '" + grammarTopicIdStr + "'");
        System.out.println("Received correctOptionIndex: '" + correctOptionIndexStr + "'");

        // Chuẩn bị URL để chuyển hướng, mặc định là trang quản lý ngữ pháp chung
        String redirectURL = request.getContextPath() + "/admin/manage-grammar";

        // Nếu có grammarTopicId, chuyển hướng về trang quản lý bài tập của chủ đề đó
        if (grammarTopicIdStr != null && !grammarTopicIdStr.trim().isEmpty()) {
            redirectURL = request.getContextPath() + "/admin/manage-grammar-exercises?grammarTopicId=" + grammarTopicIdStr;
        }

        // --- Kiểm tra dữ liệu đầu vào ---
        if (grammarTopicIdStr == null || questionText == null || questionText.trim().isEmpty() ||
            optionTexts == null || correctOptionIndexStr == null) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng điền đầy đủ thông tin.");
            response.sendRedirect(redirectURL);
            return;
        }

        int grammarTopicId;
        int correctOptionIndex;
        try {
            grammarTopicId = Integer.parseInt(grammarTopicIdStr);
            // Index của radio button bắt đầu từ 0
            correctOptionIndex = Integer.parseInt(correctOptionIndexStr); 
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu ID hoặc chỉ mục không hợp lệ.");
            response.sendRedirect(redirectURL);
            return;
        }

        // --- Tạo đối tượng QuizQuestion và các QuizOption ---
        QuizQuestion newQuestion = new QuizQuestion();
        newQuestion.setGrammarTopicId(grammarTopicId);
        newQuestion.setQuestionText(questionText);

        List<QuizOption> options = new ArrayList<>();
        for (int i = 0; i < optionTexts.length; i++) {
            String optionText = optionTexts[i];
            // Chỉ thêm các lựa chọn có nội dung
            if (optionText != null && !optionText.trim().isEmpty()) {
                QuizOption option = new QuizOption();
                option.setOptionText(optionText);
                // So sánh index của vòng lặp với index của đáp án đúng được chọn
                option.setIsCorrect(i == correctOptionIndex); 
                options.add(option);
            }
        }

        // Một câu hỏi phải có ít nhất 2 lựa chọn để có ý nghĩa
        if (options.size() < 2) {
             session.setAttribute("errorMessage", "Một câu hỏi phải có ít nhất 2 lựa chọn có nội dung.");
             response.sendRedirect(redirectURL);
             return;
        }

        newQuestion.setOptions(options);

        // --- Gọi đúng phương thức DAO để lưu vào CSDL ---
        boolean success = quizDAO.addQuestionForGrammar(newQuestion);

        if (success) {
            session.setAttribute("successMessage", "Thêm bài tập mới thành công!");
        } else {
            session.setAttribute("errorMessage", "Thêm bài tập thất bại. Đã có lỗi xảy ra ở phía máy chủ.");
        }
        
        // Chuyển hướng người dùng trở lại trang quản lý
        response.sendRedirect(redirectURL);
    }
}