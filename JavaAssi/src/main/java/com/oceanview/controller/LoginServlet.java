package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet - MVC Controller
 * ───────────────────────────────
 * Handles staff authentication.
 *
 * GET  /login  → Shows the login form (login.jsp)
 * POST /login  → Validates credentials, creates session, redirects to dashboard
 *
 * Design Pattern: MVC - Controller
 */
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * GET: Display the login page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If staff is already logged in, send them straight to the dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Forward to the login JSP view
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    /**
     * POST: Process the login form submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ── Basic server-side validation ────────────────────────────────────
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Username and password are required.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // ── Authenticate against the database ───────────────────────────────
        User user = userDAO.authenticate(username.trim(), password.trim());

        if (user != null) {
            // ─ Login SUCCESS: create a session and store user info ──────────
            HttpSession session = request.getSession(true);   // create new session
            session.setAttribute("loggedInUser", user);
            session.setMaxInactiveInterval(30 * 60);          // 30-minute timeout

            System.out.println("[LoginServlet] User logged in: " + user.getUsername());
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // ─ Login FAILED: show error on the login page ───────────────────
            request.setAttribute("errorMsg", "Invalid username or password. Please try again.");
            request.setAttribute("enteredUsername", username); // pre-fill the username field
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
