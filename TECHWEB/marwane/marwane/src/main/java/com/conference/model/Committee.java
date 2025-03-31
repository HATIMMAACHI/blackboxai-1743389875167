package com.conference.model;

import java.util.ArrayList;
import java.util.List;

public class Committee {
    private int id;
    private int conferenceId;
    private String type; // SC or PC
    private Member chair;
    private List<Member> members;
    
    // Inner class for Committee Member with additional properties
    public static class Member {
        private int id;
        private int userId;
        private String role; // CHAIR, MEMBER
        private int assignedPapers;
        private int completedReviews;
        private double participationRate;
        private String expertise;
        private boolean isActive;

        // Constructors
        public Member() {
            this.assignedPapers = 0;
            this.completedReviews = 0;
            this.participationRate = 0.0;
            this.isActive = true;
        }

        public Member(int userId, String role) {
            this();
            this.userId = userId;
            this.role = role;
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }

        public int getAssignedPapers() {
            return assignedPapers;
        }

        public void setAssignedPapers(int assignedPapers) {
            this.assignedPapers = assignedPapers;
            updateParticipationRate();
        }

        public int getCompletedReviews() {
            return completedReviews;
        }

        public void setCompletedReviews(int completedReviews) {
            this.completedReviews = completedReviews;
            updateParticipationRate();
        }

        public double getParticipationRate() {
            return participationRate;
        }

        private void updateParticipationRate() {
            if (assignedPapers > 0) {
                this.participationRate = (double) completedReviews / assignedPapers * 100;
            }
        }

        public String getExpertise() {
            return expertise;
        }

        public void setExpertise(String expertise) {
            this.expertise = expertise;
        }

        public boolean isActive() {
            return isActive;
        }

        public void setActive(boolean active) {
            isActive = active;
        }
    }

    // Constructors
    public Committee() {
        this.members = new ArrayList<>();
    }

    public Committee(int conferenceId, String type) {
        this();
        this.conferenceId = conferenceId;
        this.type = type;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getConferenceId() {
        return conferenceId;
    }

    public void setConferenceId(int conferenceId) {
        this.conferenceId = conferenceId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        if (type != null && (type.equals("SC") || type.equals("PC"))) {
            this.type = type;
        } else {
            throw new IllegalArgumentException("Committee type must be either 'SC' or 'PC'");
        }
    }

    public Member getChair() {
        return chair;
    }

    public void setChair(Member chair) {
        if (chair != null) {
            chair.setRole("CHAIR");
            this.chair = chair;
        }
    }

    public List<Member> getMembers() {
        return members;
    }

    public void setMembers(List<Member> members) {
        this.members = members;
    }

    // Committee Management Methods
    public void addMember(Member member) {
        if (member != null) {
            if (member.getRole() == null || member.getRole().isEmpty()) {
                member.setRole("MEMBER");
            }
            this.members.add(member);
        }
    }

    public boolean removeMember(int memberId) {
        return members.removeIf(member -> member.getId() == memberId);
    }

    public Member getMemberById(int memberId) {
        return members.stream()
                     .filter(member -> member.getId() == memberId)
                     .findFirst()
                     .orElse(null);
    }

    public List<Member> getActiveMembers() {
        List<Member> activeMembers = new ArrayList<>();
        for (Member member : members) {
            if (member.isActive()) {
                activeMembers.add(member);
            }
        }
        return activeMembers;
    }

    // Statistics Methods
    public double getOverallParticipationRate() {
        if (members.isEmpty()) {
            return 0.0;
        }
        double totalRate = 0.0;
        for (Member member : members) {
            totalRate += member.getParticipationRate();
        }
        return totalRate / members.size();
    }

    @Override
    public String toString() {
        return "Committee{" +
                "id=" + id +
                ", conferenceId=" + conferenceId +
                ", type='" + type + '\'' +
                ", membersCount=" + members.size() +
                ", participationRate=" + String.format("%.2f%%", getOverallParticipationRate()) +
                '}';
    }
}