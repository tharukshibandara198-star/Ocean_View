<%--============================================================dashboard.jsp — Main Dashboard (Reservation
    List)============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.oceanview.model.Reservation" %>
                <%@ page import="com.oceanview.model.User" %>
                    <%-- Session guard --%>
                        <% if (session.getAttribute("loggedInUser")==null) {
                            response.sendRedirect(request.getContextPath() + "/login" ); return; } User
                            currentUser=(User) session.getAttribute("loggedInUser"); List<Reservation> reservations =
                            (List<Reservation>) request.getAttribute("reservations");
                                %>
                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Dashboard — Ocean View Resort</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <link
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                                        rel="stylesheet">
                                    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
                                </head>

                                <body class="d-flex flex-column min-vh-100">

                                    <%-- Include navigation bar --%>
                                        <jsp:include page="_header.jsp" />

                                        <main class="container-fluid py-4 flex-grow-1">

                                            <!-- ── Welcome banner ───────────────────────────────────── -->
                                            <div class="welcome-banner rounded-4 p-4 mb-4">
                                                <div class="row align-items-center">
                                                    <div class="col">
                                                        <h2 class="mb-1">
                                                            <i class="fas fa-umbrella-beach me-2"></i>
                                                            Welcome back, <%= currentUser.getFullName() %>!
                                                        </h2>
                                                        <p class="mb-0 text-white-75">Manage reservations for Ocean View
                                                            Resort</p>
                                                    </div>
                                                    <div class="col-auto">
                                                        <a href="<%= request.getContextPath() %>/reservation"
                                                            class="btn btn-light btn-lg">
                                                            <i class="fas fa-plus me-2"></i>New Reservation
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- ── Quick action cards ────────────────────────────────── -->
                                            <div class="row g-3 mb-4">
                                                <div class="col-6 col-md-3">
                                                    <a href="<%= request.getContextPath() %>/reservation"
                                                        class="text-decoration-none">
                                                        <div class="action-card card text-center p-3 h-100">
                                                            <i class="fas fa-plus-circle fa-2x mb-2 text-primary"></i>
                                                            <div class="fw-semibold">Add Reservation</div>
                                                        </div>
                                                    </a>
                                                </div>
                                                <div class="col-6 col-md-3">
                                                    <a href="<%= request.getContextPath() %>/reservation?action=view"
                                                        class="text-decoration-none">
                                                        <div class="action-card card text-center p-3 h-100">
                                                            <i class="fas fa-search fa-2x mb-2 text-success"></i>
                                                            <div class="fw-semibold">View Reservation</div>
                                                        </div>
                                                    </a>
                                                </div>
                                                <div class="col-6 col-md-3">
                                                    <a href="<%= request.getContextPath() %>/bill"
                                                        class="text-decoration-none">
                                                        <div class="action-card card text-center p-3 h-100">
                                                            <i class="fas fa-file-invoice fa-2x mb-2 text-warning"></i>
                                                            <div class="fw-semibold">Generate Bill</div>
                                                        </div>
                                                    </a>
                                                </div>
                                                <div class="col-6 col-md-3">
                                                    <a href="<%= request.getContextPath() %>/reports"
                                                        class="text-decoration-none">
                                                        <div class="action-card card text-center p-3 h-100">
                                                            <i class="fas fa-chart-bar fa-2x mb-2 text-info"></i>
                                                            <div class="fw-semibold">Reports</div>
                                                        </div>
                                                    </a>
                                                </div>
                                            </div>

                                            <!-- ── All Reservations Table ────────────────────────────── -->
                                            <div class="card shadow-sm">
                                                <div
                                                    class="card-header d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>All Reservations
                                                    </h5>
                                                    <span class="badge bg-primary fs-6">
                                                        <%= reservations !=null ? reservations.size() : 0 %> total
                                                    </span>
                                                </div>
                                                <div class="card-body p-0">
                                                    <% if (reservations==null || reservations.isEmpty()) { %>
                                                        <div class="text-center py-5 text-muted">
                                                            <i class="fas fa-calendar-times fa-3x mb-3"></i>
                                                            <p>No reservations found. <a
                                                                    href="<%= request.getContextPath() %>/reservation">Add
                                                                    one now!</a></p>
                                                        </div>
                                                        <% } else { %>
                                                            <div class="table-responsive">
                                                                <table class="table table-hover mb-0"
                                                                    id="reservationTable">
                                                                    <thead class="table-dark">
                                                                        <tr>
                                                                            <th>Res. No</th>
                                                                            <th>Guest Name</th>
                                                                            <th>Room</th>
                                                                            <th>Check-In</th>
                                                                            <th>Check-Out</th>
                                                                            <th>Total Cost</th>
                                                                            <th>Status</th>
                                                                            <th class="text-center">Actions</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for (Reservation res : reservations) { %>
                                                                            <tr>
                                                                                <td><strong class="text-primary">
                                                                                        <%= res.getReservationNo() %>
                                                                                    </strong></td>
                                                                                <td><i
                                                                                        class="fas fa-user me-1 text-muted"></i>
                                                                                    <%= res.getGuestName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <% if (res.getRoom() !=null) { %>
                                                                                        <span
                                                                                            class="badge bg-secondary">
                                                                                            <%= res.getRoom().getRoomType()
                                                                                                %>
                                                                                        </span>
                                                                                        <small class="text-muted ms-1">#
                                                                                            <%= res.getRoom().getRoomNumber()
                                                                                                %></small>
                                                                                        <% } %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= res.getCheckInDate() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= res.getCheckOutDate() %>
                                                                                </td>
                                                                                <td class="fw-semibold text-success">
                                                                                    Rs. <%= String.format("%,.2f",
                                                                                        res.getTotalCost()) %>
                                                                                </td>
                                                                                <td>
                                                                                    <% String statusClass="secondary" ;
                                                                                        if
                                                                                        ("CONFIRMED".equals(res.getStatus()))
                                                                                        statusClass="primary" ; if
                                                                                        ("CHECKED_IN".equals(res.getStatus()))
                                                                                        statusClass="success" ; if
                                                                                        ("CHECKED_OUT".equals(res.getStatus()))
                                                                                        statusClass="info" ; if
                                                                                        ("CANCELLED".equals(res.getStatus()))
                                                                                        statusClass="danger" ; %>
                                                                                        <span
                                                                                            class="badge bg-<%= statusClass %>">
                                                                                            <%= res.getStatus() %>
                                                                                        </span>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <a href="<%= request.getContextPath() %>/reservation?action=view&reservationNo=<%= res.getReservationNo() %>"
                                                                                        class="btn btn-sm btn-outline-primary me-1"
                                                                                        title="View">
                                                                                        <i class="fas fa-eye"></i>
                                                                                    </a>
                                                                                    <a href="<%= request.getContextPath() %>/bill?reservationNo=<%= res.getReservationNo() %>"
                                                                                        class="btn btn-sm btn-outline-warning"
                                                                                        title="Bill">
                                                                                        <i class="fas fa-receipt"></i>
                                                                                    </a>
                                                                                </td>
                                                                            </tr>
                                                                            <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                            <% } %>
                                                </div>
                                            </div>
                                        </main>

                                        <%-- Footer --%>
                                            <jsp:include page="_footer.jsp" />

                                            <script
                                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                            <script src="<%= request.getContextPath() %>/assets/js/scripts.js"></script>
                                </body>

                                </html>