<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.oceanview.model.Reservation" %>
        <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath() + "/login"
            ); return; } Reservation res=(Reservation) request.getAttribute("reservation"); String billError=(String)
            request.getAttribute("billError"); com.oceanview.model.User currentUser=(com.oceanview.model.User)
            session.getAttribute("loggedInUser"); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Bill — Ocean View Resort</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <link href="<%=request.getContextPath()%>/assets/css/styles.css" rel="stylesheet">
                <style>
                    @media print {
                        .no-print {
                            display: none !important;
                        }

                        .card {
                            border: 1px solid #ccc !important;
                        }

                        body {
                            background: white !important;
                        }
                    }
                </style>
            </head>

            <body class="d-flex flex-column min-vh-100">
                <div class="no-print">
                    <%@ include file="_header.jsp" %>
                </div>
                <main class="container py-4 flex-grow-1">

                    <!-- Search -->
                    <div class="card shadow-sm mb-4 no-print">
                        <div class="card-body">
                            <form action="<%=request.getContextPath()%>/bill" method="get"
                                class="row g-2 align-items-end">
                                <div class="col-md-8">
                                    <label for="reservationNo" class="form-label fw-semibold">Enter Reservation Number
                                        to Generate Bill</label>
                                    <input type="text" class="form-control form-control-lg text-uppercase"
                                        id="reservationNo" name="reservationNo" placeholder="e.g. OVR-00001"
                                        value="<%=res!=null?res.getReservationNo():""%>" required>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-warning btn-lg w-100">
                                        <i class="fas fa-calculator me-1"></i>Generate Bill
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <% if (billError !=null) { %>
                        <div class="alert alert-danger no-print"><i class="fas fa-exclamation-triangle me-2"></i>
                            <%=billError%>
                        </div>
                        <% } %>

                            <% if (res !=null) { %>
                                <div class="card shadow bill-card" id="billSection">
                                    <div class="bill-header text-center p-4">
                                        <h2 class="mb-0"><i class="fas fa-water me-2"></i>Ocean View Resort</h2>
                                        <p class="mb-0 text-muted">No. 1, Beach Avenue, Galle, Sri Lanka | Tel: +94 91
                                            2345678</p>
                                        <hr>
                                        <h4 class="invoice-title">INVOICE / BILL OF CHARGES</h4>
                                    </div>
                                    <div class="card-body px-5">
                                        <div class="row mb-4">
                                            <div class="col-6">
                                                <p class="mb-1"><strong>Reservation No:</strong> <span
                                                        class="text-primary fs-5">
                                                        <%=res.getReservationNo()%>
                                                    </span></p>
                                                <p class="mb-1"><strong>Status:</strong>
                                                    <%=res.getStatus()%>
                                                </p>
                                                <p class="mb-1"><strong>Prepared By:</strong>
                                                    <%=currentUser.getFullName()%>
                                                </p>
                                            </div>
                                            <div class="col-6 text-end">
                                                <p class="mb-1"><strong>Date Issued:</strong>
                                                    <%=java.time.LocalDate.now()%>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="bill-section mb-4">
                                            <h6 class="bill-section-title">GUEST DETAILS</h6>
                                            <table class="table table-sm table-borderless">
                                                <tr>
                                                    <td style="width:160px" class="text-muted">Name</td>
                                                    <td><strong>
                                                            <%=res.getGuestName()%>
                                                        </strong></td>
                                                </tr>
                                                <tr>
                                                    <td class="text-muted">Address</td>
                                                    <td>
                                                        <%=res.getAddress()%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="text-muted">Contact</td>
                                                    <td>
                                                        <%=res.getContactNo()%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <div class="bill-section mb-4">
                                            <h6 class="bill-section-title">CHARGE DETAILS</h6>
                                            <table class="table table-bordered">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th>Description</th>
                                                        <th class="text-center">Nights</th>
                                                        <th class="text-end">Rate/Night</th>
                                                        <th class="text-end">Amount (Rs.)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            Room
                                                            #<%=res.getRoom()!=null?res.getRoom().getRoomNumber():"-"%>
                                                                —
                                                                <%=res.getRoom()!=null?res.getRoom().getRoomType():"-"%>
                                                                    <br><small class="text-muted">
                                                                        <%=res.getCheckInDate()%> &rarr;
                                                                            <%=res.getCheckOutDate()%>
                                                                    </small>
                                                        </td>
                                                        <td class="text-center">
                                                            <%=res.getNumberOfNights()%>
                                                        </td>
                                                        <td class="text-end">Rs.
                                                            <%=res.getRoom()!=null?String.format("%,.2f",res.getRoom().getRatePerNight()):"-"%>
                                                        </td>
                                                        <td class="text-end fw-bold">Rs.
                                                            <%=String.format("%,.2f",res.getTotalCost())%>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr class="table-light">
                                                        <td colspan="3" class="text-end fw-bold fs-5">TOTAL AMOUNT DUE
                                                        </td>
                                                        <td class="text-end fw-bold fs-5 text-success">Rs.
                                                            <%=String.format("%,.2f",res.getTotalCost())%>
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>

                                        <div class="text-center mt-4 text-muted">
                                            <p>Thank you for choosing <strong>Ocean View Resort</strong>. We hope you
                                                enjoyed your stay!</p>
                                            <p class="small">This is a computer-generated bill. No signature required.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-3 d-flex gap-2 no-print">
                                    <button onclick="window.print()" class="btn btn-primary"><i
                                            class="fas fa-print me-2"></i>Print Bill</button>
                                    <a href="<%=request.getContextPath()%>/dashboard" class="btn btn-secondary ms-auto">
                                        <i class="fas fa-home me-1"></i>Dashboard
                                    </a>
                                </div>
                                <% } %>
                </main>
                <div class="no-print">
                    <%@ include file="_footer.jsp" %>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>