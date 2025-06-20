package model;

import java.sql.Timestamp;

public class QuizHistoryItem {
    private int lessonId;
    private String lessonTitle;
    private int score;
    private int totalQuestions;
    private Timestamp attemptedAt;

    // Constructors, Getters, and Setters
    public QuizHistoryItem() {}

    public int getLessonId() { return lessonId; }
    public void setLessonId(int lessonId) { this.lessonId = lessonId; }
    public String getLessonTitle() { return lessonTitle; }
    public void setLessonTitle(String lessonTitle) { this.lessonTitle = lessonTitle; }
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }
    public Timestamp getAttemptedAt() { return attemptedAt; }
    public void setAttemptedAt(Timestamp attemptedAt) { this.attemptedAt = attemptedAt; }
}