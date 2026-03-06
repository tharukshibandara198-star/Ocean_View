<%--============================================================addReservation.jsp — Add New Reservation
    Form============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.oceanview.model.Room" %>
                <%-- Session guard --%>
                    <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath()
                        + "/login" ); return; } List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                            List<String> errors = (List<String>) request.getAttribute("errors");
                                    String successMsg = (String) request.getAttribute("successMsg");
                                    // Pre-fill values (returned on validation failure)
                                    String vGuestName = (String) request.getAttribute("enteredGuestName");
                                    String vAddress = (String) request.getAttribute("enteredAddress");
                                    String vContactNo = (String) request.getAttribute("enteredContactNo");
                                    String vRoomId = (String) request.getAttribute("enteredRoomId");
                                    String vCheckIn = (String) request.getAttribute("enteredCheckIn");
                                    String vCheckOut = (String) request.getAttribute("enteredCheckOut");
                                    %>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Add Reservation — Ocean View Resort</title>
                                        <link
                                            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                            rel="stylesheet">
                                        <link
                                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                                            rel="stylesheet">
                                        <link href="<%= request.getContextPath() %>/assets/css/styles.css"
                                            rel="stylesheet">
                                    </head>

                                    <body class="d-flex flex-column min-vh-100">

                                        <jsp:include page="_header.jsp" />

                                        <main class="container py-4 flex-grow-1">
                                            <div class="page-title mb-4">
                                                <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Add New
                                                    Reservation</h3>
                                                <p class="text-muted">Fill in all details below. Fields marked <span
                                                        class="text-danger">*</span> are required.</p>
                                            </div>

                                            <%-- Server-side validation errors --%>
                                                <% if (errors !=null && !errors.isEmpty()) { %>
                                                    <div class="alert alert-danger">
                                                        <strong><i class="fas fa-exclamation-triangle me-2"></i>Please
                                                            fix the following errors:</strong>
                                                        <ul class="mb-0 mt-2">
                                                            <% for (String err : errors) { %>
                                                                <li>
                                                                    <%= err %>
                                                                </li>
                                                                <% } %>
                                                        </ul>
                                                    </div>
                                                    <% } %>

                                                        <%-- Success message --%>
                                                            <% if (successMsg !=null) { %>
                                                                <div
                                                                    class="alert alert-success alert-dismissible fade show">
                                                                    <i class="fas fa-check-circle me-2"></i>
                                                                    <%= successMsg %>
                                                                        <button type="button" class="btn-close"
                                                                            data-bs-dismiss="alert"></button>
                                                                </div>
                                                                <% } %>

                                                                    <div class="card shadow-sm">
                                                                        <div class="card-header">
                                                                            <h5 class="mb-0"><i
                                                                                    class="fas fa-clipboard-list me-2"></i>Reservation
                                                                                Details</h5>
                                                                        </div>
                                                                        <div class="card-body">
                                                                            <form
                                                                                action="<%= request.getContextPath() %>/reservation"
                                                                                method="post" id="reservationForm"
                                                                                novalidate>

                                                                                <div class="row g-3">
                                                                                    <!-- Reservation No (auto-generated notice) -->
                                                                                    <div class="col-md-6">
                                                                                        <label
                                                                                            class="form-label fw-semibold">Reservation
                                                                                            No.</label>
                                                                                        <input type="text"
                                                                                            class="form-control"
                                                                                            value="Auto-Generated (e.g. OVR-00005)"
                                                                                            disabled readonly>
                                                                                        <div class="form-text">Assigned
                                                                                            automatically after
                                                                                            submission.</div>
                                                                                    </div>

                                                                                    <!-- Guest Name -->
                                                                                    <div class="col-md-6">
                                                                                        <label for="guestName"
                                                                                            class="form-label fw-semibold">
                                                                                            Guest Name <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <input type="text"
                                                                                            class="form-control"
                                                                                            id="guestName"
                                                                                            name="guestName"
                                                                                            placeholder="e.g. Kamal Perera"
                                                                                            value="<%= vGuestName != null ? vGuestName : "" %>"
                                                                                            required maxlength="100">
                                                                                        <div class="invalid-feedback">
                                                                                            Guest name is required.
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Address -->
                                                                                    <div class="col-12">
                                                                                        <label for="address"
                                                                                            class="form-label fw-semibold">
                                                                                            Address <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <textarea class="form-control"
                                                                                            id="address" name="address"
                                                                                            rows="2"
                                                                                            placeholder="Full address of the guest"
                                                                                            maxlength="255"
                                                                                            required><%= vAddress != null ? vAddress : "" %></textarea>
                                                                                        <div class="invalid-feedback">
                                                                                            Address is required.</div>
                                                                                    </div>

                                                                                    <!-- Contact No -->
                                                                                    <div class="col-md-6">
                                                                                        <label for="contactNo"
                                                                                            class="form-label fw-semibold">
                                                                                            Contact No. <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <input type="tel"
                                                                                            class="form-control"
                                                                                            id="contactNo"
                                                                                            name="contactNo"
                                                                                            placeholder="e.g. 0771234567"
                                                                                            value="<%= vContactNo != null ? vContactNo : "" %>"
                                                                                            pattern="^[0-9+\-\s]{7,15}$"
                                                                                            required>
                                                                                        <div class="invalid-feedback">
                                                                                            Enter a valid contact number
                                                                                            (7–15 digits).</div>
                                                                                    </div>

                                                                                    <!-- Room Selection -->
                                                                                    <div class="col-md-6">
                                                                                        <label for="roomId"
                                                                                            class="form-label fw-semibold">
                                                                                            Room <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <select class="form-select"
                                                                                            id="roomId" name="roomId"
                                                                                            required>
                                                                                            <option value="">-- Select a
                                                                                                Room --</option>
                                                                                            <% if (rooms !=null) { for
                                                                                                (Room room : rooms) {
                                                                                                String selected=(vRoomId
                                                                                                !=null &&
                                                                                                vRoomId.equals(String.valueOf(room.getId())))
                                                                                                ? "selected" : "" ; %>
                                                                                                <option
                                                                                                    value="<%= room.getId() %>"
                                                                                                    <%=selected %>>
                                                                                                    Room #<%=
                                                                                                        room.getRoomNumber()
                                                                                                        %> — <%=
                                                                                                            room.getRoomType()
                                                                                                            %>
                                                                                                            (Rs. <%=
                                                                                                                String.format("%,.0f",
                                                                                                                room.getRatePerNight())
                                                                                                                %>
                                                                                                                /night)
                                                                                                                <%= room.isAvailable()
                                                                                                                    ? ""
                                                                                                                    : "⚠ Unavailable"
                                                                                                                    %>
                                                                                                </option>
                                                                                                <% } } %>
                                                                                        </select>
                                                                                        <div class="invalid-feedback">
                                                                                            Please select a room.</div>
                                                                                    </div>

                                                                                    <!-- Check-In Date -->
                                                                                    <div class="col-md-6">
                                                                                        <label for="checkInDate"
                                                                                            class="form-label fw-semibold">
                                                                                            Check-In Date <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <input type="date"
                                                                                            class="form-control"
                                                                                            id="checkInDate"
                                                                                            name="checkInDate"
                                                                                            value="<%= vCheckIn != null ? vCheckIn : "" %>"
                                                                                            required>
                                                                                        <div class="invalid-feedback">
                                                                                            Check-in date is required.
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Check-Out Date -->
                                                                                    <div class="col-md-6">
                                                                                        <label for="checkOutDate"
                                                                                            class="form-label fw-semibold">
                                                                                            Check-Out Date <span
                                                                                                class="text-danger">*</span>
                                                                                        </label>
                                                                                        <input type="date"
                                                                                            class="form-control"
                                                                                            id="checkOutDate"
                                                                                            name="checkOutDate"
                                                                                            value="<%= vCheckOut != null ? vCheckOut : "" %>"
                                                                                            required>
                                                                                        <div class="invalid-feedback">
                                                                                            Check-out date must be after
                                                                                            check-in.</div>
                                                                                    </div>

                                                                                    <!-- Cost Preview (dynamic, JS-powered) -->
                                                                                    <div class="col-12">
                                                                                        <div class="alert alert-info mb-0"
                                                                                            id="costPreview"
                                                                                            style="display:none;">
                                                                                            <i
                                                                                                class="fas fa-calculator me-2"></i>
                                                                                            <strong>Estimated Cost:
                                                                                            </strong>
                                                                                            <span id="costAmount">Rs.
                                                                                                0.00</span>
                                                                                            (<span
                                                                                                id="nightsCount">0</span>
                                                                                            night(s) ×
                                                                                            <span id="rateDisplay">Rs.
                                                                                                0</span>/night)
                                                                                        </div>
                                                                                    </div>
                                                                                </div><!-- end row -->

                                                                                <!-- Buttons -->
                                                                                <div class="mt-4 d-flex gap-2">
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary"
                                                                                        id="submitBtn">
                                                                                        <i
                                                                                            class="fas fa-save me-2"></i>Save
                                                                                        Reservation
                                                                                    </button>
                                                                                    <a href="<%= request.getContextPath() %>/dashboard"
                                                                                        class="btn btn-secondary">
                                                                                        <i
                                                                                            class="fas fa-times me-1"></i>Cancel
                                                                                    </a>
                                                                                </div>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                        </main>

                                        <jsp:include page="_footer.jsp" />

                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                        <script src="<%= request.getContextPath() %>/assets/js/scripts.js"></script>
                                        <script>
                                            // ── Room rates map for cost preview ────────────────────────────────────────
                                            // (Rates extracted from the server-rendered select options)
                                            const roomRates = {};
    <%
        if (rooms != null) {
                                                for (Room room : rooms) {
    %>
                                                        roomRates[<%= room.getId() %>] = <%= room.getRatePerNight() %>;
    <%
            }
                                            }
    %>

                                                // ── Client-side cost preview ───────────────────────────────────────────────
                                                function updateCostPreview() {
                                                    const roomId = document.getElementById('roomId').value;
                                                    const checkIn = document.getElementById('checkInDate').value;
                                                    const checkOut = document.getElementById('checkOutDate').value;

                                                    if (roomId && checkIn && checkOut) {
                                                        const rate = roomRates[roomId] || 0;
                                                        const inDate = new Date(checkIn);
                                                        const outDate = new Date(checkOut);
                                                        const nights = Math.ceil((outDate - inDate) / (1000 * 60 * 60 * 24));

                                                        if (nights > 0 && rate > 0) {
                                                            const total = nights * rate;
                                                            document.getElementById('nightsCount').textContent = nights;
                                                            document.getElementById('rateDisplay').textContent = 'Rs. ' + rate.toLocaleString();
                                                            document.getElementById('costAmount').textContent = 'Rs. ' + total.toLocaleString('en-US', { minimumFractionDigits: 2 });
                                                            document.getElementById('costPreview').style.display = 'block';
                                                        } else {
                                                            document.getElementById('costPreview').style.display = 'none';
                                                        }
                                                    }
                                                }

                                            document.getElementById('roomId').addEventListener('change', updateCostPreview);
                                            document.getElementById('checkInDate').addEventListener('change', function () {
                                                // Set minimum check-out to the day after check-in
                                                const checkIn = this.value;
                                                if (checkIn) {
                                                    const nextDay = new Date(checkIn);
                                                    nextDay.setDate(nextDay.getDate() + 1);
                                                    document.getElementById('checkOutDate').min = nextDay.toISOString().split('T')[0];
                                                }
                                                updateCostPreview();
                                            });
                                            document.getElementById('checkOutDate').addEventListener('change', updateCostPreview);

                                            // Set today as minimum for check-in date
                                            const today = new Date().toISOString().split('T')[0];
                                            document.getElementById('checkInDate').min = today;

                                            // ── Client-side form validation ────────────────────────────────────────────
                                            document.getElementById('reservationForm').addEventListener('submit', function (e) {
                                                let valid = true;
                                                const fields = ['guestName', 'address', 'contactNo', 'roomId', 'checkInDate', 'checkOutDate'];
                                                fields.forEach(id => {
                                                    const el = document.getElementById(id);
                                                    if (!el.value.trim()) {
                                                        el.classList.add('is-invalid'); valid = false;
                                                    } else {
                                                        el.classList.remove('is-invalid');
                                                    }
                                                });
                                                // Check-out must be after check-in
                                                const ci = document.getElementById('checkInDate').value;
                                                const co = document.getElementById('checkOutDate').value;
                                                if (ci && co && co <= ci) {
                                                    document.getElementById('checkOutDate').classList.add('is-invalid');
                                                    valid = false;
                                                }
                                                if (!valid) e.preventDefault();
                                            });
                                        </script>
                                    </body>

                                    </html>