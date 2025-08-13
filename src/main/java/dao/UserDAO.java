package dao;

import utils.DBContext;
import model.User;
import utils.PasswordUtils;

import javax.naming.NamingException;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /* =========================
       Helpers
       ========================= */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    /* =========================
       CRUD & Auth
       ========================= */
    public boolean checkUserExist(String username) {
        String sql = "SELECT COUNT(*) FROM dbo.users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra username: " + username, e);
            return false;
        }
    }

    public boolean addUser(User user) {
        String hashedPassword = PasswordUtils.hashPassword(user.getPassword());
        if (hashedPassword == null) {
            LOGGER.log(Level.SEVERE, "Không thể mã hóa mật khẩu cho người dùng: {0}", user.getUsername());
            return false;
        }

        // created_at để DB tự set DEFAULT -> không truyền từ Java
        String sql = "INSERT INTO dbo.users (username, [password], email, full_name, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setString(5, (user.getRole() == null || user.getRole().isBlank()) ? "USER" : user.getRole());

            int rows = ps.executeUpdate();
            LOGGER.log(Level.INFO, "addUser: Rows affected for {0}: {1}", new Object[]{user.getUsername(), rows});
            return rows > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm người dùng: " + user.getUsername(), e);
            return false;
        }
    }

    public User login(String username, String plainPassword) {
        String sql = "SELECT user_id, username, [password], email, full_name, role, created_at " +
                     "FROM dbo.users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashed = rs.getString("password");
                    if (PasswordUtils.checkPassword(plainPassword, hashed)) {
                        User u = mapRow(rs);
                        LOGGER.log(Level.INFO, "login: User ''{0}'' role ''{1}''", new Object[]{u.getUsername(), u.getRole()});
                        return u;
                    }
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đăng nhập cho người dùng: " + username, e);
        }
        return null;
    }

    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM dbo.users";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số người dùng", e);
            return 0;
        }
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, username, email, full_name, role, created_at " +
                     "FROM dbo.users ORDER BY user_id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng", e);
        }
        return list;
    }

    public boolean updateUserRole(int userId, String newRole) {
        if (!"ADMIN".equalsIgnoreCase(newRole) && !"USER".equalsIgnoreCase(newRole)) {
            LOGGER.log(Level.WARNING, "Vai trò không hợp lệ: {0}", newRole);
            return false;
        }
        String sql = "UPDATE dbo.users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole.toUpperCase());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật vai trò cho user_id=" + userId, e);
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM dbo.users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa người dùng ID: " + userId, e);
            return false;
        }
    }

    public String getHashedPasswordById(int userId) {
        String sql = "SELECT [password] FROM dbo.users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("password") : null;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy mật khẩu của user_id=" + userId, e);
            return null;
        }
    }

    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE dbo.users SET [password] = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật mật khẩu cho user_id=" + userId, e);
            return false;
        }
    }

    /* =========================
       Phân trang & Tìm kiếm
       ========================= */
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, username, email, full_name, role, created_at " +
                     "FROM dbo.users " +
                     "ORDER BY user_id ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        int offset = Math.max(0, (pageNumber - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng theo trang", e);
        }
        return list;
    }

    public User findUserByEmail(String email) {
        String sql = "SELECT user_id, username, email, full_name, role, created_at " +
                     "FROM dbo.users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm user bằng email: " + email, e);
            return null;
        }
    }

    /* =========================
       Password reset token
       ========================= */
    public void createPasswordResetToken(int userId, String token, Timestamp expiryDate) {
        String sql = "INSERT INTO dbo.password_reset_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiryDate);
            ps.executeUpdate();
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo token đặt lại mật khẩu cho user_id=" + userId, e);
        }
    }

    public int getUserIdByPasswordResetToken(String token) {
        // SQL Server: dùng GETDATE() thay NOW(), và so sánh > GETDATE()
        String sql = "SELECT user_id FROM dbo.password_reset_tokens WHERE token = ? AND expiry_date > GETDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("user_id") : -1;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xác thực token đặt lại mật khẩu", e);
            return -1;
        }
    }

    public void deletePasswordResetToken(String token) {
        String sql = "DELETE FROM dbo.password_reset_tokens WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa token đặt lại mật khẩu", e);
        }
    }

    /* =========================
       Thống kê
       ========================= */
    public Map<String, Integer> getMonthlyUserGrowth(int lastMonths) {
        Map<String, Integer> monthly = new LinkedHashMap<>();
        String sql =
            "SELECT YEAR(created_at) AS [year], MONTH(created_at) AS [month], COUNT(user_id) AS [count] " +
            "FROM dbo.users " +
            "WHERE created_at >= DATEADD(MONTH, -?, CAST(GETDATE() AS DATE)) " +
            "GROUP BY YEAR(created_at), MONTH(created_at) " +
            "ORDER BY [year], [month]";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lastMonths);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String key = "Tháng " + rs.getInt("month") + "/" + rs.getInt("year");
                    monthly.put(key, rs.getInt("count"));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy dữ liệu tăng trưởng người dùng", e);
        }
        return monthly;
    }
}
