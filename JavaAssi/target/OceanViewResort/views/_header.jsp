<%--============================================================_header.jsp — Common navigation bar (included by all
    pages)============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="com.oceanview.model.User" %>
            <% // Retrieve logged-in user from session User currentUser=(User) session.getAttribute("loggedInUser");
                String contextPath=request.getContextPath(); // Get current servlet path to highlight active nav item
                String currentPath=request.getServletPath(); %>
                <!-- ── Navigation Bar ─────────────────────────────────────────────────── -->
                <nav class="navbar navbar-expand-lg navbar-dark">
                    <div class="container-fluid">
                        <!-- Brand -->
                        <a class="navbar-brand d-flex align-items-center" href="<%= contextPath %>/dashboard">
                            <i class="fas fa-water me-2"></i>
                            <strong>Ocean View Resort</strong>
                        </a>

                        <!-- Mobile toggle -->
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <!-- Nav links -->
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item">
                                    <a class="nav-link <%= currentPath.contains(" dashboard") ? "active" : "" %>"
                                        href="<%= contextPath %>/dashboard">
                                            <i class="fas fa-home me-1"></i>Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= currentPath.contains(" reservation") &&
                                        request.getParameter("action")==null ? "active" : "" %>"
                                        href="<%= contextPath %>/reservation">
                                            <i class="fas fa-plus-circle me-1"></i>Add Reservation
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= " view".equals(request.getParameter("action")) ? "active"
                                        : "" %>"
                                        href="<%= contextPath %>/reservation?action=view">
                                            <i class="fas fa-search me-1"></i>View Reservation
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= currentPath.contains(" bill") ? "active" : "" %>"
                                        href="<%= contextPath %>/bill">
                                            <i class="fas fa-file-invoice me-1"></i>Bill
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= currentPath.contains(" reports") ? "active" : "" %>"
                                        href="<%= contextPath %>/reports">
                                            <i class="fas fa-chart-bar me-1"></i>Reports
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= currentPath.contains(" help") ? "active" : "" %>"
                                        href="<%= contextPath %>/help">
                                            <i class="fas fa-question-circle me-1"></i>Help
                                    </a>
                                </li>
                            </ul>

                            <!-- User info & logout -->
                            <ul class="navbar-nav">
                                <li class="nav-item d-flex align-items-center me-3">
                                    <span class="text-white-50 small">
                                        <i class="fas fa-user-circle me-1"></i>
                                        <%= currentUser !=null ? currentUser.getFullName() : "Staff" %>
                                            <span class="badge ms-1 <%= " ADMIN".equals(currentUser !=null ?
                                                currentUser.getRole() : "" ) ? "bg-warning text-dark" : "bg-secondary"
                                                %>">
                                                <%= currentUser !=null ? currentUser.getRole() : "" %>
                                            </span>
                                    </span>
                                </li>
                                <li class="nav-item">
                                    <a class="btn btn-outline-light btn-sm" href="<%= contextPath %>/logout">
                                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>