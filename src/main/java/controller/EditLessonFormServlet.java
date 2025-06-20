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
 * Servlet này xử lý việc hiển thị form để sửa thông tin bài học.
 * Nó lấy thông tin bài học hiện tại và chuyển đến editLesson.jsp.
 */
@WebServlet(name = "EditLessonFormServlet", urlPatterns = {"/admin/edit-lesson-form"})
public class EditLessonFormServlet extends HttpServlet {

    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID bài học để sửa.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdStr);
            Lesson lessonToEdit = lessonDAO.getLessonById(lessonId);

            if (lessonToEdit != null) {
                request.setAttribute("lessonToEdit", lessonToEdit);
                request.getRequestDispatcher("/admin/editLesson.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy bài học với ID: " + lessonId);
                response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài học không hợp lệ: " + lessonIdStr);
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
        }
    }
}