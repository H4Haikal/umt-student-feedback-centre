package model;

public class FeedbackCategory {

    private int categoryID;      // primary key
    private String name;         // category name (used in feedback.category)
    private String description;  // optional description

    public FeedbackCategory() {
    }

    public FeedbackCategory(int categoryID, String name, String description) {
        this.categoryID = categoryID;
        this.name = name;
        this.description = description;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Optional: for displaying in dropdowns
    @Override
    public String toString() {
        return name;
    }
}
