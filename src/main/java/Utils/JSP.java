package Utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class JSP {
    public static String renderJSPToString(HttpServletRequest request, HttpServletResponse response, String jspPath)
            throws ServletException, IOException {
        final StringWriter stringWriter = new StringWriter();
        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            private final PrintWriter writer = new PrintWriter(stringWriter);
            @Override
            public PrintWriter getWriter() {
                return writer;
            }
        };

        request.getRequestDispatcher(jspPath).include(request, responseWrapper);
        return stringWriter.toString();
    }
}
