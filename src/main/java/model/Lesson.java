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

public class Lesson {
    private int lessonId;
    private String title;
    private String content;
    private Timestamp createdAt;
    // Optional: Bạn có thể thêm các trường khác sau này như authorId, level, categoryId, etc.

    // Constructors
    public Lesson() {
    }

    public Lesson(int lessonId, String title, String content, Timestamp createdAt) {
        this.lessonId = lessonId;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Lesson{" +
                "lessonId=" + lessonId +
                ", title='" + title + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}