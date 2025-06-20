package controller; // Hoặc package controller của bạn

import dao.LessonDAO;   // Hoặc package dao của bạn
import model.Lesson;    // Hoặc package model của bạn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Để sử dụng session cho flash message

/**
 * Servlet này xử lý việc thêm bài học mới từ form của Admin.
 * Được bảo vệ bởi AdminAuthFilter.
 */
@WebServlet(name = "AddLessonServlet", urlPatterns = {"/admin/add-lesson-action"})
public class AddLessonServlet extends HttpServlet {

    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu admin cố gắng truy cập URL này bằng GET, chuyển hướng họ đến form thêm mới
        // Hoặc có thể hiển thị lỗi/không cho phép.
        response.sendRedirect(request.getContextPath() + "/admin/addLesson.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String title = request.getParameter("lessonTitle");
        String content = request.getParameter("lessonContent");

        // Validate input
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            request.setAttribute("errorMessage_addLesson", "Tiêu đề và nội dung bài học không được để trống.");
            // Giữ lại giá trị đã nhập để điền lại form
            request.setAttribute("lessonTitle", title); // Hoặc dùng param như trong JSP: ${param.lessonTitle}
            request.setAttribute("lessonContent", content); // Hoặc dùng param như trong JSP: ${param.lessonContent}
            request.getRequestDispatcher("/admin/addLesson.jsp").forward(request, response);
            return;
        }

        Lesson newLesson = new Lesson();
        newLesson.setTitle(title);
        newLesson.setContent(content);
        // lessonId và createdAt sẽ được tự động tạo hoặc set trong DAO/DB

        boolean success = lessonDAO.addLesson(newLesson);
        HttpSession session = request.getSession();

        if (success) {
            session.setAttribute("successMessage", "Thêm bài học mới thành công!");
        } else {
            session.setAttribute("errorMessage", "Thêm bài học thất bại. Vui lòng thử lại.");
        }
        // Chuyển hướng về trang quản lý bài học để tránh lỗi double submission
        response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
    }

    @Override
    public String getServletInfo() {
        return "Servlet to add a new lesson";
    }
}