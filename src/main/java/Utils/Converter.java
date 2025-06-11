package Utils;

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

}
