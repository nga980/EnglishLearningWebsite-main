/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author admin
 */

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import utils.SecurityUtils;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean checkUserExist(String username) {
        // ... (giữ nguyên code)
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra username: " + username, e);
        }
        return false;
    }

    // Trong UserDAO.java
public boolean addUser(User user) {
    // 1. Kiểm tra username tồn tại (bạn đã làm điều này ở Servlet, nhưng có thể giữ lại ở DAO như một lớp bảo vệ nữa)
    // if (checkUserExist(user.getUsername())) {
    //     LOGGER.log(Level.WARNING, "DAO: Attempted to add existing username: {0}", user.getUsername());
    //     return false; // Username đã tồn tại
    // }

    // 2. Mã hóa mật khẩu
    String hashedPassword = SecurityUtils.hashPassword(user.getPassword());
    if (hashedPassword == null) {
        LOGGER.log(Level.SEVERE, "DAO: Không thể mã hóa mật khẩu cho người dùng: {0}", user.getUsername());
        return false; // Lỗi mã hóa
    }

    String query = "INSERT INTO users (username, password, email, full_name, created_at) VALUES (?, ?, ?, ?, ?)";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, user.getUsername());
        ps.setString(2, hashedPassword);
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getFullName());
        ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

        int rowsAffected = ps.executeUpdate(); // Lấy số hàng bị ảnh hưởng
        LOGGER.log(Level.INFO, "DAO addUser: Rows affected for {0}: {1}", new Object[]{user.getUsername(), rowsAffected});
        return rowsAffected > 0; // Chỉ trả về true nếu có ít nhất 1 hàng được thêm
    } catch (SQLException | ClassNotFoundException e) {
        LOGGER.log(Level.SEVERE, "DAO: Lỗi khi thêm người dùng: " + user.getUsername(), e);
    }
    return false; // Mặc định trả về false nếu có lỗi hoặc không có hàng nào được thêm
}

    public User login(String username, String plainPassword) {
        // Cập nhật câu query để lấy thêm cột 'role'
        String query = "SELECT user_id, username, password, email, full_name, role, created_at FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPasswordFromDB = rs.getString("password");
                    if (SecurityUtils.checkPassword(plainPassword, hashedPasswordFromDB)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setFullName(rs.getString("full_name"));
                        user.setRole(rs.getString("role")); // Lấy và set role
                        user.setCreatedAt(rs.getTimestamp("created_at"));
                        LOGGER.log(Level.INFO, "UserDAO.login: User ''{0}'' fetched with role: ''{1}''",
                            new Object[]{user.getUsername(), user.getRole()});
                        return user;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đăng nhập cho người dùng: " + username, e);
        }
        return null;
    }
    /**
     * Đếm tổng số người dùng trong CSDL.
     * @return Tổng số người dùng.
     */
    public int countTotalUsers() {
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số người dùng", e);
        }
        return 0;
    }
    /**
     * Lấy tất cả người dùng từ CSDL (không bao gồm mật khẩu).
     * @return Danh sách các đối tượng User.
     */
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        // Lấy tất cả các cột trừ cột password
        String query = "SELECT user_id, username, email, full_name, role, created_at FROM users ORDER BY user_id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                userList.add(user);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng", e);
        }
        return userList;
    }
    /**
     * Cập nhật vai trò (role) cho một người dùng cụ thể.
     * @param userId ID của người dùng cần cập nhật.
     * @param newRole Vai trò mới ('ADMIN' hoặc 'USER').
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateUserRole(int userId, String newRole) {
        // Chỉ cho phép cập nhật vai trò thành ADMIN hoặc USER để đảm bảo an toàn
        if (!"ADMIN".equals(newRole) && !"USER".equals(newRole)) {
            LOGGER.log(Level.WARNING, "Versuch, eine ungültige Rolle festzulegen: {0}", newRole); // Cảnh báo về việc cố gắng đặt vai trò không hợp lệ
            return false;
        }

        String query = "UPDATE users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, newRole);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0; // Trả về true nếu có ít nhất 1 dòng được cập nhật
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật vai trò cho người dùng ID: " + userId, e);
        }
        return false;
    }
    /**
     * Xóa một người dùng khỏi CSDL dựa trên ID.
     * @param userId ID của người dùng cần xóa.
     * @return true nếu xóa thành công, false nếu thất bại.
     */
    public boolean deleteUser(int userId) {
        // Cảnh báo: Việc xóa người dùng có thể ảnh hưởng đến các bảng khác
        // nếu có khóa ngoại (ví dụ: user_quiz_attempts).
        // Đảm bảo CSDL của bạn đã thiết lập ON DELETE CASCADE cho các khóa ngoại này
        // để khi xóa user, các dữ liệu liên quan của họ cũng được xóa theo.
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa người dùng ID: " + userId, e);
        }
        return false;
    }
    /**
     * Lấy mật khẩu đã được mã hóa của người dùng từ CSDL.
     * @param userId ID của người dùng.
     * @return Chuỗi mật khẩu đã mã hóa, hoặc null nếu không tìm thấy người dùng.
     */
    public String getHashedPasswordById(int userId) {
        String query = "SELECT password FROM users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy mật khẩu của người dùng ID: " + userId, e);
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu mới cho người dùng.
     * @param userId ID của người dùng.
     * @param newHashedPassword Mật khẩu mới đã được mã hóa.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updatePassword(int userId, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật mật khẩu cho người dùng ID: " + userId, e);
        }
        return false;
    }
    /**
     * Lấy danh sách người dùng theo trang.
     * @param pageNumber Số trang hiện tại.
     * @param pageSize Số lượng người dùng trên trang.
     * @return Danh sách người dùng.
     */
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        List<User> userList = new ArrayList<>();
        String query = "SELECT user_id, username, email, full_name, role, created_at FROM users ORDER BY user_id ASC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    userList.add(user);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng theo trang", e);
        }
        return userList;
    }
}