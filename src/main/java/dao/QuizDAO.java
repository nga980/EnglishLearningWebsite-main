package dao;

import model.QuizOption;
import model.QuizQuestion;
import model.GrammarExerciseHistoryItem;
import model.QuizHistoryItem;
import model.UserQuizAttempt;
import utils.DBContext;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuizDAO {
    private static final Logger LOGGER = Logger.getLogger(QuizDAO.class.getName());

    /* =========================
       Helpers
       ========================= */

    /** Map 1 dòng ResultSet -> QuizQuestion (không gắn options). */
    private QuizQuestion mapQuestionRow(ResultSet rs) throws SQLException {
        QuizQuestion q = new QuizQuestion();
        q.setQuestionId(rs.getInt("question_id"));
        q.setLessonId(rs.getInt("lesson_id"));
        // cột grammar_topic_id có thể NULL
        try { q.setGrammarTopicId(rs.getInt("grammar_topic_id")); } catch (SQLException ignore) {}
        q.setQuestionText(rs.getString("question_text"));
        return q;
    }

    /** Lấy các lựa chọn cho 1 questionId, tái dùng cùng Connection. */
    private List<QuizOption> getOptionsForQuestion(Connection conn, int questionId) throws SQLException {
        List<QuizOption> options = new ArrayList<>();
        String sql = "SELECT option_id, question_id, option_text, is_correct " +
                     "FROM dbo.quiz_options WHERE question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizOption o = new QuizOption();
                    o.setOptionId(rs.getInt("option_id"));
                    o.setQuestionId(rs.getInt("question_id"));
                    o.setOptionText(rs.getString("option_text"));
                    o.setIsCorrect(rs.getBoolean("is_correct")); // SQL Server BIT -> boolean OK
                    options.add(o);
                }
            }
        }
        return options;
    }

    /* =========================
       Queries theo Lesson / Topic
       ========================= */

    public List<QuizQuestion> getQuestionsByLessonId(int lessonId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT question_id, lesson_id, grammar_topic_id, question_text " +
                     "FROM dbo.quiz_questions WHERE lesson_id = ? ORDER BY question_id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = mapQuestionRow(rs);
                    q.setOptions(getOptionsForQuestion(conn, q.getQuestionId()));
                    questions.add(q);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi cho lesson ID: " + lessonId, e);
        }
        return questions;
    }

    public List<QuizQuestion> getQuestionsByGrammarTopicId(int grammarTopicId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT question_id, lesson_id, grammar_topic_id, question_text " +
                     "FROM dbo.quiz_questions WHERE grammar_topic_id = ? ORDER BY question_id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, grammarTopicId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = mapQuestionRow(rs);
                    q.setOptions(getOptionsForQuestion(conn, q.getQuestionId()));
                    questions.add(q);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi cho grammar_topic_id: " + grammarTopicId, e);
        }
        return questions;
    }

    public QuizQuestion getQuestionById(int questionId) {
        String sql = "SELECT question_id, lesson_id, grammar_topic_id, question_text " +
                     "FROM dbo.quiz_questions WHERE question_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    QuizQuestion q = mapQuestionRow(rs);
                    q.setOptions(getOptionsForQuestion(conn, q.getQuestionId()));
                    return q;
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi ID: " + questionId, e);
        }
        return null;
    }

    /* =========================
       Thêm / Sửa / Xóa câu hỏi & options
       ========================= */

    public boolean addQuestionWithOptions(QuizQuestion question) {
        String insertQ = "INSERT INTO dbo.quiz_questions (lesson_id, grammar_topic_id, question_text) " +
                         "VALUES (?, ?, ?)";
        String insertOpt = "INSERT INTO dbo.quiz_options (question_id, option_text, is_correct) " +
                           "VALUES (?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psQ = conn.prepareStatement(insertQ, Statement.RETURN_GENERATED_KEYS)) {
                psQ.setInt(1, question.getLessonId());
                // grammar_topic_id có thể null: dùng setObject
                if (question.getGrammarTopicId() == 0) psQ.setNull(2, Types.INTEGER);
                else psQ.setInt(2, question.getGrammarTopicId());
                psQ.setString(3, question.getQuestionText());
                psQ.executeUpdate();

                try (ResultSet keys = psQ.getGeneratedKeys()) {
                    if (keys.next()) {
                        int newQid = keys.getInt(1);
                        question.setQuestionId(newQid);

                        if (question.getOptions() != null && !question.getOptions().isEmpty()) {
                            try (PreparedStatement psO = conn.prepareStatement(insertOpt)) {
                                for (QuizOption o : question.getOptions()) {
                                    psO.setInt(1, newQid);
                                    psO.setString(2, o.getOptionText());
                                    psO.setBoolean(3, o.isIsCorrect());
                                    psO.addBatch();
                                }
                                psO.executeBatch();
                            }
                        }
                    } else {
                        throw new SQLException("Không nhận được question_id sau khi INSERT quiz_questions.");
                    }
                }
            }

            conn.commit();
            LOGGER.log(Level.INFO, "Thêm câu hỏi + options thành công. lesson_id={0}, grammar_topic_id={1}",
                    new Object[]{question.getLessonId(), question.getGrammarTopicId()});
            return true;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm câu hỏi & options. Rollback.", e);
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback fail", ex); }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Close fail", ex); }
        }
        return false;
    }

    public boolean addQuestionForGrammar(QuizQuestion question) {
        // alias cho case chỉ có grammar_topic_id
        return addQuestionWithOptions(question);
    }

    public boolean updateQuestionWithOptions(QuizQuestion question) {
        String updateQ = "UPDATE dbo.quiz_questions SET question_text = ? WHERE question_id = ?";
        String updateOpt = "UPDATE dbo.quiz_options SET option_text = ?, is_correct = ? WHERE option_id = ?";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psQ = conn.prepareStatement(updateQ)) {
                psQ.setString(1, question.getQuestionText());
                psQ.setInt(2, question.getQuestionId());
                psQ.executeUpdate();
            }

            if (question.getOptions() != null && !question.getOptions().isEmpty()) {
                try (PreparedStatement psO = conn.prepareStatement(updateOpt)) {
                    for (QuizOption o : question.getOptions()) {
                        psO.setString(1, o.getOptionText());
                        psO.setBoolean(2, o.isIsCorrect());
                        psO.setInt(3, o.getOptionId());
                        psO.addBatch();
                    }
                    psO.executeBatch();
                }
            }

            conn.commit();
            LOGGER.log(Level.INFO, "Cập nhật câu hỏi & options OK. question_id={0}", question.getQuestionId());
            return true;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật câu hỏi & options. Rollback.", e);
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback fail", ex); }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Close fail", ex); }
        }
        return false;
    }

    public boolean deleteQuestion(int questionId) {
        String sql = "DELETE FROM dbo.quiz_questions WHERE question_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa câu hỏi ID: " + questionId, e);
        }
        return false;
    }

    /* =========================
       Lịch sử làm bài / Attempt
       ========================= */

    public boolean saveUserAttempt(UserQuizAttempt attempt) {
        String sql = "INSERT INTO dbo.user_quiz_attempts " +
                     "(user_id, quiz_question_id, selected_option_id, is_answer_correct, attempted_at) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attempt.getUserId());
            ps.setInt(2, attempt.getQuizQuestionId());
            ps.setInt(3, attempt.getSelectedOptionId());
            ps.setBoolean(4, attempt.isAnswerCorrect());
            // Có thể để DB tự set DEFAULT GETDATE() nếu muốn; ở đây set từ app:
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu attempt user_id=" + attempt.getUserId(), e);
        }
        return false;
    }

    public List<QuizHistoryItem> getQuizHistoryForUser(int userId) {
        List<QuizHistoryItem> history = new ArrayList<>();
        String sql =
            "SELECT l.lesson_id, l.title AS lesson_title, a.attempted_at, " +
            "       SUM(CASE WHEN a.is_answer_correct = 1 THEN 1 ELSE 0 END) AS score, " +
            "       COUNT(a.quiz_question_id) AS total_questions " +
            "FROM dbo.user_quiz_attempts a " +
            "JOIN dbo.quiz_questions q ON a.quiz_question_id = q.question_id " +
            "JOIN dbo.lessons l ON q.lesson_id = l.lesson_id " +
            "WHERE a.user_id = ? " +
            "GROUP BY l.lesson_id, l.title, a.attempted_at " +
            "ORDER BY a.attempted_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizHistoryItem item = new QuizHistoryItem();
                    item.setLessonId(rs.getInt("lesson_id"));
                    item.setLessonTitle(rs.getString("lesson_title"));
                    item.setScore(rs.getInt("score"));
                    item.setTotalQuestions(rs.getInt("total_questions"));
                    item.setAttemptedAt(rs.getTimestamp("attempted_at"));
                    history.add(item);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử quiz cho user_id=" + userId, e);
        }
        return history;
    }

    public List<GrammarExerciseHistoryItem> getGrammarExerciseHistoryForUser(int userId) {
        List<GrammarExerciseHistoryItem> history = new ArrayList<>();
        String sql =
            "SELECT gt.topic_id, gt.title AS topic_title, a.attempted_at, " +
            "       SUM(CASE WHEN a.is_answer_correct = 1 THEN 1 ELSE 0 END) AS score, " +
            "       COUNT(a.quiz_question_id) AS total_questions " +
            "FROM dbo.user_quiz_attempts a " +
            "JOIN dbo.quiz_questions q ON a.quiz_question_id = q.question_id " +
            "JOIN dbo.grammar_topics gt ON q.grammar_topic_id = gt.topic_id " +
            "WHERE a.user_id = ? " +
            "GROUP BY gt.topic_id, gt.title, a.attempted_at " +
            "ORDER BY a.attempted_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GrammarExerciseHistoryItem item = new GrammarExerciseHistoryItem();
                    item.setTopicId(rs.getInt("topic_id"));
                    item.setTopicTitle(rs.getString("topic_title"));
                    item.setScore(rs.getInt("score"));
                    item.setTotalQuestions(rs.getInt("total_questions"));
                    item.setAttemptedAt(rs.getTimestamp("attempted_at"));
                    history.add(item);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử grammar cho user_id=" + userId, e);
        }
        return history;
    }
}
