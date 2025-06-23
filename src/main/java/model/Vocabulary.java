package model;

import java.sql.Timestamp;

public class Vocabulary {
    private int vocabId;
    private String word;
    private String meaning;
    private String example;
    private Integer lessonId;
    private String imageUrl; // Thêm mới
    private String audioUrl; // Thêm mới
    private Timestamp createdAt;

    public Vocabulary() {
    }

    // Cập nhật Constructor để bao gồm các trường mới
    public Vocabulary(int vocabId, String word, String meaning, String example, Integer lessonId, String imageUrl, String audioUrl, Timestamp createdAt) {
        this.vocabId = vocabId;
        this.word = word;
        this.meaning = meaning;
        this.example = example;
        this.lessonId = lessonId;
        this.imageUrl = imageUrl;
        this.audioUrl = audioUrl;
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
    
    // Getters và Setters cho các trường mới
    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Cập nhật toString
    @Override
    public String toString() {
        return "Vocabulary{" +
                "vocabId=" + vocabId +
                ", word='" + word + '\'' +
                ", meaning='" + meaning + '\'' +
                ", example='" + example + '\'' +
                ", lessonId=" + lessonId +
                ", imageUrl='" + imageUrl + '\'' +
                ", audioUrl='" + audioUrl + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}