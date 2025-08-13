package dao;

import model.Vocabulary;
import utils.DBContext;

import javax.naming.NamingException;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VocabularyDAO {
    private static final Logger LOGGER = Logger.getLogger(VocabularyDAO.class.getName());

    /* =========================
       Helpers
       ========================= */
    private Vocabulary extractVocabularyFromResultSet(ResultSet rs) throws SQLException {
        Vocabulary vocab = new Vocabulary();
        vocab.setVocabId(rs.getInt("vocab_id"));
        vocab.setWord(rs.getString("word"));
        vocab.setMeaning(rs.getString("meaning"));
        vocab.setExample(rs.getString("example"));
        // Chú ý: chỉ select image_data/audio_data ở các API cần thiết để tránh tải BLOB không cần
        try { vocab.setImageData(rs.getBytes("image_data")); } catch (SQLException ignore) {}
        try { vocab.setAudioData(rs.getBytes("audio_data")); } catch (SQLException ignore) {}

        int lessonId = rs.getInt("lesson_id");
        if (!rs.wasNull()) vocab.setLessonId(lessonId); else vocab.setLessonId(null);
        vocab.setCreatedAt(rs.getTimestamp("created_at"));
        return vocab;
    }

    private Vocabulary extractVocabularyForFlashcardView(ResultSet rs) throws SQLException {
        Vocabulary vocab = new Vocabulary();
        vocab.setVocabId(rs.getInt("vocab_id"));
        vocab.setWord(rs.getString("word"));
        vocab.setMeaning(rs.getString("meaning"));
        vocab.setExample(rs.getString("example"));
        vocab.setHasImage(rs.getBoolean("has_image"));
        vocab.setHasAudio(rs.getBoolean("has_audio"));
        int lessonId = rs.getInt("lesson_id");
        if (!rs.wasNull()) vocab.setLessonId(lessonId); else vocab.setLessonId(null);
        vocab.setCreatedAt(rs.getTimestamp("created_at"));
        return vocab;
    }

    /* =========================
       Flashcards (cờ media, không tải BLOB)
       ========================= */
    public List<Vocabulary> getVocabularyByLessonIdForFlashcards(int lessonId) {
        List<Vocabulary> list = new ArrayList<>();
        String sql =
            "SELECT vocab_id, word, meaning, [example], lesson_id, created_at, " +
            "       CAST(CASE WHEN image_data IS NOT NULL AND DATALENGTH(image_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_image, " +
            "       CAST(CASE WHEN audio_data IS NOT NULL AND DATALENGTH(audio_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_audio " +
            "FROM dbo.vocabulary WHERE lesson_id = ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractVocabularyForFlashcardView(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab (flashcards) theo lesson_id=" + lessonId, e);
        }
        return list;
    }

    public List<Vocabulary> getAllVocabularyForFlashcards() {
        List<Vocabulary> list = new ArrayList<>();
        String sql =
            "SELECT vocab_id, word, meaning, [example], lesson_id, created_at, " +
            "       CAST(CASE WHEN image_data IS NOT NULL AND DATALENGTH(image_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_image, " +
            "       CAST(CASE WHEN audio_data IS NOT NULL AND DATALENGTH(audio_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_audio " +
            "FROM dbo.vocabulary ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extractVocabularyForFlashcardView(rs));
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy toàn bộ vocab (flashcards)", e);
        }
        return list;
    }

    /* =========================
       CRUD (đầy đủ trường)
       ========================= */
    public List<Vocabulary> getVocabularyByLessonId(int lessonId) {
        List<Vocabulary> list = new ArrayList<>();
        String sql = "SELECT vocab_id, word, meaning, [example], image_data, audio_data, lesson_id, created_at " +
                     "FROM dbo.vocabulary WHERE lesson_id = ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractVocabularyFromResultSet(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab đầy đủ theo lesson_id=" + lessonId, e);
        }
        return list;
    }

    public Vocabulary getVocabularyById(int vocabId) {
        String sql = "SELECT vocab_id, word, meaning, [example], image_data, audio_data, lesson_id, created_at " +
                     "FROM dbo.vocabulary WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vocabId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractVocabularyFromResultSet(rs);
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab theo id=" + vocabId, e);
        }
        return null;
    }

    public boolean addVocabulary(Vocabulary vocab) {
        // created_at để DB tự set DEFAULT -> không truyền
        String sql = "INSERT INTO dbo.vocabulary (word, meaning, [example], image_data, audio_data, lesson_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());
            ps.setBytes(4, vocab.getImageData());
            ps.setBytes(5, vocab.getAudioData());
            if (vocab.getLessonId() != null) ps.setInt(6, vocab.getLessonId()); else ps.setNull(6, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm vocab: " + vocab.getWord(), e);
            return false;
        }
    }

    public boolean updateVocabulary(Vocabulary vocab) {
        String sql = "UPDATE dbo.vocabulary SET word = ?, meaning = ?, [example] = ?, image_data = ?, audio_data = ?, lesson_id = ? " +
                     "WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());
            ps.setBytes(4, vocab.getImageData());
            ps.setBytes(5, vocab.getAudioData());
            if (vocab.getLessonId() != null) ps.setInt(6, vocab.getLessonId()); else ps.setNull(6, Types.INTEGER);
            ps.setInt(7, vocab.getVocabId());
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật vocab_id=" + vocab.getVocabId(), e);
            return false;
        }
    }

    public boolean deleteVocabulary(int vocabId) {
        String sql = "DELETE FROM dbo.vocabulary WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vocabId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa vocab_id=" + vocabId, e);
            return false;
        }
    }

    public List<Vocabulary> searchVocabulary(String keyword) {
        List<Vocabulary> list = new ArrayList<>();
        String sql = "SELECT vocab_id, word, meaning, [example], image_data, audio_data, lesson_id, created_at " +
                     "FROM dbo.vocabulary " +
                     "WHERE word LIKE ? OR meaning LIKE ? " +
                     "ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + (keyword == null ? "" : keyword) + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractVocabularyFromResultSet(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm vocab với từ khóa: " + keyword, e);
        }
        return list;
    }

    public int countTotalVocabulary() {
        String sql = "SELECT COUNT(*) FROM dbo.vocabulary";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số vocab", e);
            return 0;
        }
    }

    /* =========================
       Phân trang
       ========================= */
    public List<Vocabulary> getVocabularyByPage(int pageNumber, int pageSize) {
        List<Vocabulary> list = new ArrayList<>();
        String sql = "SELECT vocab_id, word, meaning, [example], image_data, audio_data, lesson_id, created_at " +
                     "FROM dbo.vocabulary " +
                     "ORDER BY word ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        int offset = Math.max(0, (pageNumber - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractVocabularyFromResultSet(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab theo trang", e);
        }
        return list;
    }

    public List<Vocabulary> getVocabularyByPageForFlashcards(int pageNumber, int pageSize) {
        List<Vocabulary> list = new ArrayList<>();
        String sql =
            "SELECT vocab_id, word, meaning, [example], lesson_id, created_at, " +
            "       CAST(CASE WHEN image_data IS NOT NULL AND DATALENGTH(image_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_image, " +
            "       CAST(CASE WHEN audio_data IS NOT NULL AND DATALENGTH(audio_data) > 0 THEN 1 ELSE 0 END AS BIT) AS has_audio " +
            "FROM dbo.vocabulary " +
            "ORDER BY word ASC " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        int offset = Math.max(0, (pageNumber - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractVocabularyForFlashcardView(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab (flashcards) theo trang", e);
        }
        return list;
    }

    /* =========================
       Thống kê
       ========================= */
    public Map<String, Integer> getMonthlyVocabularyGrowth(int lastMonths) {
        Map<String, Integer> monthly = new LinkedHashMap<>();
        String sql =
            "SELECT YEAR(created_at) AS [year], MONTH(created_at) AS [month], COUNT(vocab_id) AS [count] " +
            "FROM dbo.vocabulary " +
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
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy tăng trưởng vocab hàng tháng", e);
        }
        return monthly;
    }

    /* =========================
       Game nối từ (có thể kèm BLOB)
       ========================= */
    public List<Vocabulary> getAllVocabularyForMatchingGame(Integer lessonId) {
        List<Vocabulary> list = new ArrayList<>();
        String sql;
        try (Connection conn = DBContext.getConnection()) {
            if (lessonId != null && lessonId > 0) {
                sql = "SELECT vocab_id, word, meaning, image_data, audio_data, lesson_id " +
                      "FROM dbo.vocabulary " +
                      "WHERE lesson_id = ? AND meaning IS NOT NULL AND LTRIM(RTRIM(meaning)) <> ''";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, lessonId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) list.add(mapForGame(rs));
                    }
                }
            } else if (lessonId != null && lessonId == 0) {
                sql = "SELECT vocab_id, word, meaning, image_data, audio_data, lesson_id " +
                      "FROM dbo.vocabulary " +
                      "WHERE lesson_id IS NULL AND meaning IS NOT NULL AND LTRIM(RTRIM(meaning)) <> ''";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(mapForGame(rs));
                }
            } else {
                sql = "SELECT vocab_id, word, meaning, image_data, audio_data, lesson_id " +
                      "FROM dbo.vocabulary " +
                      "WHERE meaning IS NOT NULL AND LTRIM(RTRIM(meaning)) <> ''";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(mapForGame(rs));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy vocab cho game nối từ. lessonId=" + lessonId, e);
        }
        return list;
    }

    private Vocabulary mapForGame(ResultSet rs) throws SQLException {
        Vocabulary v = new Vocabulary();
        v.setVocabId(rs.getInt("vocab_id"));
        v.setWord(rs.getString("word"));
        v.setMeaning(rs.getString("meaning"));
        v.setImageData(rs.getBytes("image_data"));
        v.setAudioData(rs.getBytes("audio_data"));
        int l = rs.getInt("lesson_id");
        if (!rs.wasNull()) v.setLessonId(l); else v.setLessonId(null);
        return v;
    }
}
