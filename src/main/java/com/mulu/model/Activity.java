package com.mulu.model;

/**
 * Activity — one of the four experiences shown on /activities.
 */
public class Activity {
    private int id;
    private String name;
    private String description;
    private String imagePath;
    private int sortOrder;

    public Activity() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
}