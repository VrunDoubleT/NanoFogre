package Utils;

import jakarta.servlet.http.Part;
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

}
