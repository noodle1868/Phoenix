<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
<link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/bootstrap.css">
    <link rel="stylesheet" href="assets/vendors/iconly/bold.css">
    <link rel="stylesheet" href="assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
    <link rel="stylesheet" href="assets/vendors/bootstrap-icons/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/app.css">




</head>
 <script src="assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js"></script>
 <script src="assets/js/bootstrap.bundle.min.js"></script>
 <script src="assets/js/pages/dashboard.js"></script>
 <script src="assets/js/main.js"></script>
<body>


<div id="app">
      <jsp:include page="../sidebar.jsp"></jsp:include>
        <div id="main">
        <jsp:include page="../upbar.jsp"></jsp:include>
         <!-- 여기 안에서 개발  -->
         
         


         <span>
         <form action="residentdetail" method="get">
         
                         <section class="section">
                    
                                    <div class="table-responsive">
                                        <table class="table table-borderless mb-0">
                                                <tr>
                                                    <th>입소자</th>                                                   
                                                    <td>${rd.re_name}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>주민번호</th>                                                   
                                                    <td>${rd.re_jumin}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>성별</th>                                                   
                                                    <td>${rd.re_gender}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>휴대폰</th>                                                   
                                                    <td>${rd.re_pnum}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>입소일</th>                                                   
                                                    <td>${rd.re_date}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>주소</th>                                                   
                                                    <td>${rd.re_addr}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>상세주소</th>                                                   
                                                    <td>${rd.re_daddr}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>생활실</th>                                                   
                                                    <td>${rd.ro_name}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>등급</th>                                                   
                                                    <td>${rd.re_grade}</td>                                                   
                                                </tr>
                                                <tr>
                                                    <th>현황</th>                                                   
                                                    <td>${rd.re_state}</td>                                                   
                                                </tr>
                                                
                          
                                        </table>
                                    </div>                                
                </section>

		<div class="buttons">
               <a href="resident" class="btn btn-primary">리스트</a>			
               <a href="residentdetail.go?re_idx=${rd.re_idx}" class="btn btn-primary">수정</a>			
		</form>
         </span>
         
         
         
         

         
         
         
         
         
         
         
         
       </div>
</div>
</body>
<script>


</script>
</html>