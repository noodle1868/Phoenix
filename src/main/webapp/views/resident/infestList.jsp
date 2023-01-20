<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>은빛 우산</title>
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
 <div id="app">
      <jsp:include page="../sidebar.jsp"></jsp:include>
        <div id="main">
        <jsp:include page="../upbar.jsp"></jsp:include>
   <div class="page-heading">
       <h3>감염병 리스트</h3>
   </div>     
  <div class="card" style="margin-top:50px; ">
  <table class="table">
  <thead>
    <tr>
      <th>이름</th>
      <th>현재감염상태</th>
      <th>생년월일</th>
      <th>생활실</th>
    </tr>
  </thead>
  <tbody id="infestList">
  </tbody>
  
  	
</table>
	<div id="paging">
		<div>
			<ul class="pagination" id="pagination" style="padding-left:35%; margin-top: 10px; margin-bottom: 30px; text-align: center;"></ul>
		</div>
	</div>
</div>
</div>
</div>
	<script src="assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js"></script>
	 <script src="assets/js/bootstrap.bundle.min.js"></script>
	 <script src="assets/js/pages/dashboard.js"></script>
	 <script src="assets/js/main.js"></script>
</body>
<script>

var showPage = 1;
infestListCall(showPage);

function infestListCall(page){
	
	$.ajax({
		type:'get',
		url:'infestListCall',
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
				infestListCall(page);	
				}
				
			});
		},
		error:function(e){
			console.log(e);
		}
	});
	
}

/* var flag=true;
var pageflag=true;
var page2=1;
var select_change=new Array();
function infestSearch(page2){
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
		,url:'searchNotice'
		,dataType:'json'
		,data:{'select':select,'seacontent':seacontent,'page':page2}
		,success:function(data){
			console.log(data);
			listCall(data.list);
			if(pageflag == true && $('.pagination').data("twbs-pagination")
					|| select_change.at(-2) != $("#select").val()){
                $('.pagination').twbsPagination('destroy');
                pageflag=false;
            }
			$("#pagination").twbsPagination({
				startPage : 1 // 시작 페이지
				,totalPages : data.page_idx // 총 페이지 수
				,visiblePages : 4 // 기본으로 보여줄 페이지 수
				,onPageClick : function(e, page) { // 클릭했을때 실행 내용
					infestSearch(page);
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
} */

function drawList(list){
	var content = '';
	
	for (var i = 0; i < list.length; i++) {
		content +='<tr onclick=location.href="infestListHistory?re_idx='+list[i].re_idx+'">';
		content +='<td>'+list[i].re_name+'</td>';
		content +='<td>'+list[i].if_state+'</td>';
		content +='<td>'+list[i].re_jumin+'</td>';
		content +='<td>'+list[i].ro_name+'</td>';
	
		content +='</tr>';
	}
	
	$('#infestList').empty();
	$('#infestList').append(content);
}
</script>
</html>