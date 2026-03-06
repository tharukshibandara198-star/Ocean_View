<%--============================================================help.jsp — Staff Help & User
    Guide============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath() + "/login"
            ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Help — Ocean View Resort</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
            </head>

            <body class="d-flex flex-column min-vh-100">

                <jsp:include page="_header.jsp" />

                <main class="container py-4 flex-grow-1">
                    <div class="page-title mb-4">
                        <h3><i class="fas fa-question-circle me-2 text-info"></i>Staff Help Guide</h3>
                        <p class="text-muted">Welcome to Ocean View Resort Reservation System. This guide will help you
                            get started.</p>
                    </div>

                    <!-- Accordion FAQ -->
                    <div class="accordion shadow-sm" id="helpAccordion">

                        <!-- Section 1: Login -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s1" aria-expanded="true">
                                    <i class="fas fa-sign-in-alt me-2 text-primary"></i>
                                    1. How to Login
                                </button>
                            </h2>
                            <div id="s1" class="accordion-collapse collapse show">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Navigate to the system URL provided by your administrator.</li>
                                        <li>Enter your <strong>Username</strong> and <strong>Password</strong>.</li>
                                        <li>Click the <strong>Login</strong> button.</li>
                                        <li>You will be redirected to the <strong>Dashboard</strong>.</li>
                                    </ol>
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-1"></i>
                                        If you forget your password, contact the <strong>ADMIN</strong> user.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 2: Add Reservation -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s2">
                                    <i class="fas fa-plus-circle me-2 text-success"></i>
                                    2. How to Add a New Reservation
                                </button>
                            </h2>
                            <div id="s2" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Click <strong>Add Reservation</strong> in the top navigation menu.</li>
                                        <li>Fill in all required fields (marked with <span
                                                class="text-danger">*</span>):
                                            <ul>
                                                <li><strong>Guest Name</strong> — Full name of the guest.</li>
                                                <li><strong>Address</strong> — Guest's home address.</li>
                                                <li><strong>Contact No.</strong> — Phone number (7–15 digits).</li>
                                                <li><strong>Room</strong> — Select from available rooms in the dropdown.
                                                </li>
                                                <li><strong>Check-In / Check-Out Dates</strong> — Choose future dates.
                                                </li>
                                            </ul>
                                        </li>
                                        <li>The <strong>estimated cost</strong> will be shown automatically.</li>
                                        <li>Click <strong>Save Reservation</strong>.</li>
                                        <li>A unique <strong>Reservation Number</strong> (e.g. OVR-00005) will be
                                            generated.</li>
                                    </ol>
                                    <div class="alert alert-warning mb-0">
                                        <i class="fas fa-exclamation-triangle me-1"></i>
                                        The check-out date <em>must</em> be at least 1 day after the check-in date.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 3: View Reservation -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s3">
                                    <i class="fas fa-search me-2 text-info"></i>
                                    3. How to View a Reservation
                                </button>
                            </h2>
                            <div id="s3" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Click <strong>View Reservation</strong> in the navigation.</li>
                                        <li>Enter the <strong>Reservation Number</strong> (e.g. <code>OVR-00001</code>).
                                        </li>
                                        <li>Click <strong>Search</strong>.</li>
                                        <li>All booking details including guest info, room, and cost will appear.</li>
                                        <li>From there, you can click <strong>Print Bill</strong> to generate an
                                            invoice.</li>
                                    </ol>
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Generate Bill -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s4">
                                    <i class="fas fa-file-invoice me-2 text-warning"></i>
                                    4. How to Generate &amp; Print a Bill
                                </button>
                            </h2>
                            <div id="s4" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Go to <strong>Bill</strong> from the navigation or click the receipt icon in
                                            the Dashboard.</li>
                                        <li>Enter the <strong>Reservation Number</strong>.</li>
                                        <li>Click <strong>Generate Bill</strong>.</li>
                                        <li>A detailed invoice will show:
                                            <ul>
                                                <li>Guest name and address</li>
                                                <li>Room details and nightly rate</li>
                                                <li>Number of nights</li>
                                                <li>Total cost (Nights × Rate)</li>
                                            </ul>
                                        </li>
                                        <li>Click <strong>Print Bill</strong> to send to printer or save as PDF.</li>
                                    </ol>
                                    <div class="alert alert-success mb-0">
                                        <i class="fas fa-lightbulb me-1"></i>
                                        Tip: Use your browser's <strong>Save as PDF</strong> option in the print dialog
                                        to send a digital copy to the guest.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 5: Reports -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s5">
                                    <i class="fas fa-chart-bar me-2 text-danger"></i>
                                    5. How to View Reports
                                </button>
                            </h2>
                            <div id="s5" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <p>Click <strong>Reports</strong> from the navigation. The reports page shows:</p>
                                    <ul>
                                        <li><strong>This Month's Reservations</strong> — Total bookings made this
                                            calendar month.</li>
                                        <li><strong>This Month's Revenue</strong> — Total money earned this month.</li>
                                        <li><strong>All-Time Total</strong> — Total bookings ever.</li>
                                        <li><strong>Active Reservations</strong> — Currently confirmed bookings.</li>
                                        <li><strong>Revenue Breakdown</strong> — Revenue split by room type.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Section 6: Room Types & Rates -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s6">
                                    <i class="fas fa-bed me-2 text-secondary"></i>
                                    6. Room Types &amp; Rates
                                </button>
                            </h2>
                            <div id="s6" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <table class="table table-bordered">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Room Type</th>
                                                <th>Rate per Night (Rs.)</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Standard</td>
                                                <td>5,000</td>
                                                <td>Garden view, comfortable stay</td>
                                            </tr>
                                            <tr>
                                                <td>Deluxe</td>
                                                <td>8,500</td>
                                                <td>Balcony with pool view</td>
                                            </tr>
                                            <tr>
                                                <td>Suite</td>
                                                <td>15,000</td>
                                                <td>Luxury suite with living area</td>
                                            </tr>
                                            <tr>
                                                <td>Ocean View</td>
                                                <td>12,000</td>
                                                <td>Direct ocean view, premium</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Section 7: Logout -->
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s7">
                                    <i class="fas fa-sign-out-alt me-2"></i>
                                    7. How to Logout
                                </button>
                            </h2>
                            <div id="s7" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <p>Always log out after finishing your work to protect guest data:</p>
                                    <ol>
                                        <li>Click the <strong>Logout</strong> button in the top-right corner of the
                                            navigation bar.</li>
                                        <li>Your session will be securely terminated.</li>
                                        <li>You will be redirected to the <strong>Login page</strong>.</li>
                                    </ol>
                                    <div class="alert alert-danger mb-0">
                                        <i class="fas fa-exclamation-triangle me-1"></i>
                                        <strong>Important:</strong> Do NOT close the browser tab without logging out on
                                        a shared computer.
                                        Sessions expire automatically after <strong>30 minutes</strong> of inactivity.
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- end accordion -->

                    <div class="mt-4">
                        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                        </a>
                    </div>
                </main>

                <jsp:include page="_footer.jsp" />
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>