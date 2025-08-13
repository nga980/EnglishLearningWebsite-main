package dao;

import model.GrammarTopic;
import utils.DBContext;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GrammarTopicDAO {
    private static final Logger LOGGER = Logger.getLogger(GrammarTopicDAO.class.getName());

    // Liệt kê cột rõ ràng + schema dbo + bọc [content]
    private static final String BASE_COLUMNS =
            "topic_id, title, [content], example_sentences, difficulty_level, created_at";

    public List<GrammarTopic> getAllGrammarTopics() {
        List<GrammarTopic> topics = new ArrayList<>();
        String sql = "SELECT " + BASE_COLUMNS + " FROM dbo.grammar_topics ORDER BY title ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                topics.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách chủ đề ngữ pháp", e);
        }
        return topics;
    }

    public GrammarTopic getGrammarTopicById(int topicId) {
        String sql = "SELECT " + BASE_COLUMNS + " FROM dbo.grammar_topics WHERE topic_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, topicId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy chủ đề ngữ pháp với ID: " + topicId, e);
        }
        return null;
    }

    public boolean addGrammarTopic(GrammarTopic topic) {
        // Để DB tự set created_at qua DEFAULT
        String sql = "INSERT INTO dbo.grammar_topics (title, [content], example_sentences, difficulty_level) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, topic.getTitle());
            ps.setString(2, topic.getContent());
            ps.setString(3, topic.getExampleSentences());
            ps.setString(4, topic.getDifficultyLevel());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) topic.setTopicId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm chủ đề ngữ pháp: " + topic.getTitle(), e);
        }
        return false;
    }

    public boolean updateGrammarTopic(GrammarTopic topic) {
        String sql = "UPDATE dbo.grammar_topics " +
                     "SET title = ?, [content] = ?, example_sentences = ?, difficulty_level = ? " +
                     "WHERE topic_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, topic.getTitle());
            ps.setString(2, topic.getContent());
            ps.setString(3, topic.getExampleSentences());
            ps.setString(4, topic.getDifficultyLevel());
            ps.setInt(5, topic.getTopicId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật chủ đề ngữ pháp ID: " + topic.getTopicId(), e);
        }
        return false;
    }

    public boolean deleteGrammarTopic(int topicId) {
        String sql = "DELETE FROM dbo.grammar_topics WHERE topic_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, topicId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa chủ đề ngữ pháp ID: " + topicId, e);
        }
        return false;
    }

    public List<GrammarTopic> searchGrammarTopics(String keyword) {
        List<GrammarTopic> topics = new ArrayList<>();
        String sql = "SELECT " + BASE_COLUMNS + " " +
                     "FROM dbo.grammar_topics " +
                     "WHERE title LIKE ? " +                 // JDBC sẽ bind %[kw]% OK
                     "ORDER BY title ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (keyword == null ? "" : keyword) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) topics.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm ngữ pháp với từ khóa: " + keyword, e);
        }
        return topics;
    }

    public int countTotalGrammarTopics() {
        String sql = "SELECT COUNT(*) FROM dbo.grammar_topics";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số chủ đề ngữ pháp", e);
        }
        return 0;
    }

    public List<GrammarTopic> getGrammarTopicsByPage(int pageNumber, int pageSize) {
        List<GrammarTopic> topics = new ArrayList<>();
        // SQL Server: cần ORDER BY trước khi OFFSET/FETCH
        String sql = "SELECT " + BASE_COLUMNS + " " +
                     "FROM dbo.grammar_topics " +
                     "ORDER BY title ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        int offset = Math.max(0, (pageNumber - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) topics.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách chủ đề ngữ pháp theo trang", e);
        }
        return topics;
    }

    private GrammarTopic mapRow(ResultSet rs) throws SQLException {
        GrammarTopic t = new GrammarTopic();
        t.setTopicId(rs.getInt("topic_id"));
        t.setTitle(rs.getString("title"));
        t.setContent(rs.getString("content"));
        t.setExampleSentences(rs.getString("example_sentences"));
        t.setDifficultyLevel(rs.getString("difficulty_level"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }
}
