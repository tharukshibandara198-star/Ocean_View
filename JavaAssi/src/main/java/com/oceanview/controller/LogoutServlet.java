package com.oceanview.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LogoutServlet - MVC Controller
 * ────────────────────────────────
 * Safely destroys the HTTP session and redirects to the login page.
 *
 * GET /logout → Invalidate session → Redirect to /login
 *
 * Design Pattern: MVC - Controller
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the existing session (don't create a new one if it doesn't exist)
        HttpSession session = request.getSession(false);

        if (session != null) {
            String username = "";
            if (session.getAttribute("loggedInUser") != null) {
                username = ((com.oceanview.model.User) session.getAttribute("loggedInUser")).getUsername();
            }
            session.invalidate();   // Destroy the session and all its attributes
            System.out.println("[LogoutServlet] User logged out: " + username);
        }

        // Redirect back to the login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
