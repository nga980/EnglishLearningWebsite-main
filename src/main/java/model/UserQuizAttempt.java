package model;

import java.sql.Timestamp;

public class UserQuizAttempt {
    private int attemptId;
    private int userId;
    private int quizQuestionId;
    private int selectedOptionId;
    private boolean isAnswerCorrect;
    private Timestamp attemptedAt;

    // Constructors
    public UserQuizAttempt() {
        // Constructor không tham số, bắt buộc phải có để sử dụng setter
    }
    
    // (Optional) Bạn có thể giữ lại constructor này nếu muốn
    public UserQuizAttempt(int userId, int quizQuestionId, int selectedOptionId, boolean isAnswerCorrect) {
        this.userId = userId;
        this.quizQuestionId = quizQuestionId;
        this.selectedOptionId = selectedOptionId;
        this.isAnswerCorrect = isAnswerCorrect;
    }

    // Getters and Setters
    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getQuizQuestionId() {
        return quizQuestionId;
    }

    public void setQuizQuestionId(int quizQuestionId) {
        this.quizQuestionId = quizQuestionId;
    }

    public int getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(int selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    // Đảm bảo tên getter là isAnswerCorrect() để khớp với thuộc tính
    public boolean isAnswerCorrect() {
        return isAnswerCorrect;
    }

    public void setIsAnswerCorrect(boolean isAnswerCorrect) {
        this.isAnswerCorrect = isAnswerCorrect;
    }

    public Timestamp getAttemptedAt() {
        return attemptedAt;
    }

    public void setAttemptedAt(Timestamp attemptedAt) {
        this.attemptedAt = attemptedAt;
    }
}