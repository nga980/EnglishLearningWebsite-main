package controller; // Hoặc package controller của bạn

import dao.LessonDAO;   // Hoặc package dao của bạn
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
 * Servlet này xử lý việc xóa một bài học.
 * Được bảo vệ bởi AdminAuthFilter.
 */
@WebServlet(name = "DeleteLessonServlet", urlPatterns = {"/admin/delete-lesson"})
public class DeleteLessonServlet extends HttpServlet {

    private LessonDAO lessonDAO;
    private static final Logger LOGGER = Logger.getLogger(DeleteLessonServlet.class.getName());

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
            session.setAttribute("errorMessage", "Thiếu ID bài học để xóa.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdStr);
            LOGGER.log(Level.INFO, "Attempting to delete lesson with ID: {0}", lessonId);

            boolean success = lessonDAO.deleteLesson(lessonId);

            if (success) {
                LOGGER.log(Level.INFO, "Successfully deleted lesson with ID: {0}", lessonId);
                session.setAttribute("successMessage", "Xóa bài học ID " + lessonId + " thành công!");
            } else {
                LOGGER.log(Level.WARNING, "Failed to delete lesson with ID: {0}. DAO returned false.", lessonId);
                session.setAttribute("errorMessage", "Xóa bài học ID " + lessonId + " thất bại. Bài học có thể không tồn tại hoặc có lỗi xảy ra.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid lesson ID format for deletion: {0}", lessonIdStr);
            session.setAttribute("errorMessage", "ID bài học không hợp lệ: " + lessonIdStr);
        } catch (Exception e) { // Bắt các lỗi khác có thể xảy ra từ DAO hoặc CSDL
            LOGGER.log(Level.SEVERE, "Error deleting lesson with ID: " + lessonIdStr, e);
            session.setAttribute("errorMessage", "Lỗi hệ thống khi xóa bài học. Chi tiết: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu bạn muốn chuyển sang dùng POST cho an toàn hơn (khuyến nghị)
        // thì xử lý logic xóa ở đây và form trong JSP sẽ là method="POST"
        // Hiện tại, cho GET xử lý để đơn giản với link có confirm.
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to delete a lesson";
    }
}