package com.conference.model;

import java.util.Date;
import java.util.List;

public class Conference {
    private int id;
    private String name;
    private String acronym;
    private String website;
    private String type; // physical, virtual, hybrid
    private String location;
    private Date startDate;
    private Date endDate;
    private String thematic;
    private List<String> topics;
    private List<String> subTopics;
    private String logoPath;
    private Date submissionDeadline;
    private Date reviewDeadline;
    private Date notificationDeadline;
    private Date cameraReadyDeadline;

    // Constructors
    public Conference() {}

    public Conference(String name, String acronym, String website, String type, String location) {
        this.name = name;
        this.acronym = acronym;
        this.website = website;
        this.type = type;
        this.location = location;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAcronym() {
        return acronym;
    }

    public void setAcronym(String acronym) {
        this.acronym = acronym;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getThematic() {
        return thematic;
    }

    public void setThematic(String thematic) {
        this.thematic = thematic;
    }

    public List<String> getTopics() {
        return topics;
    }

    public void setTopics(List<String> topics) {
        this.topics = topics;
    }

    public List<String> getSubTopics() {
        return subTopics;
    }

    public void setSubTopics(List<String> subTopics) {
        this.subTopics = subTopics;
    }

    public String getLogoPath() {
        return logoPath;
    }

    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }

    public Date getSubmissionDeadline() {
        return submissionDeadline;
    }

    public void setSubmissionDeadline(Date submissionDeadline) {
        this.submissionDeadline = submissionDeadline;
    }

    public Date getReviewDeadline() {
        return reviewDeadline;
    }

    public void setReviewDeadline(Date reviewDeadline) {
        this.reviewDeadline = reviewDeadline;
    }

    public Date getNotificationDeadline() {
        return notificationDeadline;
    }

    public void setNotificationDeadline(Date notificationDeadline) {
        this.notificationDeadline = notificationDeadline;
    }

    public Date getCameraReadyDeadline() {
        return cameraReadyDeadline;
    }

    public void setCameraReadyDeadline(Date cameraReadyDeadline) {
        this.cameraReadyDeadline = cameraReadyDeadline;
    }

    @Override
    public String toString() {
        return "Conference{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", acronym='" + acronym + '\'' +
                ", type='" + type + '\'' +
                ", location='" + location + '\'' +
                '}';
    }
}