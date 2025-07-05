package Utils;

import jakarta.servlet.http.Part;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Common {

    public static List<Part> extractImageParts(Collection<Part> parts, String inputName) {
        List<Part> imageParts = new ArrayList<>();
        for (Part part : parts) {
            if (inputName.equals(part.getName())
                    && part.getSize() > 0
                    && part.getSubmittedFileName() != null) {
                imageParts.add(part);
            }
        }
        return imageParts;
    }
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}


