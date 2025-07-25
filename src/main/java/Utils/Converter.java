package Utils;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.util.Locale;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Converter {

    public static int parseOption(String str, int min) {
        try {
            int value = Integer.parseInt(str);
            return value > min ? value : min;
        } catch (NumberFormatException | NullPointerException e) {
            return min;
        }
    }

    public static String formatPrice(double price) {
        if (price == (long) price) {
            return String.format("%d", (long) price);
        } else {
            DecimalFormat df = new DecimalFormat("#.##");
            return df.format(price);
        }
    }

    public static double parseDouble(String val, double defaultValue) {
        try {
            return Double.parseDouble(val);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static int parseInt(String val, int defaultValue) {
        try {
            return Integer.parseInt(val);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static LocalDateTime parseLocalDateTime(String input) {
        try {
            return LocalDateTime.parse(input);
        } catch (Exception e) {
            return null;
        }
    }

    public static Double parseNullableDouble(String input) {
        try {
            return (input != null && !input.trim().isEmpty()) ? Double.parseDouble(input.trim()) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Integer parseNullableInt(String input) {
        try {
            return (input != null && !input.trim().isEmpty()) ? Integer.parseInt(input.trim()) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

}
