package controller; // Hoặc package controller của bạn

import dao.LessonDAO;   // Hoặc package dao của bạn
import model.Lesson;    // Hoặc package model của bạn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet này xử lý việc cập nhật thông tin bài học từ form sửa của Admin.
 * Được bảo vệ bởi AdminAuthFilter.
 */
@WebServlet(name = "UpdateLessonServlet", urlPatterns = {"/admin/update-lesson-action"})
public class UpdateLessonServlet extends HttpServlet {

    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String lessonIdStr = request.getParameter("lessonId");
        String title = request.getParameter("lessonTitle");
        String content = request.getParameter("lessonContent");

        int lessonId = 0;
        // Validate lessonId
        if (lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID bài học không hợp lệ hoặc bị thiếu.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            return;
        }

        try {
            lessonId = Integer.parseInt(lessonIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài học không phải là số hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            return;
        }

        // Validate title and content
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            request.setAttribute("errorMessage_editLesson", "Tiêu đề và nội dung bài học không được để trống.");

            // Để điền lại form, chúng ta cần tạo lại đối tượng Lesson với dữ liệu đã nhập (hoặc lấy lại từ DB nếu muốn)
            // Ở đây, chúng ta dùng dữ liệu người dùng đã nhập để họ sửa
            Lesson lessonDataForForm = new Lesson();
            lessonDataForForm.setLessonId(lessonId); // Giữ lại lessonId
            lessonDataForForm.setTitle(title);       // Dùng title người dùng vừa nhập
            lessonDataForForm.setContent(content);   // Dùng content người dùng vừa nhập
            // Bạn có thể lấy createdAt từ DB nếu muốn hiển thị chính xác, nhưng không cần thiết cho việc điền lại form này

            request.setAttribute("lessonToEdit", lessonDataForForm);
            request.getRequestDispatcher("/admin/editLesson.jsp").forward(request, response);
            return;
        }

        Lesson lessonToUpdate = new Lesson();
        lessonToUpdate.setLessonId(lessonId);
        lessonToUpdate.setTitle(title);
        lessonToUpdate.setContent(content);
        // createdAt không cần cập nhật ở đây, trừ khi bạn có logic riêng

        boolean success = lessonDAO.updateLesson(lessonToUpdate);

        if (success) {
            session.setAttribute("successMessage", "Cập nhật bài học ID " + lessonId + " thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật bài học ID " + lessonId + " thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
    }

    @Override
    public String getServletInfo() {
        return "Servlet to update an existing lesson";
    }
}