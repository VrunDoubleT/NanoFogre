package Utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class DateFormatter {
    public static String formatReadable(String isoDateTimeString) {
        LocalDateTime dateTime = LocalDateTime.parse(isoDateTimeString);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy hh:mm a");
        return dateTime.format(formatter);
    }
    
    public static String timeAgo(String isoDateTimeString) {
        LocalDateTime dateTime = LocalDateTime.parse(isoDateTimeString);
        LocalDateTime now = LocalDateTime.now();

        long years = ChronoUnit.YEARS.between(dateTime, now);
        if (years > 0) return years + (years == 1 ? " year ago" : " years ago");

        long months = ChronoUnit.MONTHS.between(dateTime, now);
        if (months > 0) return months + (months == 1 ? " month ago" : " months ago");

        long days = ChronoUnit.DAYS.between(dateTime, now);
        if (days > 0) return days + (days == 1 ? " day ago" : " days ago");

        long hours = ChronoUnit.HOURS.between(dateTime, now);
        if (hours > 0) return hours + (hours == 1 ? " hour ago" : " hours ago");

        long minutes = ChronoUnit.MINUTES.between(dateTime, now);
        if (minutes > 0) return minutes + (minutes == 1 ? " minute ago" : " minutes ago");

        return "Just now";
    }
}
