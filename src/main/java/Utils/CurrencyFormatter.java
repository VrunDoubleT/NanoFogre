package Utils;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class CurrencyFormatter {
    public static String formatCurrencyShort(double amount) {
        if (amount >= 1_000_000_000) {
            return String.format("%.2fB", amount / 1_000_000_000);
        } else if (amount >= 1_000_000) {
            return String.format("%.2fM", amount / 1_000_000);
        } else if (amount >= 1_000) {
            return String.format("%.2fK", amount / 1_000);
        } else {
            return String.format("%.0f", amount); // giữ nguyên không làm tròn lẻ
        }
    }
}
