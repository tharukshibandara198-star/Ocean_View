<%--============================================================login.jsp — Staff Login
    Page============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login — Ocean View Resort</title>
            <!-- Bootstrap 5 -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Font Awesome icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <!-- Custom stylesheet -->
            <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
        </head>

        <body class="login-body">

            <div class="login-wrapper">
                <!-- ── Logo / Branding ───────────────────────────────── -->
                <div class="login-brand text-center mb-4">
                    <i class="fas fa-water fa-3x brand-icon"></i>
                    <h1 class="brand-title mt-2">Ocean View Resort</h1>
                    <p class="brand-subtitle">Hotel Reservation System</p>
                </div>

                <!-- ── Login Card ────────────────────────────────────── -->
                <div class="card login-card shadow-lg">
                    <div class="card-header text-center">
                        <h4 class="mb-0"><i class="fas fa-lock me-2"></i>Staff Login</h4>
                    </div>
                    <div class="card-body p-4">

                        <%-- Server-side error message --%>
                            <% if (request.getAttribute("errorMsg") !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <%= request.getAttribute("errorMsg") %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                    <!-- Login form -->
                                    <form action="<%= request.getContextPath() %>/login" method="post" id="loginForm"
                                        novalidate>

                                        <!-- Username -->
                                        <div class="mb-3">
                                            <label for="username" class="form-label fw-semibold">
                                                <i class="fas fa-user me-1"></i>Username
                                            </label>
                                            <input type="text" class="form-control form-control-lg" id="username"
                                                name="username" value="<%= request.getAttribute(" enteredUsername")
                                                !=null ? request.getAttribute("enteredUsername") : "" %>"
                                            placeholder="Enter your username"
                                            required autofocus>
                                            <div class="invalid-feedback">Please enter your username.</div>
                                        </div>

                                        <!-- Password -->
                                        <div class="mb-4">
                                            <label for="password" class="form-label fw-semibold">
                                                <i class="fas fa-key me-1"></i>Password
                                            </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control form-control-lg"
                                                    id="password" name="password" placeholder="Enter your password"
                                                    required>
                                                <!-- Toggle password visibility -->
                                                <button class="btn btn-outline-secondary" type="button"
                                                    onclick="togglePassword()" title="Show/Hide password">
                                                    <i class="fas fa-eye" id="eyeIcon"></i>
                                                </button>
                                            </div>
                                            <div class="invalid-feedback">Please enter your password.</div>
                                        </div>

                                        <!-- Submit -->
                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-primary btn-lg" id="loginBtn">
                                                <i class="fas fa-sign-in-alt me-2"></i>Login
                                            </button>
                                        </div>
                                    </form>
                    </div>

                    <!-- Demo credentials hint (for student/demo use only) -->
                    <div class="card-footer text-center text-muted small py-3">
                        <i class="fas fa-info-circle me-1"></i>
                        Demo login: <strong>admin</strong> / <strong>admin123</strong>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Custom scripts -->
            <script src="<%= request.getContextPath() %>/assets/js/scripts.js"></script>
            <script>
                // Client-side validation before form submission
                document.getElementById('loginForm').addEventListener('submit', function (e) {
                    const username = document.getElementById('username').value.trim();
                    const password = document.getElementById('password').value.trim();
                    let valid = true;

                    if (!username) {
                        document.getElementById('username').classList.add('is-invalid');
                        valid = false;
                    } else {
                        document.getElementById('username').classList.remove('is-invalid');
                    }

                    if (!password) {
                        document.getElementById('password').classList.add('is-invalid');
                        valid = false;
                    } else {
                        document.getElementById('password').classList.remove('is-invalid');
                    }

                    if (!valid) e.preventDefault();
                });

                // Toggle password visibility
                function togglePassword() {
                    const pwdInput = document.getElementById('password');
                    const icon = document.getElementById('eyeIcon');
                    if (pwdInput.type === 'password') {
                        pwdInput.type = 'text';
                        icon.classList.replace('fa-eye', 'fa-eye-slash');
                    } else {
                        pwdInput.type = 'password';
                        icon.classList.replace('fa-eye-slash', 'fa-eye');
                    }
                }
            </script>
        </body>

        </html>