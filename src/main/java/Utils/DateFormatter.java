package Utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
}
