/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
import java.sql.Timestamp;

public class GrammarTopic {
    private int topicId;
    private String title;
    private String content;
    private String exampleSentences;
    private String difficultyLevel;
    private Timestamp createdAt;

    // Constructors
    public GrammarTopic() {
    }

    public GrammarTopic(int topicId, String title, String content, String exampleSentences, String difficultyLevel, Timestamp createdAt) {
        this.topicId = topicId;
        this.title = title;
        this.content = content;
        this.exampleSentences = exampleSentences;
        this.difficultyLevel = difficultyLevel;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getExampleSentences() {
        return exampleSentences;
    }

    public void setExampleSentences(String exampleSentences) {
        this.exampleSentences = exampleSentences;
    }

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "GrammarTopic{" +
                "topicId=" + topicId +
                ", title='" + title + '\'' +
                ", difficultyLevel='" + difficultyLevel + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
