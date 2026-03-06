package com.oceanview.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * HelpServlet - MVC Controller
 * ──────────────────────────────
 * Simple controller that forwards to the help/user guide JSP page.
 * Only accessible when the user is logged in.
 *
 * GET /help → Forward to help.jsp
 *
 * Design Pattern: MVC - Controller
 */
public class HelpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Security check ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/help.jsp").forward(request, response);
    }
}
