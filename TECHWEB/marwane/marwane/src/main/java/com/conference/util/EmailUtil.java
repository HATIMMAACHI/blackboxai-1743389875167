package com.conference.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    // Email configuration
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "conference.system@example.com";
    private static final String EMAIL_PASSWORD = "your-app-specific-password"; // Use environment variable in production

    private static Properties properties;
    private static Session session;

    static {
        properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });
    }

    // Send paper submission confirmation
    public static void sendSubmissionConfirmation(String to, String paperTitle, String submissionId) {
        String subject = "Paper Submission Confirmation";
        String content = String.format(
            "Dear Author,\n\n" +
            "Your paper titled \"%s\" has been successfully submitted.\n" +
            "Submission ID: %s\n\n" +
            "You can track the status of your submission using this ID.\n\n" +
            "Best regards,\nConference Management System",
            paperTitle, submissionId
        );
        
        sendEmail(to, subject, content);
    }

    // Send review assignment notification
    public static void sendReviewAssignment(String to, String paperTitle, String deadline) {
        String subject = "Paper Review Assignment";
        String content = String.format(
            "Dear Reviewer,\n\n" +
            "You have been assigned to review the paper:\n" +
            "Title: \"%s\"\n" +
            "Please complete your review by: %s\n\n" +
            "You can log in to the system to view the paper and submit your review.\n\n" +
            "Best regards,\nConference Management System",
            paperTitle, deadline
        );
        
        sendEmail(to, subject, content);
    }

    // Send paper acceptance notification
    public static void sendAcceptanceNotification(String to, String paperTitle, boolean isAccepted) {
        String subject = isAccepted ? "Paper Acceptance Notification" : "Paper Rejection Notification";
        String content = String.format(
            "Dear Author,\n\n" +
            "Regarding your paper titled \"%s\"\n\n" +
            "%s\n\n" +
            "Best regards,\nConference Management System",
            paperTitle,
            isAccepted ? 
                "We are pleased to inform you that your paper has been accepted for the conference." :
                "We regret to inform you that your paper was not accepted for the conference."
        );
        
        sendEmail(to, subject, content);
    }

    // Send committee invitation
    public static void sendCommitteeInvitation(String to, String conferenceName, String role) {
        String subject = "Committee Membership Invitation";
        String content = String.format(
            "Dear Colleague,\n\n" +
            "You are invited to serve as a %s member for the conference:\n" +
            "%s\n\n" +
            "Please log in to the system to accept or decline this invitation.\n\n" +
            "Best regards,\nConference Management System",
            role, conferenceName
        );
        
        sendEmail(to, subject, content);
    }

    // Send deadline reminder
    public static void sendDeadlineReminder(String to, String paperTitle, String deadline, String type) {
        String subject = String.format("%s Deadline Reminder", type);
        String content = String.format(
            "Dear User,\n\n" +
            "This is a reminder about the upcoming %s deadline for:\n" +
            "Paper: \"%s\"\n" +
            "Deadline: %s\n\n" +
            "Please ensure to complete the required actions before the deadline.\n\n" +
            "Best regards,\nConference Management System",
            type, paperTitle, deadline
        );
        
        sendEmail(to, subject, content);
    }

    // Generic method to send email
    private static void sendEmail(String to, String subject, String content) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            LOGGER.info(String.format("Email sent successfully to %s with subject: %s", to, subject));
            
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, String.format("Failed to send email to %s: %s", to, e.getMessage()), e);
            throw new RuntimeException("Failed to send email", e);
        }
    }

    // Send HTML formatted email
    public static void sendHtmlEmail(String to, String subject, String htmlContent) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            LOGGER.info(String.format("HTML email sent successfully to %s with subject: %s", to, subject));
            
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, String.format("Failed to send HTML email to %s: %s", to, e.getMessage()), e);
            throw new RuntimeException("Failed to send HTML email", e);
        }
    }

    // Send email with attachment
    public static void sendEmailWithAttachment(String to, String subject, String content, String attachmentPath) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);

            // Create the message part
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(content);

            // Create a multipart message
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            // Add attachment
            messageBodyPart = new MimeBodyPart();
          //  javax.activation.DataSource source = new javax.activation.FileDataSource(attachmentPath);
         //   messageBodyPart.setDataHandler(new DataHandler(source));
           // a voir mn b3d ok
            messageBodyPart.setFileName(attachmentPath.substring(attachmentPath.lastIndexOf("/") + 1));
            multipart.addBodyPart(messageBodyPart);

            message.setContent(multipart);

            Transport.send(message);
            LOGGER.info(String.format("Email with attachment sent successfully to %s with subject: %s", to, subject));
            
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, String.format("Failed to send email with attachment to %s: %s", to, e.getMessage()), e);
            throw new RuntimeException("Failed to send email with attachment", e);
        }
    }
}