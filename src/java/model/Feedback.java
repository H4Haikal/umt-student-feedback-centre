package model;

import java.time.LocalDate;

public class Feedback {

    private String feedbackID;      // Use String to match DAO usage
    private String title;
    private String content;
    private String category;        // Category name
    private String userID;          // User who submitted
    private String authorName;      // Name of user (JOIN with user table)
    private LocalDate createdAt;
    private int upvotes;

    private String status;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ======= Constructors =======
    public Feedback() {
    }

    public Feedback(String title, String content, String category, String userID) {
        this.title = title;
        this.content = content;
        this.category = category;
        this.userID = userID;
    }

    public Feedback(String feedbackID, String title, String content, String category, String userID, LocalDate createdAt, int upvotes, String authorName) {
        this.feedbackID = feedbackID;
        this.title = title;
        this.content = content;
        this.category = category;
        this.userID = userID;
        this.createdAt = createdAt;
        this.upvotes = upvotes;
        this.authorName = authorName;
    }

    // ======= Getters and Setters =======
    public String getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(String feedbackID) {
        this.feedbackID = feedbackID;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public int getUpvotes() {
        return upvotes;
    }

    public void setUpvotes(int upvotes) {
        this.upvotes = upvotes;
    }
}
