<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath() + "/login" );
        return; } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Help — Ocean View Resort</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link href="<%=request.getContextPath()%>/assets/css/styles.css" rel="stylesheet">
        </head>

        <body class="d-flex flex-column min-vh-100">
            <%@ include file="_header.jsp" %>
                <main class="container py-4 flex-grow-1">
                    <div class="page-title mb-4">
                        <h3><i class="fas fa-question-circle me-2 text-info"></i>Staff Help Guide</h3>
                        <p class="text-muted">Quick reference guide for Ocean View Resort Reservation System staff.</p>
                    </div>

                    <div class="accordion shadow-sm" id="helpAccordion">

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s1">
                                    <i class="fas fa-sign-in-alt me-2 text-primary"></i>1. How to Login
                                </button>
                            </h2>
                            <div id="s1" class="accordion-collapse collapse show">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Navigate to the system URL provided by your administrator.</li>
                                        <li>Enter your <strong>Username</strong> and <strong>Password</strong>.</li>
                                        <li>Click the <strong>Login</strong> button — you'll be redirected to the
                                            <strong>Dashboard</strong>.</li>
                                    </ol>
                                    <div class="alert alert-info mb-0">If you forget your password, contact the
                                        <strong>ADMIN</strong> user.</div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s2">
                                    <i class="fas fa-plus-circle me-2 text-success"></i>2. How to Add a New Reservation
                                </button>
                            </h2>
                            <div id="s2" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Click <strong>Add Reservation</strong> in the navigation menu.</li>
                                        <li>Fill in Guest Name, Address, Contact No., Room (select from dropdown),
                                            Check-In and Check-Out dates.</li>
                                        <li>The <strong>estimated cost</strong> updates automatically.</li>
                                        <li>Click <strong>Save Reservation</strong> — a unique number (e.g. OVR-00005)
                                            is generated.</li>
                                    </ol>
                                    <div class="alert alert-warning mb-0">Check-out date must be at least 1 day after
                                        the check-in date.</div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s3">
                                    <i class="fas fa-search me-2 text-info"></i>3. How to View a Reservation
                                </button>
                            </h2>
                            <div id="s3" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Click <strong>View Reservation</strong> in the navigation.</li>
                                        <li>Enter the Reservation Number (e.g. <code>OVR-00001</code>) and click
                                            <strong>Search</strong>.</li>
                                        <li>Full details will appear — from there you can click <strong>Print
                                                Bill</strong>.</li>
                                    </ol>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s4">
                                    <i class="fas fa-file-invoice me-2 text-warning"></i>4. How to Generate &amp; Print
                                    a Bill
                                </button>
                            </h2>
                            <div id="s4" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <ol>
                                        <li>Go to <strong>Bill</strong> from the navigation.</li>
                                        <li>Enter the Reservation Number and click <strong>Generate Bill</strong>.</li>
                                        <li>Click <strong>Print Bill</strong> — use "Save as PDF" in the print dialog
                                            for a digital copy.</li>
                                    </ol>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s5">
                                    <i class="fas fa-chart-bar me-2 text-danger"></i>5. How to View Reports
                                </button>
                            </h2>
                            <div id="s5" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <p>Click <strong>Reports</strong>. The page shows monthly reservations, monthly
                                        revenue, all-time total, active bookings, and revenue breakdown by room type.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s6">
                                    <i class="fas fa-bed me-2 text-secondary"></i>6. Room Types &amp; Rates
                                </button>
                            </h2>
                            <div id="s6" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <table class="table table-bordered">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Room Type</th>
                                                <th>Rate/Night (Rs.)</th>
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

                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#s7">
                                    <i class="fas fa-sign-out-alt me-2"></i>7. How to Logout
                                </button>
                            </h2>
                            <div id="s7" class="accordion-collapse collapse">
                                <div class="accordion-body">
                                    <p>Click the <strong>Logout</strong> button in the top-right corner. Your session
                                        will be securely terminated.</p>
                                    <div class="alert alert-danger mb-0">Always log out on shared computers. Sessions
                                        expire after <strong>30 minutes</strong> of inactivity.</div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="mt-4">
                        <a href="<%=request.getContextPath()%>/dashboard" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                        </a>
                    </div>
                </main>
                <%@ include file="_footer.jsp" %>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>