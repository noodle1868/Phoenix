<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/bootstrap.css">
    <link rel="stylesheet" href="assets/vendors/iconly/bold.css">
    <link rel="stylesheet" href="assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
    <link rel="stylesheet" href="assets/vendors/bootstrap-icons/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/app.css">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="assets/js/jquery.twbsPagination.js"></script>
<style>

</style>
</head>
<body>
<%
int hope = (int)session.getAttribute("hope");
System.out.println(hope);
%>
 <div id="app">
	<c:set var = "power" scope = "session" value = "${hope}"/>
		<c:choose>
		<c:when test="${power == 1}">
			<jsp:include page="../adminsidebar.jsp"></jsp:include>
		</c:when>
		<c:when test="${power == 2}">
			<jsp:include page="../adminsidebar.jsp"></jsp:include>
		</c:when>
		<c:otherwise>
		<jsp:include page="../sidebar.jsp"></jsp:include>
		</c:otherwise>
		</c:choose>
        <div id="main">
        <jsp:include page="../upbar.jsp"></jsp:include>
   <div class="page-heading">
       <h3>후원금 리스트 수정</h3>
   </div>
  <section class="row">
  	<div class="card">
  		<div class="card-body py-4 px-5">
  <form action="donationUpdate" method="post">
  <button  class="btn btn-primary">수정</button>     
  <table class="table">
  <thead>
    <tr>  
      <th scope="col" style="width:20%;">날짜</th>
      <td>
      	<input type="text" name="do_date" style="width: 100%;" value="${donation.do_date}"/>	
      </td>
    </tr> 
    <tr>  
      <th scope="col" style="width:20%;">후원자</th>
      <td>
      	<input type="text" name="do_name" style="width: 100%;" value="${donation.do_name}" />	
      </td>
    <tr>  
      <th scope="col" style="width:20%;">후원목적</th>
      <td>
      	<input type="text" name="do_goal" style="width: 100%;" value="${donation.do_goal}"/>	
      </td>
    </tr> 
    <tr>  
      <th scope="col" style="width:20%;">등록자</th>
      <td>
      	<input type="text" name="do_write" style="width: 100%;" value="${donation.do_write}"/>	
      </td>
    </tr>
    <tr>  
      <th scope="col" style="width:20%;">금액</th>
      <td>
      	<input type="text" name="do_money" style="width: 100%;" value="${donation.do_money}"/>	
      </td>
    </tr>
    
  </thead>
</table>
<input type="hidden" name="do_idx" value="${donation.do_idx}">
</form>
</div>
</div>
</section>
<footer>
	<div class="footer clearfix mb-0 text-muted">
		<div class="float-start">
			<p>2023 Final Project</p>
		</div>
	<div class="float-end">
		<p>
			Create With <span class="text-danger"><i
				class="bi bi-heart"></i></span> by <a href="http://ahmadsaugi.com">Gudi</a>
		</p>
	</div>
	</div>
</footer>
</div>
</div>
	<script src="assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js"></script>
	 <script src="assets/js/bootstrap.bundle.min.js"></script>
	 <script src="assets/js/pages/dashboard.js"></script>
	 <script src="assets/js/main.js"></script>
</body>
<script>

</script>
</html>