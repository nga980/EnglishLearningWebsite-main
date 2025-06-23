package dao; 

import model.GrammarTopic;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException; // Thêm import này

public class GrammarTopicDAO {
    private static final Logger LOGGER = Logger.getLogger(GrammarTopicDAO.class.getName());

    public List<GrammarTopic> getAllGrammarTopics() {
        List<GrammarTopic> topics = new ArrayList<>();
        String query = "SELECT topic_id, title, content, example_sentences, difficulty_level, created_at FROM grammar_topics ORDER BY title ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                GrammarTopic topic = new GrammarTopic();
                topic.setTopicId(rs.getInt("topic_id"));
                topic.setTitle(rs.getString("title"));
                topic.setContent(rs.getString("content"));
                topic.setExampleSentences(rs.getString("example_sentences"));
                topic.setDifficultyLevel(rs.getString("difficulty_level"));
                topic.setCreatedAt(rs.getTimestamp("created_at"));
                topics.add(topic);
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách chủ đề ngữ pháp", e);
        }
        return topics;
    }

    public GrammarTopic getGrammarTopicById(int topicId) {
        String query = "SELECT topic_id, title, content, example_sentences, difficulty_level, created_at FROM grammar_topics WHERE topic_id = ?";
        GrammarTopic topic = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, topicId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    topic = new GrammarTopic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTitle(rs.getString("title"));
                    topic.setContent(rs.getString("content"));
                    topic.setExampleSentences(rs.getString("example_sentences"));
                    topic.setDifficultyLevel(rs.getString("difficulty_level"));
                    topic.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy chủ đề ngữ pháp với ID: " + topicId, e);
        }
        return topic;
    }

    public boolean addGrammarTopic(GrammarTopic topic) {
        String query = "INSERT INTO grammar_topics (title, content, example_sentences, difficulty_level, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, topic.getTitle());
            ps.setString(2, topic.getContent());
            ps.setString(3, topic.getExampleSentences());
            ps.setString(4, topic.getDifficultyLevel());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        topic.setTopicId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm chủ đề ngữ pháp: " + topic.getTitle(), e);
        }
        return false;
    }

    public boolean updateGrammarTopic(GrammarTopic topic) {
        String query = "UPDATE grammar_topics SET title = ?, content = ?, example_sentences = ?, difficulty_level = ? WHERE topic_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, topic.getTitle());
            ps.setString(2, topic.getContent());
            ps.setString(3, topic.getExampleSentences());
            ps.setString(4, topic.getDifficultyLevel());
            ps.setInt(5, topic.getTopicId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật chủ đề ngữ pháp ID: " + topic.getTopicId(), e);
        }
        return false;
    }

    public boolean deleteGrammarTopic(int topicId) {
        String query = "DELETE FROM grammar_topics WHERE topic_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, topicId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa chủ đề ngữ pháp ID: " + topicId, e);
        }
        return false;
    }
    
    public List<GrammarTopic> searchGrammarTopics(String keyword) {
        List<GrammarTopic> topics = new ArrayList<>();
        String query = "SELECT * FROM grammar_topics WHERE title LIKE ? ORDER BY title ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GrammarTopic topic = new GrammarTopic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTitle(rs.getString("title"));
                    topic.setContent(rs.getString("content"));
                    topic.setExampleSentences(rs.getString("example_sentences"));
                    topic.setDifficultyLevel(rs.getString("difficulty_level"));
                    topic.setCreatedAt(rs.getTimestamp("created_at"));
                    topics.add(topic);
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm ngữ pháp với từ khóa: " + keyword, e);
        }
        return topics;
    }
    
    public int countTotalGrammarTopics() {
        String query = "SELECT COUNT(*) FROM grammar_topics";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số chủ đề ngữ pháp", e);
        }
        return 0;
    }

    public List<GrammarTopic> getGrammarTopicsByPage(int pageNumber, int pageSize) {
        List<GrammarTopic> topics = new ArrayList<>();
        String query = "SELECT * FROM grammar_topics ORDER BY title ASC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GrammarTopic topic = new GrammarTopic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTitle(rs.getString("title"));
                    topic.setDifficultyLevel(rs.getString("difficulty_level"));
                    topic.setCreatedAt(rs.getTimestamp("created_at"));
                    topics.add(topic);
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách chủ đề ngữ pháp theo trang", e);
        }
        return topics;
    }
}