<%--============================================================viewReservation.jsp — View / Search Reservation
    Details============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath()
                + "/login" ); return; } Reservation res=(Reservation) request.getAttribute("reservation"); String
                searchError=(String) request.getAttribute("searchError"); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>View Reservation — Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
                </head>

                <body class="d-flex flex-column min-vh-100">

                    <jsp:include page="_header.jsp" />

                    <main class="container py-4 flex-grow-1">
                        <div class="page-title mb-4">
                            <h3><i class="fas fa-search me-2 text-success"></i>View Reservation Details</h3>
                            <p class="text-muted">Search for a reservation using its unique reservation number.</p>
                        </div>

                        <!-- ── Search Form ─────────────────────────────────────────── -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/reservation" method="get" id="searchForm"
                                    class="row g-2 align-items-end">
                                    <input type="hidden" name="action" value="view">
                                    <div class="col-md-8">
                                        <label for="reservationNo" class="form-label fw-semibold">
                                            Reservation Number
                                        </label>
                                        <input type="text" class="form-control form-control-lg text-uppercase"
                                            id="reservationNo" name="reservationNo" placeholder="e.g. OVR-00003"
                                            value="<%= res != null ? res.getReservationNo() : (request.getParameter("
                                            reservationNo") !=null ? request.getParameter("reservationNo") : "" ) %>"
                                        required>
                                    </div>
                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-success btn-lg w-100">
                                            <i class="fas fa-search me-2"></i>Search
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <%-- Error: not found --%>
                            <% if (searchError !=null) { %>
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= searchError %>
                                </div>
                                <% } %>

                                    <%-- Reservation details card --%>
                                        <% if (res !=null) { %>
                                            <div class="card shadow reservation-detail-card">
                                                <!-- Card Header with status badge -->
                                                <div
                                                    class="card-header d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h5 class="mb-0">
                                                            <i class="fas fa-bookmark me-2"></i>
                                                            Reservation: <strong class="text-primary">
                                                                <%= res.getReservationNo() %>
                                                            </strong>
                                                        </h5>
                                                    </div>
                                                    <% String sc="secondary" ; if ("CONFIRMED".equals(res.getStatus()))
                                                        sc="primary" ; if ("CHECKED_IN".equals(res.getStatus()))
                                                        sc="success" ; if ("CHECKED_OUT".equals(res.getStatus()))
                                                        sc="info" ; if ("CANCELLED".equals(res.getStatus())) sc="danger"
                                                        ; %>
                                                        <span class="badge bg-<%= sc %> fs-6">
                                                            <%= res.getStatus() %>
                                                        </span>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row g-4">
                                                        <!-- Guest Info -->
                                                        <div class="col-md-6">
                                                            <h6 class="section-label"><i
                                                                    class="fas fa-user me-2"></i>Guest Information</h6>
                                                            <table class="table table-sm table-borderless detail-table">
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Name:</td>
                                                                    <td>
                                                                        <%= res.getGuestName() %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Address:</td>
                                                                    <td>
                                                                        <%= res.getAddress() %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Contact:</td>
                                                                    <td><a href="tel:<%= res.getContactNo() %>">
                                                                            <%= res.getContactNo() %>
                                                                        </a></td>
                                                                </tr>
                                                            </table>
                                                        </div>

                                                        <!-- Room Info -->
                                                        <div class="col-md-6">
                                                            <h6 class="section-label"><i
                                                                    class="fas fa-bed me-2"></i>Room Information</h6>
                                                            <table class="table table-sm table-borderless detail-table">
                                                                <% if (res.getRoom() !=null) { %>
                                                                    <tr>
                                                                        <td class="text-muted fw-semibold">Room No.:
                                                                        </td>
                                                                        <td>#<%= res.getRoom().getRoomNumber() %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="text-muted fw-semibold">Type:</td>
                                                                        <td><span class="badge bg-secondary">
                                                                                <%= res.getRoom().getRoomType() %>
                                                                            </span></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="text-muted fw-semibold">Rate/Night:
                                                                        </td>
                                                                        <td>Rs. <%= String.format("%,.2f",
                                                                                res.getRoom().getRatePerNight()) %>
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                            </table>
                                                        </div>

                                                        <!-- Booking Dates -->
                                                        <div class="col-md-6">
                                                            <h6 class="section-label"><i
                                                                    class="fas fa-calendar me-2"></i>Booking Dates</h6>
                                                            <table class="table table-sm table-borderless detail-table">
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Check-In:</td>
                                                                    <td>
                                                                        <%= res.getCheckInDate() %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Check-Out:</td>
                                                                    <td>
                                                                        <%= res.getCheckOutDate() %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Nights:</td>
                                                                    <td><strong>
                                                                            <%= res.getNumberOfNights() %> night(s)
                                                                        </strong></td>
                                                                </tr>
                                                            </table>
                                                        </div>

                                                        <!-- Billing Summary -->
                                                        <div class="col-md-6">
                                                            <h6 class="section-label"><i
                                                                    class="fas fa-receipt me-2"></i>Billing</h6>
                                                            <table class="table table-sm table-borderless detail-table">
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Total Cost:</td>
                                                                    <td class="fw-bold text-success fs-5">
                                                                        Rs. <%= String.format("%,.2f",
                                                                            res.getTotalCost()) %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="text-muted fw-semibold">Booked By:</td>
                                                                    <td>
                                                                        <%= res.getCreatedByName() %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <!-- Action buttons -->
                                                    <div class="mt-3 d-flex gap-2">
                                                        <a href="<%= request.getContextPath() %>/bill?reservationNo=<%= res.getReservationNo() %>"
                                                            class="btn btn-warning">
                                                            <i class="fas fa-print me-2"></i>Print Bill
                                                        </a>
                                                        <a href="<%= request.getContextPath() %>/reservation?action=view"
                                                            class="btn btn-outline-secondary">
                                                            <i class="fas fa-search me-1"></i>Search Another
                                                        </a>
                                                        <a href="<%= request.getContextPath() %>/dashboard"
                                                            class="btn btn-secondary ms-auto">
                                                            <i class="fas fa-home me-1"></i>Dashboard
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                    </main>

                    <jsp:include page="_footer.jsp" />
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>