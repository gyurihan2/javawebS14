<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
  <jsp:include page="/WEB-INF/views/include/userPage/reservationSeatScript.jsp"/>
  <title>예약 페이지</title>
  <style>
		.material-symbols-outlined{
			color:#E2E2E2;
			background-color:#434343;
			font-size:70px;
			vertical-align:middle;
		  font-variation-settings:
		  'FILL' 0,
		  'wght' 400,
		  'GRAD' 0,
		  'opsz' 48
		}
		.divHover:hover{
			background:#cdcdcd;
			cursor: pointer;
		}
		
		.clickAction{
			background:#cdcdcd;
		}
		
	.dragNo
	{
	  -ms-user-select: none; 
	  -moz-user-select: -moz-none;
	  -khtml-user-select: none;
	  -webkit-user-select: none;
	  user-select: none;
	}
</style>
<script>
	'use strict';
	
	let today = new Date();
	let selectedDate;
	let scheduleArr=[];
	let dataIndex;
	let themaPrice;
	let totalPeaple=0;
	
	function selectDate(obj,date,index){
		console.log(date.substring(0,10));
		selectedDate = new Date(date.substring(0,10));
		dataIndex=index;
		
		$('.selectDateList').removeClass("clickAction");
		obj.className += ' clickAction';
		
		$.ajax({
			type:"post",
			url:"${ctp}/schedule/scheduleSelectDate",
			data:{selectDate:date.substring(0,10)},
			success:function(res){
				let temp='';
				
				if(res == "") temp="상영 일정이 없습니다.";
				else{
					scheduleArr= JSON.parse(res);
					console.log(scheduleArr);
					
					for(let i=0; i<scheduleArr.length;i++){
						temp+='<div class="divHover selectMovieList" onclick="selectMovie(this,'+i+')">';
						temp+= "("+scheduleArr[i].themaName+":"+scheduleArr[i].theaterName+")"+scheduleArr[i].movieTitle;
						temp+="</div>";
					}
				}
				
				// 초기화
				$("#reserTheater").html("");
				$("#reserMovie").html("");
				$("#reserTime").html("");
				$("#main_poster").removeAttr("src");
				
				$("#scheduleIdx").val("");
				$("#theaterIdx").val("");
				$("#movieIdx").val("");
				
				// 화면 표시
				$("#screenOrderContent").fadeOut('slow');
				$("#movieSelectContent").css("display","none");
				$("#movieSelectContent").html(temp);
				$("#movieSelectContent").fadeIn('slow');
				$("#reserDate").html(date);
				
				$("#scheduleIdx").val(date.scheduleIdx);
			},
			error:function(){
				alert("전송실패");
			}
		});
	}
	
	// 영화 선택시 
	function selectMovie(obj,arrIndex){
		$('.selectMovieList').removeClass("clickAction");
		obj.className += ' clickAction';
		
		let temp='';
		for(let i=0; i<scheduleArr[arrIndex].screenOrder.length;i++){
			
			if(dataIndex == 0){
				let todayMs = today.getTime();
				let startMs = new Date(selectedDate.getFullYear()+"-"+(selectedDate.getMonth()+1)+"-"+selectedDate.getDate()+" "+scheduleArr[arrIndex].playTime[i]);
				let endMs = new Date(selectedDate.getFullYear()+"-"+(selectedDate.getMonth()+1)+"-"+selectedDate.getDate()+" "+scheduleArr[arrIndex].endTime[i]);
				
				if(todayMs > startMs.getTime() && todayMs<endMs.getTime()){
					temp+='<div onclick="alert(\'이미 상영중인 영화 입니다.\')">';
					temp += (i+1)+"회 :"+scheduleArr[arrIndex].playTime[i].substring(0,5)+" (<font color='#C9BC46'>상영 중</font>)";
				}
				else if(todayMs < startMs.getTime()){
					temp+='<div class="divHover sreenOrderList" onclick="selectScreenOrder(this,'+arrIndex+','+i+')">';
					temp+= (i+1)+"회 :"+scheduleArr[arrIndex].playTime[i].substring(0,5)+" (<font color='#3CB371'>예약 가능</font> / 예약 가능 좌석 수:"+scheduleArr[arrIndex].leftSeat[i]+")";
				}
				else if(todayMs > startMs.getTime()){
					temp+='<div onclick="alert(\'상영 종료된 영화입니다.\')">';
					temp += (i+1)+"회 :"+scheduleArr[arrIndex].playTime[i].substring(0,5)+" (<font color='#DF6464'>상영 종료</font>)";
				}
			}
			else {
				temp+='<div class="divHover sreenOrderList" onclick="selectScreenOrder(this,'+arrIndex+','+i+')">';
				temp+= (i+1)+"회 :"+scheduleArr[arrIndex].playTime[i].substring(0,5)+"(<font color='#3CB371'>예약 가능</font>)";
			}
			
			temp+="</div>";
		}
		
		// 초기화
		$("#reserTime").html("");
		
		
		$("#scheduleIdx").val("");
		
		// 화면 표시 및 값 입력
		$("#screenOrderContent").css("display","none");
		$("#screenOrderContent").html(temp);
		$("#screenOrderContent").fadeIn('slow');
		$("#reserTheater").html(scheduleArr[arrIndex].theaterName);
		$("#reserMovie").html(scheduleArr[arrIndex].movieTitle);
		$("#main_poster").attr("src","https://image.tmdb.org/t/p/w500"+scheduleArr[arrIndex].main_poster);
		
		$("#theaterIdx").val(scheduleArr[arrIndex].theaterIdx);
		$("#movieIdx").val(scheduleArr[arrIndex].movieIdx);

	}
	// 상영 시간 선택시 
	function selectScreenOrder(obj,arrIndex,screenOrder){
		$('.sreenOrderList').removeClass("clickAction");
		obj.className += ' clickAction';
		
		$("#reserTime").html(scheduleArr[arrIndex].playTime[screenOrder].substring(0,5) +" ~ " + scheduleArr[arrIndex].endTime[screenOrder].substring(0,5));
		$("#scheduleIdx").val(scheduleArr[arrIndex].scheduleIdxList[screenOrder]);
	}
	
	// 예약 다음 버튼
	function nextReser(){
		let theaterIdx = $("#theaterIdx").val();
		let movieIdx = $("#movieIdx").val();
		let scheduleIdx = $("#scheduleIdx").val();
		const seatRowArr=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
		
		$.ajax({
			type:"post",
			url:"${ctp}/reservation/reservationGetSeat",
			data:{
				theaterIdx:theaterIdx,
				movieIdx:movieIdx,
				scheduleIdx:scheduleIdx
			},
			success:function(res){
				if(res =="") alert("일정이 없거나 잘못된 접근입니다.");
				
				res = JSON.parse(res);
				
				themaPrice = res.themaPrice;
				let totalSeat = res.totalSeat;
				let seatRow = totalSeat/20;
				if(totalSeat%20 > 0) seatRow++;
				
				$(".theaterSeat").html('<div class="screen"></div>');
				let temp='';
				let cnt=1;
				for(let i=0;i<seatRow-1;i++){
					temp +='<div class="row">';
					temp += '<span class="mr-1" style="width:27px">'+seatRowArr[i]+'열</span>';
					for(let j=0;j<20;j++){
						if(cnt > totalSeat) break;
						temp += '<div class="seat" id="'+(cnt++)+'" onclick="selectTest(this,'+i+','+j+')">';
						temp += '<font size="1em" style="vertical-align: top;">'+(j+1)+'</font>';
						temp += '</div>';
					}
					temp +='</div>';
				}
				$(".theaterSeat").html($(".theaterSeat").html()+temp);
				$("#shcheduleContent").fadeOut(500,function(){
					$("#theaterSeatContent").fadeIn(500);
					$("#nextButton").css("display","none");
					$("#prevButton").css("display","block");
					$("#resultReserContent").css("display","block");
				});
			},
			error:function(){
				alert("전송 실패");
			}
		});	
	}
	
	// 예약 이전 버튼
	function prevReser(){
		
		//초기화
		$("#price").html("0");
		$("#childResult").html("0");
		$("#nomalResult").html("0");
		totalPeaple=0;
		
		$("#theaterSeatContent").fadeOut(500,function(){
			$("#shcheduleContent").fadeIn(500);
			$("#nextButton").css("display","block");
			$("#resultReserContent").css("display","none");
			$("#prevButton").css("display","none");
		});
	}
	
	// 인원 증감
	function peopleCount(flag,people){
		let changeSu;
		let su;
		if(people == "nomal") {
			changeSu = parseInt($("#nomalResult").html());
			su = parseInt($("#childResult").html());
		}
		else{
			changeSu = parseInt($("#childResult").html());
			su = parseInt($("#nomalResult").html());
		}
		
		if(flag == -1){
			changeSu--;
			if(changeSu+su < totalPeaple){
				alert("선택한 좌석이 예매 인원 보다 많습니다.");
				changeSu++;
				return false;
			}
		}
		else changeSu++;
		
		if(changeSu > 10) {
			alert("최대 인원은 10명까지 가능 합니다.");
			return false;
		}
		else if(changeSu < 0){
			alert("최소 인원은 0명 이상 가능 합니다.");
			return false;
		}
		
		let totprice=0;
		if(people == "nomal") {
			$("#nomalResult").html(changeSu);
			totprice += changeSu*themaPrice
			totprice += su*(themaPrice-3000);
		}
		else{
			$("#childResult").html(changeSu);
			totprice += changeSu*(themaPrice-3000)
			totprice += su*themaPrice;
		}
		
		totalPeaple = changeSu+su;
		$("#price").html(totprice);
	}
	
	// 좌석 선택
	function selectTest(obj,row,col){
		let totSelected = $('.selected').length
		
		if(totalPeaple == 0){
			alert("인원을 먼저 선택 하세요");
			return false;
		}
		
		if(obj.className.indexOf("selected") == -1 && totalPeaple <= totSelected){
			alert("등록 가능한 인원을 초과했습니다.");
			return false;
		}
		else if(obj.className.indexOf("selected") == -1)totSelected--;
		else totSelected++;
		
		obj.classList.toggle('selected');
		
		console.log(obj.id);
		console.log(obj.className);	
	}
	
</script>  
</head>
<body id="wrapper">
<p><br/></P>
<div class="container-xl text-center  p-0" id="shcheduleContent" style="width:1010px;height: 500px; background-color: #FBF8EE">
  <div class="d-flex justify-content-start" style="height: 100%">
  	<!-- 날짜 선택 -->
  	<div class="d-flex flex-column">
  		<div class=" ml-1" style="width: 200px;  background-color: #333333"><font color="#E2E2E2">날짜</font></div>
  		<c:forEach var="vo" items="${dateVOS}" varStatus="st">
  			<div><button class="btn btn-outline-dark selectDateList" type="button" onclick="selectDate(this,'${vo}','${st.index}')">${vo}</button></div>
  		</c:forEach>
  	</div>
  	<!-- 영화 선택 -->
  	<div class="d-flex flex-column" >
  		<div class=" ml-1" style="width: 400px;  background-color: #333333;"><font color="#E2E2E2">영화</font></div>
  		<div class="ml-2" id="movieSelectContent" style="text-align: left; display: none;" ></div>
  	</div>
  	<!-- 영화 회차 선택 -->
  	<div class="d-flex flex-column" >
  		<div class=" ml-1" style="width: 400px;  background-color: #333333"><font color="#E2E2E2">시간</font></div>
  		<div id="screenOrderContent" style=" display: none"></div>
  	</div>
  </div>
</div>
<!-- 좌석 정보 -->
<div class="container-xl text-center  p-0 dragNo" id="theaterSeatContent" style="width:1010px;height: 500px; background-color: #FBF8EE; display: none" >
	<div id="theaterSeatList" style="width:1010px;height: 500px;">
		 <ul class="showcase">
	    <li>
	      <div class="seat"></div>
	      <small>예매가능</small>
	    </li>
	    <li>
	      <div class="seat occupied"></div>
	      <small>예매불가</small>
	    </li>
	  </ul>
		<div class="theaterSeat">
			<div class="screen"></div>
		</div>
	</div>
</div>
<!-- 요약 정보 -->
<div style="background-color: #1D1D1C; height: 150px">
	<div class="container-xl text-center d-flex justify-content-start p-0" style="width:1010px; height: 100%">
		<div class="d-flex flex-column " style="width: 140px;  height:100%;">
  		<div class="mt-4" id="prevButton" style="display: none;">
				<button class="p-0 ml-2 text-center" type="button" style="border: 1px solid #E2E2E2;" onclick="prevReser()">
					<span class="material-symbols-outlined" style="transform: rotate( 180deg );">arrow_forward_ios</span>
				</button>
  		</div>
  	</div>
  	<!-- 영화 이미지 -->
		<div class="d-flex justify-content-center mr-1 " style="width: 150px; height:100%; background-color: #333333">
			<div><img id="main_poster" width="100px"/></div>
  	</div>
		<div class="d-flex flex-column">
  		<div class="" style="width: 500px;  background-color: #333333"><font color="#E2E2E2">예약 정보</font></div>
  		<div style="color: #808080;">일시: <span id="reserDate"></span></div>
  		<div style="color: #808080;">상영관: <span id="reserTheater"></span></div>
  		<div style="color: #808080;">영화: <span id="reserMovie"></span></div>
  		<div style="color: #808080;">시간: <span id="reserTime"></span></div>
  	</div>
		<div class="d-flex flex-column " style="width: 140px;  height:100%;">
  		<div class="mt-4" id="nextButton">
				<button class="p-0 ml-2 text-center" type="button" style="border: 1px solid #E2E2E2;" onclick="nextReser()">
					<span class="material-symbols-outlined">arrow_forward_ios</span>
				</button>
  		</div>
  		<div id="resultReserContent" style="display: none; color:#E2E2E2;">
  			<div class="d-flex justify-content-end mb-2">
					<div>성인</div>
					<input type='button' class="mr-2 ml-2" value='-' onclick='peopleCount(-1,"nomal")' style="width: 24px;"/>
					<div id='nomalResult' class="mr-2">0</div>
				  <input type='button' value='+' onclick='peopleCount(1,"nomal")' style="width: 24px;"/>
				</div>
				<div class="d-flex justify-content-end mb-2">
					<div>어린이</div>
					<input type='button' class="mr-2 ml-2" value='-' onclick='peopleCount(-1,"child")' style="width: 24px;"/>
					<div id='childResult' class="mr-2">0</div>
				  <input type='button' value='+' onclick='peopleCount(1,"child")' style="width: 24px;"/>
				</div>
				<div>
					<div class="mb-2">총 가격: <span id="price">0</span></div>
				</div>
				<div class="d-flex justify-content-end">
					<button type="button" class="btn btn-info">결제하기</button>
				</div>
  		</div>
  	</div>
	</div>
</div>
<input type="hidden" name="theaterIdx" id="theaterIdx">
<input type="hidden" name="movieIdx" id="movieIdx">
<input type="hidden" name="scheduleIdx" id="scheduleIdx">
<input type="hidden" name="nomalPeople" id="nomalPeople">
<input type="hidden" name="childPeople" id="childPeople">
<p><br/></P>
</body>
</html>