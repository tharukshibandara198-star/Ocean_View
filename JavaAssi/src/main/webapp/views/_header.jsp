<%@ page import="com.oceanview.model.User" %>
<%
User cu = (User) session.getAttribute("loggedInUser");
String cp = request.getContextPath();
String uri = request.getRequestURI();
String act = request.getParameter("action");
%>
<nav class="navbar navbar-expand-lg navbar-dark">
<div class="container-fluid">
<a class="navbar-brand d-flex align-items-center" href="<%=cp%>/dashboard">
<i class="fas fa-water me-2"></i><strong>Ocean View Resort</strong>
</a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
<span class="navbar-toggler-icon"></span>
</button>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav me-auto">
<li class="nav-item">
<a class="nav-link <%=uri.contains("dashboard")?"active":""%>" href="<%=cp%>/dashboard">
<i class="fas fa-home me-1"></i>Dashboard</a>
</li>
<li class="nav-item">
<a class="nav-link <%=(uri.contains("reservation")&&!"view".equals(act))?"active":""%>" href="<%=cp%>/reservation">
<i class="fas fa-plus-circle me-1"></i>Add Reservation</a>
</li>
<li class="nav-item">
<a class="nav-link <%=(uri.contains("reservation")&&"view".equals(act))?"active":""%>" href="<%=cp%>/reservation?action=view">
<i class="fas fa-search me-1"></i>View Reservation</a>
</li>
<li class="nav-item">
<a class="nav-link <%=uri.contains("bill")?"active":""%>" href="<%=cp%>/bill">
<i class="fas fa-file-invoice me-1"></i>Bill</a>
</li>
<li class="nav-item">
<a class="nav-link <%=uri.contains("reports")?"active":""%>" href="<%=cp%>/reports">
<i class="fas fa-chart-bar me-1"></i>Reports</a>
</li>
<li class="nav-item">
<a class="nav-link <%=uri.contains("help")?"active":""%>" href="<%=cp%>/help">
<i class="fas fa-question-circle me-1"></i>Help</a>
</li>
</ul>
<ul class="navbar-nav">
<li class="nav-item d-flex align-items-center me-3">
<span class="text-white-50 small">
<i class="fas fa-user-circle me-1"></i>
<%=cu!=null?cu.getFullName():"Staff"%>
<% String role=cu!=null?cu.getRole():"";
   String bc="ADMIN".equals(role)?"bg-warning text-dark":"bg-secondary"; %>
<span class="badge ms-1 <%=bc%>"><%=role%></span>
</span>
</li>
<li class="nav-item">
<a class="btn btn-outline-light btn-sm" href="<%=cp%>/logout">
<i class="fas fa-sign-out-alt me-1"></i>Logout</a>
</li>
</ul>
</div>
</div>
</nav>
