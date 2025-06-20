package filters; // Hoặc package filter của bạn

import model.User; // Hoặc package model của bạn
import java.io.IOException;
import java.util.logging.Level; // Thêm import
import java.util.logging.Logger; // Thêm import
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {
    // Thêm Logger
    private static final Logger LOGGER = Logger.getLogger(AdminAuthFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AdminAuthFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Lấy session, không tạo mới

        LOGGER.log(Level.INFO, "AdminAuthFilter: Processing request for URL: {0}", httpRequest.getRequestURI());

        boolean isAdmin = false;
        User loggedInUser = null;

        if (session != null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
            LOGGER.log(Level.INFO, "AdminAuthFilter: Session exists.");
            if (loggedInUser != null) {
                LOGGER.log(Level.INFO, "AdminAuthFilter: User found in session. Username: {0}, Role: {1}",
                        new Object[]{loggedInUser.getUsername(), loggedInUser.getRole()});
                if ("ADMIN".equals(loggedInUser.getRole())) { // So sánh vai trò một cách an toàn
                    isAdmin = true;
                    LOGGER.info("AdminAuthFilter: User is ADMIN.");
                } else {
                    LOGGER.log(Level.WARNING, "AdminAuthFilter: User is NOT ADMIN. Role is: {0}", loggedInUser.getRole());
                }
            } else {
                LOGGER.info("AdminAuthFilter: No user object ('loggedInUser') found in session.");
            }
        } else {
            LOGGER.info("AdminAuthFilter: No active session found.");
        }

        if (isAdmin) {
            LOGGER.info("AdminAuthFilter: Access GRANTED. Forwarding to next in chain.");
            chain.doFilter(request, response); // Cho phép tiếp tục
        } else {
            LOGGER.log(Level.WARNING, "AdminAuthFilter: Access DENIED. Redirecting to login page or showing error.");
            if (loggedInUser != null) { // Đã đăng nhập nhưng không phải admin
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            } else { // Chưa đăng nhập
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Vui lòng đăng nhập với tài khoản Admin để truy cập.");
            }
        }
    }

    @Override
    public void destroy() {
        LOGGER.info("AdminAuthFilter destroyed.");
    }
}