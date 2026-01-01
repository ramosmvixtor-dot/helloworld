import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class VulnerableLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        // Inyección SQL
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginQuery = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'"; // Inyección SQL

        // XSS
        String userMessage = request.getParameter("message");
        out.println("<h1>Message: " + userMessage + "</h1>"); // Vulnerabilidad XSS

        // Deserialización insegura
        try {
            ObjectInputStream in = new ObjectInputStream(request.getInputStream());
            Object userObject = in.readObject(); // Deserialización insegura
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        // Configuración insegura
        String apiKey = "12345-abcde"; // API key en texto claro

        // Fuga de información
        try {
            int result = 5 / 0; // Causa una excepción
        } catch (ArithmeticException e) {
            out.println("Caught an exception: " + e.getMessage()); // Fuga de información
            e.printStackTrace(); // Fuga de información
        }

        out.close();
    }
}
