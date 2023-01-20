<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>은빛 우산</title>
    <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/bootstrap.css">
    <link rel="stylesheet" href="assets/vendors/iconly/bold.css">
    <link rel="stylesheet" href="assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
    <link rel="stylesheet" href="assets/vendors/bootstrap-icons/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/app.css">
    <script src="assets/js/jquery.twbsPagination.js"></script>
</head>

<style>
</style>
<body>
	<div id="app">
		<jsp:include page="../sidebar.jsp"></jsp:include>
		<div id="main">
			<jsp:include page="../upbar.jsp"></jsp:include>
		
			<div class="page-heading">
				<h3>후원금 리스트</h3>
			</div>
		    <div class="page-content">
		    <!-- Hoverable rows start -->
		    <section class="row">
		        <div class="care" id="table">
				<button onclick="location.href='donationWriteForm'" class="btn btn-primary" >글작성</button>
		            <div class="card-body py-4 px-5">
		                <div class="d-flex align-items-center">
		          			<table class="table table-bordered table-hover" style="text-align: center;">
		                           <thead>
		                               <tr>
		                                   <th>순번</th>
		                                   <th>날짜</th>
		                                   <th>후원자</th>
		                                   <th>등록자</th>
		                                   <th>금액</th>
		                               </tr>
		                           </thead>
		                           <tbody id="donationlist">
		                           	<!-- 리스트가 들어가는 공간 -->
		                           </tbody>
		                       </table>
		                       </div>
		                       </div>
		                       <div class="card-body py-4 px-5" style="margin:0 auto;">
								<div>
								<select id="select">
									<option value="title">후원자</option>
									<option value="write">등록자</option>
								</select> <input type="text" name="seacontent" id="seacontent">
								<button id="search" type="button" class="btn btn-primary btn-sm" onclick="donationSearch(page2)">검색</button>
								</div>
		                   </div>
							<div class="card-body py-4 px-5" style="margin:0 auto;">
							<div id="pagint">
								<div class="container">
									<nav aria-label="Page navigation" style="text-align: center;" style="margin" >
										<ul class="pagination" id="pagination"></ul>
									</nav>
							 </div>
						 </div>
					  </div>
		            </div>	
		    </section>
		   </div>
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

var url=window.location.search.split('?do_idx=')[1];
console.log("idx 값 : "+url);

var showPage = 1;
donationListCall(showPage);


function donationListCall(page){
	
	$.ajax({
		type:'get',
		url:'donationListCall',
		data:{page:page},
		dataType:'json',
		success:function(data){
			//console.log(data);
			drawList(data.list);
			
			$('#pagination').twbsPagination({
				startPage:1,
				totalPages:data.total,
				visiblePages:5,
				onPageClick:function(e, page){
					//console.log(e);
					//console.log(page);
				donationListCall(page);	
				}
				
			});
		},
		error:function(e){
			console.log(e);
		}
	});
	
}

var flag=true;
var pageflag=true;
var page2=1;
var select_change=new Array();
var chkPage=new Array();
function donationSearch(page2){
	select_change.push($("#select").val());
	if(flag){
    var select=$("#select").val();
    var seacontent=$("#seacontent").val();
	flag=false;
	if(seacontent == ""){
		window.location.reload();
	}
	
	$.ajax({
		type:'get'
		,url:'searchdonation'
		,dataType:'json'
		,data:{'select':select,'seacontent':seacontent,'page':page2}
		,success:function(data){
			drawList(data.list);
			chkPage.push(data.page_idx);
			if(chkPage.at(-2) != data.page_idx){
				pageflag=true;
			}
			if(pageflag == true && $('.pagination').data("twbs-pagination")
					|| select_change.at(-2) != $("#select").val()){
                $('.pagination').twbsPagination('destroy');
                pageflag=false;
            }
			$("#pagination").twbsPagination({
				startPage : 1 // 시작 페이지
				,totalPages : data.page_idx // 총 페이지 수
				,visiblePages : 4 // 기본으로 보여줄 페이지 수
				,initiateStartPageClick:false
				,onPageClick : function(e, page) { // 클릭했을때 실행 내용
					noticeSearch(page);
				}
			});
		}
		,error:function(e){
			console.log(e);
		},complete:function(){
			flag=true;
		}
	});
	}
}


function drawList(list){
	var content = '';
	
	for (var i = 0; i < list.length; i++) {
		content +='<tr onclick=location.href="donationUpdateForm?do_idx='+list[i].do_idx+'">';
		content +='<td>'+list[i].do_idx+'</td>';
		content +='<td>'+list[i].do_date+'</td>';
		content +='<td>'+list[i].do_name+'</td>';
		content +='<td>'+list[i].do_write+'</td>';
		content +='<td>'+list[i].do_money+'</td>';
		content +='</tr>';
	}
	
	$('#donationlist').empty();
	$('#donationlist').append(content);
}
</script>
    