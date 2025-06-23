package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Một lớp Servlet trừu tượng cơ sở để xử lý logic phân trang chung
 * cho các trang quản lý (manage pages).
 *
 * @param <T> Kiểu của đối tượng được quản lý (ví dụ: Lesson, User, Vocabulary)
 */
public abstract class BaseManageServlet<T> extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String pageStr = request.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1; 
            }
        }

        int totalItems = getTotalItems();
        int pageSize = getPageSize();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }
        
        List<T> itemList = getItemsByPage(currentPage, pageSize);

        // Đặt các thuộc tính vào request để JSP có thể sử dụng
        request.setAttribute(getItemListAttributeName(), itemList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute(getTotalItemsAttributeName(), totalItems);
        
        // Chuyển tiếp đến trang JSP tương ứng
        request.getRequestDispatcher(getJspPage()).forward(request, response);
    }

    /**
     * Lớp con phải triển khai phương thức này để trả về tổng số mục.
     * @return tổng số mục
     */
    protected abstract int getTotalItems();

    /**
     * Lớp con phải triển khai phương thức này để lấy danh sách các mục cho trang hiện tại.
     * @param currentPage trang hiện tại
     * @param pageSize số mục trên mỗi trang
     * @return danh sách các mục
     */
    protected abstract List<T> getItemsByPage(int currentPage, int pageSize);

    /**
     * Lớp con phải trả về tên thuộc tính cho danh sách các mục.
     * Ví dụ: "lessonList", "userList".
     * @return tên thuộc tính
     */
    protected abstract String getItemListAttributeName();

    /**
     * Lớp con phải trả về tên thuộc tính cho tổng số mục.
     * Ví dụ: "totalLessons", "totalUsers".
     * @return tên thuộc tính
     */
    protected abstract String getTotalItemsAttributeName();

    /**
     * Lớp con phải trả về đường dẫn đến file JSP hiển thị.
     * Ví dụ: "/admin/manageLessons.jsp".
     * @return đường dẫn JSP
     */
    protected abstract String getJspPage();

    /**
     * Lớp con có thể ghi đè phương thức này nếu muốn một kích thước trang khác.
     * @return số mục trên mỗi trang
     */
    protected int getPageSize() {
        return DEFAULT_PAGE_SIZE;
    }
}