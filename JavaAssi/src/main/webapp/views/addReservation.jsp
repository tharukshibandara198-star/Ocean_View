<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.oceanview.model.Room" %>
            <% if (session.getAttribute("loggedInUser")==null) { response.sendRedirect(request.getContextPath()
                + "/login" ); return; } List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                    String errorMsg = (String) request.getAttribute("errorMsg");
                    String successMsg= (String) request.getAttribute("successMsg");
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Add Reservation — Ocean View Resort</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                            rel="stylesheet">
                        <link href="<%=request.getContextPath()%>/assets/css/styles.css" rel="stylesheet">
                    </head>

                    <body class="d-flex flex-column min-vh-100">
                        <%@ include file="_header.jsp" %>
                            <main class="container py-4 flex-grow-1">
                                <div class="page-title mb-4">
                                    <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Add New Reservation</h3>
                                    <p class="text-muted">Fill in all details below. Fields marked <span
                                            class="text-danger">*</span> are required.</p>
                                </div>

                                <% if (errorMsg !=null) { %>
                                    <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>
                                        <%=errorMsg%>
                                    </div>
                                    <% } %>
                                        <% if (successMsg !=null) { %>
                                            <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i>
                                                <%=successMsg%>
                                            </div>
                                            <% } %>

                                                <form action="<%=request.getContextPath()%>/reservation" method="post"
                                                    id="reservationForm" novalidate>
                                                    <input type="hidden" name="action" value="add">
                                                    <div class="card shadow-sm mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0"><i
                                                                    class="fas fa-clipboard-list me-2"></i>Reservation
                                                                Details</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="row g-3">
                                                                <!-- Reservation No (auto) -->
                                                                <div class="col-md-6">
                                                                    <label class="form-label fw-semibold">Reservation
                                                                        No.</label>
                                                                    <input type="text" class="form-control bg-light"
                                                                        value="Auto-Generated (e.g. OVR-00005)"
                                                                        disabled>
                                                                    <div class="form-text">Assigned automatically after
                                                                        submission.</div>
                                                                </div>
                                                                <!-- Guest Name -->
                                                                <div class="col-md-6">
                                                                    <label for="guestName"
                                                                        class="form-label fw-semibold">Guest Name <span
                                                                            class="text-danger">*</span></label>
                                                                    <input type="text" class="form-control"
                                                                        id="guestName" name="guestName"
                                                                        placeholder="e.g. Kamal Perera" required
                                                                        minlength="2" maxlength="100"
                                                                        value="<%=request.getParameter("
                                                                        guestName")!=null?request.getParameter("guestName"):""%>">
                                                                    <div class="invalid-feedback">Please enter a valid
                                                                        guest name (min 2 characters).</div>
                                                                </div>
                                                                <!-- Address -->
                                                                <div class="col-12">
                                                                    <label for="address"
                                                                        class="form-label fw-semibold">Address <span
                                                                            class="text-danger">*</span></label>
                                                                    <textarea class="form-control" id="address"
                                                                        name="address" rows="2"
                                                                        placeholder="Full address of the guest"
                                                                        required><%=request.getParameter("address")!=null?request.getParameter("address"):""%></textarea>
                                                                    <div class="invalid-feedback">Address is required.
                                                                    </div>
                                                                </div>
                                                                <!-- Contact No -->
                                                                <div class="col-md-6">
                                                                    <label for="contactNo"
                                                                        class="form-label fw-semibold">Contact No. <span
                                                                            class="text-danger">*</span></label>
                                                                    <input type="tel" class="form-control"
                                                                        id="contactNo" name="contactNo"
                                                                        placeholder="e.g. 0771234567"
                                                                        pattern="[0-9]{7,15}" required
                                                                        value="<%=request.getParameter("
                                                                        contactNo")!=null?request.getParameter("contactNo"):""%>">
                                                                    <div class="invalid-feedback">Enter a valid phone
                                                                        number (7-15 digits).</div>
                                                                </div>
                                                                <!-- Room -->
                                                                <div class="col-md-6">
                                                                    <label for="roomId"
                                                                        class="form-label fw-semibold">Room <span
                                                                            class="text-danger">*</span></label>
                                                                    <select class="form-select" id="roomId"
                                                                        name="roomId" required onchange="updateCost()">
                                                                        <option value="">-- Select a Room --</option>
                                                                        <% if (rooms !=null) { for (Room room : rooms) {
                                                                            %>
                                                                            <option value="<%=room.getId()%>"
                                                                                data-rate="<%=room.getRatePerNight()%>"
                                                                                <%=room.getId()==(request.getParameter("roomId")!=null?Integer.parseInt(request.getParameter("roomId")):-1)?"selected":""%>
                                                                                >
                                                                                Room #<%=room.getRoomNumber()%> —
                                                                                    <%=room.getRoomType()%> (Rs.
                                                                                        <%=String.format("%,.0f",room.getRatePerNight())%>
                                                                                            /night)
                                                                            </option>
                                                                            <% }} %>
                                                                    </select>
                                                                    <div class="invalid-feedback">Please select a room.
                                                                    </div>
                                                                </div>
                                                                <!-- Check-In -->
                                                                <div class="col-md-6">
                                                                    <label for="checkInDate"
                                                                        class="form-label fw-semibold">Check-In Date
                                                                        <span class="text-danger">*</span></label>
                                                                    <input type="date" class="form-control"
                                                                        id="checkInDate" name="checkInDate" required
                                                                        onchange="updateCost()"
                                                                        value="<%=request.getParameter("
                                                                        checkInDate")!=null?request.getParameter("checkInDate"):""%>">
                                                                    <div class="invalid-feedback">Check-in date is
                                                                        required.</div>
                                                                </div>
                                                                <!-- Check-Out -->
                                                                <div class="col-md-6">
                                                                    <label for="checkOutDate"
                                                                        class="form-label fw-semibold">Check-Out Date
                                                                        <span class="text-danger">*</span></label>
                                                                    <input type="date" class="form-control"
                                                                        id="checkOutDate" name="checkOutDate" required
                                                                        onchange="updateCost()"
                                                                        value="<%=request.getParameter("
                                                                        checkOutDate")!=null?request.getParameter("checkOutDate"):""%>">
                                                                    <div class="invalid-feedback">Check-out date must be
                                                                        after check-in.</div>
                                                                </div>
                                                                <!-- Estimated Cost Preview -->
                                                                <div class="col-12">
                                                                    <div class="alert alert-info d-flex justify-content-between align-items-center"
                                                                        id="costPreview"
                                                                        style="display:none!important;">
                                                                        <span><i
                                                                                class="fas fa-calculator me-2"></i>Estimated
                                                                            Total Cost:</span>
                                                                        <strong id="costAmount" class="fs-5">Rs.
                                                                            0.00</strong>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex gap-2">
                                                        <button type="submit" class="btn btn-primary btn-lg">
                                                            <i class="fas fa-save me-2"></i>Save Reservation
                                                        </button>
                                                        <a href="<%=request.getContextPath()%>/dashboard"
                                                            class="btn btn-outline-secondary btn-lg">
                                                            &times; Cancel
                                                        </a>
                                                    </div>
                                                </form>
                            </main>
                            <%@ include file="_footer.jsp" %>
                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script src="<%=request.getContextPath()%>/assets/js/scripts.js"></script>
                                <script>
// Live cost preview
function updateCost() {
  var roomh                                    n = document.getElementById('checkInDate').value;
  var checkout = document.get                                    entById('checkOutDate').value;
  var preview = document.getEl                                    tById('costPreview');
  var amount  = document.getElementB                                        unt');
  if (roomSel.value && che                                                checkout) {
    var rate = parseFloat(roomSel.options[roomSel.selectedIndex].dataset.                                     0;
    va                                         = new Date(checkin), d2 = new Date(checkout);
    var nights = Math.ceil((d2 -                                         / 86400000);
    if (nights >                                                preview.s e.display = 'flex';
      amount.textConten                                             ' + (nights  rate).toLocaleString('en-US', {minimumFractionDi                                            ;
      return;
    }
  }
  preview.style.display = 'none';
}
//                                             p validation
(function() {
  'use str                                                form = doc t.getElementById('reservat                                                 form.addEve Listener('submit', fu                                                    var checkin  = new Date(document                                                yId('checkIn te').value);
    var checkout = new Date(document.getEleme                                                kOutDate').value);
    if (che                                                    ) {
      document.getElement                                                    te').setCustomValidity('Check-out must be after check-in');
                                                       document.getElementById('checkOutDate').setCustomValidity('');
    }
    if (!form.                                                     { e.preventDefault(); e.stopPropagation(); }
    orm.classList.add('was-validated');
  }, false);
})();
                                </script>
                    </body>

                    </html>