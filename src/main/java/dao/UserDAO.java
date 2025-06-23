package dao;

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
import javax.naming.NamingException; // Thêm import
import model.User;
import utils.PasswordUtils;
import java.util.Map;
import java.util.LinkedHashMap;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean checkUserExist(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra username: " + username, e);
        }
        return false;
    }

    public boolean addUser(User user) {
        String hashedPassword = PasswordUtils.hashPassword(user.getPassword());
        if (hashedPassword == null) {
            LOGGER.log(Level.SEVERE, "DAO: Không thể mã hóa mật khẩu cho người dùng: {0}", user.getUsername());
            return false;
        }

        String query = "INSERT INTO users (username, password, email, full_name, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = ps.executeUpdate();
            LOGGER.log(Level.INFO, "DAO addUser: Rows affected for {0}: {1}", new Object[]{user.getUsername(), rowsAffected});
            return rowsAffected > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "DAO: Lỗi khi thêm người dùng: " + user.getUsername(), e);
        }
        return false;
    }

    public User login(String username, String plainPassword) {
        String query = "SELECT user_id, username, password, email, full_name, role, created_at FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPasswordFromDB = rs.getString("password");
                    if (PasswordUtils.checkPassword(plainPassword, hashedPasswordFromDB)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setFullName(rs.getString("full_name"));
                        user.setRole(rs.getString("role"));
                        user.setCreatedAt(rs.getTimestamp("created_at"));
                        LOGGER.log(Level.INFO, "UserDAO.login: User ''{0}'' fetched with role: ''{1}''",
                            new Object[]{user.getUsername(), user.getRole()});
                        return user;
                    }
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi đăng nhập cho người dùng: " + username, e);
        }
        return null;
    }

    public int countTotalUsers() {
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số người dùng", e);
        }
        return 0;
    }
    
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng", e);
        }
        return userList;
    }

    public boolean updateUserRole(int userId, String newRole) {
        if (!"ADMIN".equals(newRole) && !"USER".equals(newRole)) {
            LOGGER.log(Level.WARNING, "Versuch, eine ungültige Rolle festzulegen: {0}", newRole);
            return false;
        }

        String query = "UPDATE users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newRole);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật vai trò cho người dùng ID: " + userId, e);
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa người dùng ID: " + userId, e);
        }
        return false;
    }

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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy mật khẩu của người dùng ID: " + userId, e);
        }
        return null;
    }

    public boolean updatePassword(int userId, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật mật khẩu cho người dùng ID: " + userId, e);
        }
        return false;
    }
    
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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách người dùng theo trang", e);
        }
        return userList;
    }
   
   public User findUserByEmail(String email) {
       String query = "SELECT * FROM users WHERE email = ?";
       try (Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setString(1, email);
           try (ResultSet rs = ps.executeQuery()) {
               if (rs.next()) {
                   User user = new User();
                   user.setUserId(rs.getInt("user_id"));
                   user.setUsername(rs.getString("username"));
                   user.setEmail(rs.getString("email"));
                   user.setFullName(rs.getString("full_name"));
                   user.setRole(rs.getString("role"));
                   user.setCreatedAt(rs.getTimestamp("created_at"));
                   return user;
               }
           }
       } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
           LOGGER.log(Level.SEVERE, "Lỗi khi tìm người dùng bằng email: " + email, e);
       }
       return null;
   }

   public void createPasswordResetToken(int userId, String token, Timestamp expiryDate) {
       String query = "INSERT INTO password_reset_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";
       try (Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userId);
           ps.setString(2, token);
           ps.setTimestamp(3, expiryDate);
           ps.executeUpdate();
       } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
           LOGGER.log(Level.SEVERE, "Lỗi khi tạo token đặt lại mật khẩu cho user ID: " + userId, e);
       }
   }

   public int getUserIdByPasswordResetToken(String token) {
       String query = "SELECT user_id FROM password_reset_tokens WHERE token = ? AND expiry_date > NOW()";
       try (Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setString(1, token);
           try (ResultSet rs = ps.executeQuery()) {
               if (rs.next()) {
                   return rs.getInt("user_id");
               }
           }
       } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
           LOGGER.log(Level.SEVERE, "Lỗi khi xác thực token đặt lại mật khẩu", e);
       }
       return -1;
   }

   public void deletePasswordResetToken(String token) {
       String query = "DELETE FROM password_reset_tokens WHERE token = ?";
       try (Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setString(1, token);
           ps.executeUpdate();
       } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
           LOGGER.log(Level.SEVERE, "Lỗi khi xóa token đặt lại mật khẩu", e);
       }
   }

    public Map<String, Integer> getMonthlyUserGrowth(int lastMonths) {
        Map<String, Integer> monthlyGrowth = new LinkedHashMap<>();
        String query = "SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, COUNT(user_id) AS count " +
                       "FROM users " +
                       "WHERE created_at >= CURDATE() - INTERVAL ? MONTH " +
                       "GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY year, month;";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, lastMonths);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String monthKey = "Tháng " + rs.getInt("month") + "/" + rs.getInt("year");
                    monthlyGrowth.put(monthKey, rs.getInt("count"));
                }
            }
        } catch (Exception e) { // Để Exception chung ở đây vì nó không phải luồng chính
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy dữ liệu tăng trưởng người dùng", e);
        }
        return monthlyGrowth;
    }
}