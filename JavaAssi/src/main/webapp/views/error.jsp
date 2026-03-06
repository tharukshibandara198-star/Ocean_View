<%--============================================================error.jsp — Generic Error Page (404 /
    500)============================================================--%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
        <%@ page import="javax.servlet.http.HttpServletResponse" %>
            <% Integer statusCode=(Integer) request.getAttribute("javax.servlet.error.status_code"); String
                errorMsg=(String) request.getAttribute("javax.servlet.error.message"); if (statusCode==null)
                statusCode=500; if (errorMsg==null || errorMsg.trim().isEmpty()) { errorMsg=statusCode==404
                ? "The page you are looking for does not exist." : "An unexpected server error occurred." ; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Error <%= statusCode %> — Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
                </head>

                <body class="d-flex flex-column min-vh-100 justify-content-center align-items-center">
                    <div class="text-center p-5">
                        <i class="fas fa-<%= statusCode == 404 ? " map-signs" : "bug" %> fa-5x text-danger mb-4"></i>
                        <h1 class="display-1 fw-bold text-danger">
                            <%= statusCode %>
                        </h1>
                        <h3 class="mb-3">
                            <%= statusCode==404 ? "Page Not Found" : "Server Error" %>
                        </h3>
                        <p class="text-muted mb-4">
                            <%= errorMsg %>
                        </p>
                        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary me-2">
                            <i class="fas fa-home me-1"></i>Go to Dashboard
                        </a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Go Back
                        </a>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>