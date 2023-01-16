<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<!-- 은빛 우산 부트스트랩 -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="assets/css/bootstrap.css">
<link rel="stylesheet" href="assets/vendors/iconly/bold.css">
<link rel="stylesheet" href="assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
<link rel="stylesheet" href="assets/vendors/bootstrap-icons/bootstrap-icons.css">
<link rel="stylesheet" href="assets/css/app.css">
<script src="assets/js/jquery.twbsPagination.js"></script>
</head>
<body>
	<!-- Hoverable rows start -->
    <section class="section">
        <div class="row" id="table-hover-row">
            <div class="col-12">
                <div class="card">
                	<div class="card-header" style="padding-bottom: 0px; padding-top: 20px;">
                        <h3 class="card-title">사용할 수 있는 비품 조회</h3>
                        <p>사용할 비품을 눌러 주세요.</p>
                    </div>
			       <div class="card-header" style="background-color: #435EBE; font-weight: bold; font-size: large; color: white;">
			           비품 이름 : <input type="text" name="thName" class="filter"> &nbsp;&nbsp;
			           <button class="btn btn-secondary" onclick="search(page2)">검색</button>
					</div>
                        <!-- table hover -->
                        <div class="table-responsive">
                            <table class="table table-hover mb-0" style="text-align: center;">
                                <thead>
                                    <tr>
                                        <th>순번</th>
                                        <th>비품 이름</th>
                                    </tr>
                                </thead>
                                <tbody id="list">
                                	<!-- 리스트가 들어갈 공간 -->
                                </tbody>
                            </table>
                        </div>
                        <ul class="pagination" id="pagination" style="margin-left: auto; margin-right: auto; margin-top: 10px; margin-bottom: 10px;"></ul>
                    </div>
                </div>
            </div>
    </section>
    <!-- Hoverable rows end -->
</body>
<script>
	var showPage=1;
	ListCall(showPage);
	
	function ListCall(page){
		$.ajax({
			type:'GET',
			url:'getThingHistoryList.do',
			data:{page:page},
			dataType:'JSON',
			success:function(data){
				drawList(data.list);
				$("#pagination").twbsPagination({
					startPage : 1, // 시작 페이지
					totalPages : data.total, // 총 페이지 수
					visiblePages : 3, // 기본으로 보여줄 페이지 수
					onPageClick : function(e, page) { // 클릭했을때 실행 내용
						ListCall(page)
					}
				});
			},
			error:function(e){
				console.log(e);
			}
		});
	}
	
	function drawList(hisList){
		var content='';
		for(var i=0; i<hisList.length;i++){
			content +='<tr class="hisRow" onclick="hisRow($(this))" style="cursor: pointer;">';
			if(hisList[i].his_idx != 0){
				content +='<td class="hisIdx">'+hisList[i].his_idx+'</td>';
			}else{
				content +='<td class="hisIdx">이력없음</td>';
			}
			
			content +='<td class="thName">'+hisList[i].th_name+'</td>';
			content +='</tr>';
		}
		$('#list').empty();
		$('#list').append(content);
	}
	
	var flag=true;
	var pageflag=true;
	var page2=1;
	var chkPage=new Array();
	function search(page2){
		var name = $('.section input[name=thName]').val();
		if(flag){
			flag=false;
			$.ajax({
				type:'GET',
				url:'getPopThHisSearch.do',
				data:{'page':page2, thName:name},
				dataType:'JSON',
				success:function(data){
					drawList(data.list);
					chkPage.push(data.total);
					if(chkPage.at(-2) != data.total){
	    				pageflag=true;
	    			}
					if(pageflag == true && $('.pagination').data("twbs-pagination")){
	                    $('.pagination').twbsPagination('destroy');
	                    pageflag=false;
	                }
					$("#pagination").twbsPagination({
	    				startPage : 1 // 시작 페이지
	    				,totalPages : data.total // 총 페이지 수
	    				,visiblePages : 5 // 기본으로 보여줄 페이지 수
	    				,onPageClick : function(e, page) { // 클릭했을때 실행 내용
	    					search(page);
	    				}
	    			});
				},
				error:function(e){
					console.log(e)
				},complete:function(){
	    			flag=true;
	    		}
			});
		}
	}
	
	function hisRow(hisRow){
		var hisIdx = hisRow.find('.hisIdx').text();
		var thName = hisRow.find('.thName').text();
		opener.choiceRow(thName);
		window.close()
	}
</script>
</html>