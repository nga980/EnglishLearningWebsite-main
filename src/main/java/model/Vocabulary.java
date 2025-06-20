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

public class Vocabulary {
    private int vocabId;
    private String word;
    private String meaning; // Nghĩa của từ
    private String example; // Ví dụ câu
    private Integer lessonId; // ID của bài học liên quan (có thể null)
    private Timestamp createdAt;

    // Các trường tùy chọn có thể thêm sau này:
    // private String pronunciationIPA; // Phiên âm IPA
    // private String audioUrl; // Đường dẫn file âm thanh phát âm
    // private String imageUrl; // Đường dẫn hình ảnh minh họa

    // Constructors
    public Vocabulary() {
    }

    public Vocabulary(int vocabId, String word, String meaning, String example, Integer lessonId, Timestamp createdAt) {
        this.vocabId = vocabId;
        this.word = word;
        this.meaning = meaning;
        this.example = example;
        this.lessonId = lessonId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getVocabId() {
        return vocabId;
    }

    public void setVocabId(int vocabId) {
        this.vocabId = vocabId;
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public String getMeaning() {
        return meaning;
    }

    public void setMeaning(String meaning) {
        this.meaning = meaning;
    }

    public String getExample() {
        return example;
    }

    public void setExample(String example) {
        this.example = example;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // toString (tùy chọn)
    @Override
    public String toString() {
        return "Vocabulary{" +
                "vocabId=" + vocabId +
                ", word='" + word + '\'' +
                ", meaning='" + meaning + '\'' +
                ", example='" + example + '\'' +
                ", lessonId=" + lessonId +
                ", createdAt=" + createdAt +
                '}';
    }
}