<%--============================================================reports.jsp — Monthly Reports
    Dashboard============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.math.BigDecimal" %>
            <%@ page import="java.util.Map" %>
                <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath()
                    + "/login" ); return; } int monthlyCount=(Integer) request.getAttribute("monthlyCount"); BigDecimal
                    monthlyRevenue=(BigDecimal) request.getAttribute("monthlyRevenue"); int totalAllTime=(Integer)
                    request.getAttribute("totalAllTime"); int activeCount=(Integer) request.getAttribute("activeCount");
                    Map<String, BigDecimal> revenueByType = (Map<String, BigDecimal>)
                        request.getAttribute("revenueByType");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Reports — Ocean View Resort</title>
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
                                    <h3><i class="fas fa-chart-bar me-2 text-info"></i>Reports &amp; Dashboard</h3>
                                    <p class="text-muted">Summary statistics for Ocean View Resort.</p>
                                </div>

                                <!-- ── KPI Summary Cards ──────────────────────────────────── -->
                                <div class="row g-3 mb-4">
                                    <!-- Current Month Reservations -->
                                    <div class="col-md-3">
                                        <div class="stat-card card text-center p-3 h-100">
                                            <div class="stat-icon text-primary mb-2">
                                                <i class="fas fa-calendar-check fa-2x"></i>
                                            </div>
                                            <div class="stat-number text-primary">
                                                <%= monthlyCount %>
                                            </div>
                                            <div class="stat-label">This Month's Reservations</div>
                                        </div>
                                    </div>
                                    <!-- Monthly Revenue -->
                                    <div class="col-md-3">
                                        <div class="stat-card card text-center p-3 h-100">
                                            <div class="stat-icon text-success mb-2">
                                                <i class="fas fa-money-bill-wave fa-2x"></i>
                                            </div>
                                            <div class="stat-number text-success">
                                                Rs. <%= String.format("%,.0f", monthlyRevenue) %>
                                            </div>
                                            <div class="stat-label">This Month's Revenue</div>
                                        </div>
                                    </div>
                                    <!-- Total All Time -->
                                    <div class="col-md-3">
                                        <div class="stat-card card text-center p-3 h-100">
                                            <div class="stat-icon text-warning mb-2">
                                                <i class="fas fa-history fa-2x"></i>
                                            </div>
                                            <div class="stat-number text-warning">
                                                <%= totalAllTime %>
                                            </div>
                                            <div class="stat-label">Total Reservations (All Time)</div>
                                        </div>
                                    </div>
                                    <!-- Active Bookings -->
                                    <div class="col-md-3">
                                        <div class="stat-card card text-center p-3 h-100">
                                            <div class="stat-icon text-danger mb-2">
                                                <i class="fas fa-bed fa-2x"></i>
                                            </div>
                                            <div class="stat-number text-danger">
                                                <%= activeCount %>
                                            </div>
                                            <div class="stat-label">Active Reservations</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- ── Revenue by Room Type Table ───────────────────────────── -->
                                <div class="card shadow-sm mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0">
                                            <i class="fas fa-table me-2"></i>
                                            This Month's Revenue by Room Type
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <% if (revenueByType==null || revenueByType.isEmpty()) { %>
                                            <p class="text-muted text-center py-3">No revenue data for the current
                                                month.</p>
                                            <% } else { %>
                                                <% // Calculate grand total for progress bar percentages BigDecimal
                                                    grandTotal=revenueByType.values().stream() .reduce(BigDecimal.ZERO,
                                                    BigDecimal::add); %>
                                                    <table class="table table-bordered align-middle">
                                                        <thead class="table-dark">
                                                            <tr>
                                                                <th>Room Type</th>
                                                                <th class="text-end">Revenue (Rs.)</th>
                                                                <th>Share</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (Map.Entry<String, BigDecimal> entry :
                                                                revenueByType.entrySet()) {
                                                                double pct = grandTotal.compareTo(BigDecimal.ZERO) > 0
                                                                ? entry.getValue().doubleValue() /
                                                                grandTotal.doubleValue() * 100
                                                                : 0;
                                                                %>
                                                                <tr>
                                                                    <td><span class="badge bg-secondary me-2">
                                                                            <%= entry.getKey() %>
                                                                        </span></td>
                                                                    <td class="text-end fw-semibold">Rs. <%=
                                                                            String.format("%,.2f", entry.getValue()) %>
                                                                    </td>
                                                                    <td style="min-width:200px">
                                                                        <div class="progress" style="height:20px;">
                                                                            <div class="progress-bar bg-info"
                                                                                role="progressbar"
                                                                                style="width:<%= String.format(" %.1f",
                                                                                pct) %>%">
                                                                                <%= String.format("%.1f", pct) %>%
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                        <tfoot>
                                                            <tr class="table-light">
                                                                <td class="fw-bold">TOTAL</td>
                                                                <td class="text-end fw-bold text-success">
                                                                    Rs. <%= String.format("%,.2f", grandTotal) %>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                        </tfoot>
                                                    </table>
                                                    <% } %>
                                    </div>
                                </div>

                                <!-- ── API Info Box ─────────────────────────────────────────── -->
                                <div class="card shadow-sm border-info">
                                    <div class="card-header bg-info text-white">
                                        <h5 class="mb-0"><i class="fas fa-code me-2"></i>REST API — Live Endpoint</h5>
                                    </div>
                                    <div class="card-body">
                                        <p>This system exposes a RESTful Web Service for distributed access:</p>
                                        <table class="table table-sm table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Method</th>
                                                    <th>URL</th>
                                                    <th>Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><span class="badge bg-success">GET</span></td>
                                                    <td><code><%= request.getContextPath() %>/api/reservations</code>
                                                    </td>
                                                    <td>Returns all reservations as JSON</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="badge bg-success">GET</span></td>
                                                    <td><code><%= request.getContextPath() %>/api/reservations/{id}</code>
                                                    </td>
                                                    <td>Returns one reservation by ID</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="badge bg-primary">POST</span></td>
                                                    <td><code><%= request.getContextPath() %>/api/reservations</code>
                                                    </td>
                                                    <td>Creates a new reservation (JSON body)</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <a href="<%= request.getContextPath() %>/api/reservations" target="_blank"
                                            class="btn btn-outline-info btn-sm">
                                            <i class="fas fa-external-link-alt me-1"></i>Test API in Browser
                                        </a>
                                    </div>
                                </div>
                            </main>

                            <jsp:include page="_footer.jsp" />
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>