package utils;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author admin
 */
public class DBContext {
    // Thay đổi các thông số này cho phù hợp với CSDL của bạn
    private static final String DB_NAME = "english_learning_db"; // Tên CSDL bạn đã tạo
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306"; // Cổng mặc định của MySQL
    private static final String DB_USER = "root"; // Username của MySQL (mặc định của XAMPP thường là 'root')
    private static final String DB_PASSWORD = ""; // Password của MySQL (mặc định của XAMPP thường là rỗng)

    // JDBC URL String
    // useSSL=false: Tắt SSL nếu bạn không cấu hình SSL cho MySQL (phổ biến khi phát triển local)
    // allowPublicKeyRetrieval=true: Có thể cần cho một số phiên bản MySQL 8+
    // serverTimezone=UTC: Giúp tránh các vấn đề về múi giờ
    private static final String DB_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME +
                                         "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Lấy kết nối đến cơ sở dữ liệu.
     *
     * @return Đối tượng Connection nếu thành công, null nếu thất bại.
     * @throws SQLException Nếu có lỗi SQL xảy ra.
     * @throws ClassNotFoundException Nếu không tìm thấy driver JDBC.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Bước 1: Nạp driver
        Class.forName(DB_DRIVER);
        // Bước 2: Tạo kết nối
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Đóng kết nối, PreparedStatement và ResultSet một cách an toàn.
     *
     * @param conn Connection cần đóng
     * @param ps PreparedStatement cần đóng
     * @param rs ResultSet cần đóng
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException e) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing ResultSet", e);
        }
        try {
            if (ps != null && !ps.isClosed()) {
                ps.close();
            }
        } catch (SQLException e) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing PreparedStatement", e);
        }
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing Connection", e);
        }
    }

    /**
     * Phương thức main để kiểm tra nhanh kết nối CSDL.
     * Chạy file này (Run File) để kiểm tra.
     */
    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("Kết nối CSDL thành công! (" + DB_URL + ")");
                // Bạn có thể thử một câu truy vấn đơn giản ở đây nếu muốn
                // Ví dụ: SELECT * FROM users LIMIT 1;
            } else {
                System.out.println("Không thể kết nối đến CSDL.");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi kết nối: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy Driver JDBC: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                close(conn, null, null); // Đóng kết nối sau khi kiểm tra
            }
        }
    }
}
