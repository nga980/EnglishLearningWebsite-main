package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBContext {

    /**
     * Lấy kết nối đến cơ sở dữ liệu từ Connection Pool của server (JNDI).
     *
     * @return Đối tượng Connection nếu thành công, null nếu thất bại.
     * @throws SQLException Nếu có lỗi SQL xảy ra.
     * @throws NamingException Nếu không tìm thấy JNDI name.
     */
    public static Connection getConnection() throws SQLException, NamingException {
        Context initContext = new InitialContext();
        Context envContext = (Context) initContext.lookup("java:comp/env");
        DataSource ds = (DataSource) envContext.lookup("jdbc/EnglishLearningDB");
        return ds.getConnection();
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
                conn.close(); // Trả kết nối về lại pool
            }
        } catch (SQLException e) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing Connection", e);
        }
    }
    
    public static void main(String[] args) {
        // Phương thức main này sẽ không hoạt động nữa vì nó chạy ngoài container
        // và không thể thực hiện JNDI lookup. Việc kiểm tra kết nối cần được thực hiện
        // thông qua một servlet hoặc một điểm cuối nào đó trên ứng dụng đã được triển khai.
        System.out.println("Để kiểm tra kết nối JNDI, vui lòng triển khai ứng dụng lên server và truy cập một trang web.");
    }
}