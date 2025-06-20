package controller; // Hoặc package controller của bạn

import dao.VocabularyDAO; // Hoặc package dao của bạn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DeleteVocabularyServlet", urlPatterns = {"/admin/delete-vocabulary"})
public class DeleteVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    private static final Logger LOGGER = Logger.getLogger(DeleteVocabularyServlet.class.getName());

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String vocabIdStr = request.getParameter("vocabId");

        if (vocabIdStr == null || vocabIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage_vocab", "Thiếu ID từ vựng để xóa.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }

        try {
            int vocabId = Integer.parseInt(vocabIdStr);
            LOGGER.log(Level.INFO, "Attempting to delete vocabulary with ID: {0}", vocabId);

            boolean success = vocabularyDAO.deleteVocabulary(vocabId);

            if (success) {
                LOGGER.log(Level.INFO, "Successfully deleted vocabulary with ID: {0}", vocabId);
                session.setAttribute("successMessage_vocab", "Xóa từ vựng ID " + vocabId + " thành công!");
            } else {
                LOGGER.log(Level.WARNING, "Failed to delete vocabulary with ID: {0}. DAO returned false.", vocabId);
                session.setAttribute("errorMessage_vocab", "Xóa từ vựng ID " + vocabId + " thất bại.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid vocabulary ID format for deletion: {0}", vocabIdStr);
            session.setAttribute("errorMessage_vocab", "ID từ vựng không hợp lệ: " + vocabIdStr);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting vocabulary with ID: " + vocabIdStr, e);
            session.setAttribute("errorMessage_vocab", "Lỗi hệ thống khi xóa từ vựng. Chi tiết: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET cho thao tác xóa đơn giản này
    }
}