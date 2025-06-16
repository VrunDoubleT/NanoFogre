package Utils;

import java.text.DecimalFormat;
import java.text.NumberFormat;
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
    
    public static String formatVietNamCurrency(double price) {
        Locale vietnam = new Locale("vi", "VN");
        NumberFormat formatter = NumberFormat.getInstance(vietnam);
        return formatter.format(price);
    }
}
