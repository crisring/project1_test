<%@page import="manager.util.SearchVO"%>
<%@page import="manager.util.BoardUtil"%>
<%@page import="java.sql.SQLException"%>
<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@page import="manager.saleslist.OrderVO"%>
<%@page import="java.util.List"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="상품 리스트"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리 페이지</title>

<!-- 부트스트랩 CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>

<!-- 내가 쓴 스타일과 스크립트 -->
<link rel="shortcut icon"
	href="http://localhost/jsp_prj/common/images/favicon.ico" />
<link rel="stylesheet" type="text/css"
	href="http://localhost/jsp_prj/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://localhost/project1/common/css/main_Sidbar.css">

<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<!-- 상태 아이콘 스타일 -->
<style type="text/css">
#status-container {
	min-height: 100px;
	display: flex;
	justify-content: flex-start;
	padding: 20px;
	gap: 20px;
}

.status-item {
	text-align: center;
	margin: 0;
}

.icon {
	width: 50px;
	height: 50px;
	border-radius: 50%;
	background-color: #7a7a7a;
	margin-bottom: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-size: 24px;
}

.status-item span {
	display: block;
}

.icon.all::before {
	content: "\f00a";
}

.icon.on-sale::before {
	content: "\f07a";
}

.icon.sale-completed::before {
	content: "\f07a";
}

.icon.sale-ended::before {
	content: "\f07a";
}
</style>

<!-- 검색 섹션 스타일 -->
<style type="text/css">
#search-container {
	display: flex;
	flex-direction: column;
	gap: 20px;
	padding: 20px;
	max-width: 1500px;
	margin: 0 auto;
	border: 1px solid #ddd;
}

.search-item {
	display: flex;
	align-items: center;
	gap: 10px;
	justify-content: flex-start;
}

.search-item label {
	width: 150px;
}

.search-item input[type="text"], .search-item input[type="date"],
	.search-item select {
	flex-grow: 1;
	max-width: 500px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.checkbox-group {
	display: flex;
	gap: 15px;
}

.checkbox-group label {
	display: flex;
	align-items: center;
}

.button-group {
	display: flex;
	justify-content: center;
	gap: 20px;
}

.btn-search, .btn-reset {
	padding: 12px 30px;
	font-size: 16px;
	border-radius: 5px;
}

.btn-search {
	background-color: #48c774;
	color: white;
	border: none;
}

.btn-reset {
	background-color: #ddd;
	color: black;
	border: none;
}
</style>

<!-- 저장 버튼 스타일 -->
<style type="text/css">
.btn-save {
	background-color: #48c774;
	color: white;
	border: none;
	border-radius: 5px;
}
</style>


<!-- 취소,교환, 선택삭제 -->
<style type="text/css">
.product-list-actions {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 0;
}

.product-count {
	font-size: 14px;
	display: flex;
	gap: 10px;
}

.select-delete-btn {
	padding: 8px 20px;
	font-size: 14px;
	background-color: #ddd;
	border: none;
	border-radius: 5px;
}

.action-buttons {
	display: flex;
	margin-left: 500px;
}

.action-buttons button {
	padding: 10px 20px;
	font-size: 14px;
	border-radius: 5px;
	background-color: #48c774;
	color: white;
	border: none;
}

/* 테이블의 폰트 크기도 조정 가능 */
table {
	font-size: 14px;
	text-align: center;
}

.btn-save {
	padding: 10px 20px;
	font-size: 14px;
	background-color: #48c774;
	color: white;
	border: none;
	border-radius: 5px;
}

/* 페이지네이션 */
#pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	text-align: center;
}

#order-status {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: white;
	cursor: pointer;
	border-radius: 8px;
	background-color: white;
	background-color: white;
}
</style>

<script type="text/javascript">
	$(function() {

		$("#date-range").change(function() {
			let currentDate = new Date();

			// 종료 날짜 설정
			var endDate = new Date();

			switch ($(this).val()) {
			case 'today':
				endDate = currentDate; // 오늘 날짜
				break;
			case '1-week':
				endDate.setDate(currentDate.getDate() + 7);
				break;
			case '1-month':
				endDate.setMonth(currentDate.getMonth() + 1);
				break;
			case '3-months':
				endDate.setMonth(currentDate.getMonth() + 3);
				break;
			case '6-months':
				endDate.setMonth(currentDate.getMonth() + 6);
				break;
			case '1-year':
				endDate.setFullYear(currentDate.getFullYear() + 1);
				break;
			default:
				endDate = currentDate; // 기본은 오늘 날짜
				break;
			}

			// 날짜 값을 설정 (YYYY-MM-DD 형식)
			$("#start-date").val(formatDate(currentDate));
			$("#end-date").val(formatDate(endDate));
		}); // change
	})// ready

	//날짜 포맷팅 함수 (YYYY-MM-DD)
	function formatDate(date) {
		var year = date.getFullYear();
		var month = (date.getMonth() + 1).toString().padStart(2, '0');
		var day = date.getDate().toString().padStart(2, '0');
		return year + '-' + month + '-' + day;
	}
</script>


<script type="text/javascript">
	$(function() {
		// 전체 선택 체크박스 클릭 이벤트
		$('#select-all').click(function() {
			// 체크박스의 체크 상태에 따라 모든 체크박스 선택/해제
			$('.chk').prop('checked', this.checked);
		});
	});
</script>

<!-- 게시물 수 검색  -->
<script type="text/javascript">
	$(function() {

		// 카운트 업데이트
		$('#all .count').text(totalOrdersStatusCnt() + ' 건');
		$('#on-sale .count').text(getOrdersCount("구매확정") + ' 건');
		$('#sale-completed .count').text(getOrdersCount("결제완료") + ' 건');
		$('#sale-ended .count').text(getOrdersCount("취소요청") + ' 건');

	})// ready

	function totalOrdersStatusCnt() {
		var cnt = 0;

		// AJAX 요청을 통해 판매 수량을 가져옵니다.
		$.ajax({
			url : "ordersTotalCnt.jsp",
			type : "get",
			async : false,
			dataType : "json",
			error : function(xhr) {
				console.log("Error: " + xhr.status);
			},
			success : function(jsonObj) {
				cnt = jsonObj.rowCnt;
			}
		});

		return cnt;
	}// totalOrdersStatusCnt

	function getOrdersCount(ordersStatus) {
		var cnt = 0;

		// AJAX 요청을 통해 판매 수량을 가져옵니다.
		$.ajax({
			url : "ordersCnt.jsp",
			type : "get",
			data : {
				ordersStatus : ordersStatus
			// 선택된 상태만 전달
			},
			async : false,
			dataType : "json",
			error : function(xhr) {
				console.log("Error: " + xhr.status);
			},
			success : function(jsonObj) {
				cnt = jsonObj.rowCnt;
			}
		});

		return cnt;
	}// getOrdersCount
</script>

<!-- 배송+주문 상태 변경  -->
<script type="text/javascript">
	$(function() {
		$("#btnSubmit").click(function() {
			var checkedOrderIds = getCheckedOrderIds();
			var selecteddeliveryType = $("#sale-type").val();
			var selectedOrderType = $("#order-type").val();

			if (checkedOrderIds.length > 0) {
				if (selecteddeliveryType || selectedOrderType) {
					$.ajax({
						url : 'updateBothStatus.jsp',
						type : 'POST',
						data : {
							deliveryType : selecteddeliveryType,
							orderType : selectedOrderType,
							orderIds : checkedOrderIds
						},
						traditional : true,
						success : function(response) {
							alert("변경이 성공적으로 완료되었습니다.");
							location.reload();
						},
						error : function(xhr) {
							alert("변경 중 오류가 발생했습니다.");
							console.log(xhr.status);
						}
					});
				} else {
					alert("변경할 상태를 선택해주세요.");
				}
			} else {
				alert("변경할 항목을 선택해 주세요.");
			}
		});
	});

	// 체크된 체크박스의 orderId 값을 배열로 반환하는 함수
	function getCheckedOrderIds() {
		return $('.chk:checked').map(function() {
			return $(this).data("orderid");
		}).get();
	}

	// 상태 업데이트 함수
	function updateStatus(url, data) {
		$.ajax({
			url : url,
			method : 'POST',
			data : data,
			traditional : true,
			success : function(response) {
				alert("변경이 성공적으로 완료되었습니다.");
			},
			error : function(xhr) {
				alert("변경 중 오류가 발생했습니다.");
				console.log(xhr.status);
			}
		});
	}
</script>


<!-- 선택 삭제 -->
<script type="text/javascript">
	$(function() {

		$("#deleteBtn").click(function() {
			deleteData();

		})// click
	})// ready

	function deleteData() {

		// 체크된 체크박스들의 orderId 값을 배열로 가져옴
		var checkedOrderIds = $('.chk:checked').map(function() {
			return $(this).data("orderid");
		}).get();

		if (checkedOrderIds.length > 0) {
			// 서버에 데이터 전송
			$.ajax({
				url : 'deleteOrder.jsp',
				method : 'POST',
				data : {
					orderIds : checkedOrderIds
				},
				traditional : true, // 배열 데이터를 서버에 보낼 때 사용
				success : function(response) {
					alert("삭제가 성공적으로 완료되었습니다.");
				},
				error : function(xhr) {
					alert("삭제 중 오류가 발생했습니다.");
					console.log(xhr.status);
				}
			});
		} else {
			alert("삭제할 항목을 선택해 주세요.");
		}

	}// deleteData
</script>

<!-- 검색어 입력 -->
<script type="text/javascript">
	$(function() {

		// 검색 버튼 클릭 시 검색 실행
		$("#search-btn").click(function() {
			chkNull();
		});

		$("#reset-btn").click(function() {
			resetForm();
		});

	});

	/* 검색어 체크 */
	function chkNull() {

		var startDate = $("#start-date").val();
		var endDate = $("#end-date").val();

		// start-date와 end-date 값이 반드시 필요
		if (!startDate || !endDate) {
			alert("검색 기간을 설정해 주세요.");
			return;
		}

		$("#searchFrm").submit();
	}

	// 초기화 버튼
	function resetForm() {

		// URL 파라미터 제거
		history.replaceState({}, '', location.pathname);
		location.reload();
	}
</script>

</head>
<body>

	<!-- 사이드바 포함 -->
	<jsp:include page="sidebar.jsp"></jsp:include>

	<jsp:useBean id="sVO" class="manager.util.SearchVO" scope="page" />
	<jsp:setProperty property="*" name="sVO" />

	<%
	AdminSalesManagementDAO asmDAO = AdminSalesManagementDAO.getInstance();

	String orderStatus = request.getParameter("order-status");
	String startDate = request.getParameter("start-date");
	String endDate = request.getParameter("end-date");

	if (orderStatus != null && !orderStatus.trim().isEmpty()) {
		sVO.setOrderStatus(orderStatus);
	}
	if (startDate != null && !startDate.trim().isEmpty()) {
		sVO.setStartDate(startDate);
	}
	if (endDate != null && !endDate.trim().isEmpty()) {
		sVO.setEndDate(endDate);
	}

	// 총 레코드 수 구하기
	int totalCount = 0;

	try {
		totalCount = asmDAO.selectTotalCount(sVO);
	} catch (SQLException se) {
		se.printStackTrace();
	}

	// 페이지 당 레코드 수 및 페이지 수 계산
	final int pageScale = 10;

	int totalPage = (int) Math.ceil((double) totalCount / pageScale);

	// 현재 페이지와 시작, 끝 번호 계산
	String paramPage = request.getParameter("currentPage");
	int currentPage = 1;
	try {
		if (paramPage != null) {
			currentPage = Integer.parseInt(paramPage);
		}
	} catch (NumberFormatException e) {
		currentPage = 1; // 기본값 설정
	}
	int startNum = currentPage * pageScale - pageScale + 1;
	int endNum = startNum + pageScale - 1; //끝 번호

	// SearchVO에 값 설정
	sVO.setCurrentPage(currentPage);
	sVO.setStartNum(startNum);
	sVO.setEndNum(endNum);
	sVO.setTotalPage(totalPage);
	sVO.setTotalCount(totalCount);
	sVO.setUrl("salesList.jsp"); // 페이지 URL 설정

	List<OrderVO> listBoard = null;
	try {
		listBoard = asmDAO.selectBoard(sVO); // 시작번호와 끝 번호를 사용해 데이터 조회

		// 상품명이 20자를 초과할 경우 잘라내기
		String tempName = "";
		for (OrderVO tempVO : listBoard) {
			tempName = tempVO.getOrderName();
			if (tempName != null && tempName.length() > 20) {
		tempVO.setOrderName(tempName.substring(0, 19) + "...");
			}
		}

	} catch (SQLException se) {
		se.printStackTrace();
	}

	// 페이지 정보를 JSP에 전달
	pageContext.setAttribute("totalCount", totalCount);
	pageContext.setAttribute("pageScale", pageScale);
	pageContext.setAttribute("totalPage", totalPage);
	pageContext.setAttribute("currentPage", currentPage);
	pageContext.setAttribute("saleslist", listBoard);

	// 검색 조건도 속성으로 설정
	request.setAttribute("orderStatus", orderStatus);
	request.setAttribute("startDate", startDate);
	request.setAttribute("endDate", endDate);
	%>


	<!-- 메인 콘텐츠 -->
	<div class="main-content">
		<!-- 판매 리스트 제목 -->
		<div class="content-box" id="sub-title">
			<h4>판매 리스트</h4>
		</div>

		<!-- 상태 아이콘 -->
		<div class="content-box" id="status-container">
			<div class="status-item" id="all">
				<div class="icon all"></div>
				<span>전체</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="on-sale">
				<div class="icon on-sale"></div>
				<span>구매확정</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="sale-completed">
				<div class="icon sale-completed"></div>
				<span>결제완료</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="sale-ended">
				<div class="icon sale-ended"></div>
				<span>취소요청</span> <span class="count">0 건</span>
			</div>
		</div>

		<!-- 검색 섹션 -->
		<div class="content-box" id="search-container">
			<form action="salesList.jsp" method="get" id="searchFrm"
				name="searchFrm">
				<!-- 주문 상태 선택 -->
				<div class="search-item">
					<div class="radio-group">
						<label>주문상태</label> <label><input type="radio"
							name="order-status" value="" checked="checked"> 전체</label> <label><input
							type="radio" name="order-status" value="구매확정"> 구매확정</label> <label><input
							type="radio" name="order-status" value="결제완료"> 결제완료</label> <label><input
							type="radio" name="order-status" value="취소요청"> 취소요청</label>
					</div>

				</div>
				<br>

				<!-- 조회 기간 선택 -->
				<div class="search-item">
					<label for="date-range">조회 기간</label> <select id="date-range">
						<option value="today">오늘</option>
						<option value="1-week">1주일</option>
						<option value="1-month">1개월</option>
						<option value="3-months">3개월</option>
						<option value="6-months">6개월</option>
						<option value="1-year">1년</option>
					</select> <input type="date" id="start-date" name="start-date"> <input
						type="date" id="end-date" name="end-date">
				</div>

				<br>
				<!-- 검색 및 초기화 버튼 -->
				<div class="search-item button-group">
					<button type="button" id="search-btn" class="btn-search">검색</button>
					<input type="button" id="reset-btn" class="btn-reset" value="초기화">
				</div>
			</form>
		</div>




		<!-- 주문 목록 -->
		<div class="content-box" id="content-box4">
			<div class="product-list-actions">
				<!-- 상품 목록 카운트 및 정렬, 선택삭제 -->
				<div class="product-count">
					<span>주문 목록(총 <%=sVO.getTotalCount()%>개)
					</span> <input type="button" id="deleteBtn" class="select-delete-btn"
						value="선택삭제">
				</div>

				<!-- 교환처리, 주문상태 -->
				<div class="product-count">
					<select id="order-type" name="order-type" class="form-select"
						aria-label="Default select example">
						<option value="">주문상태</option>
						<option value="구매확정">구매확정</option>
						<option value="결제완료">결제완료</option>
						<option value="취소요청">취소요청</option>
					</select> <select id="sale-type" name="sale-type" class="form-select"
						aria-label="Default select example">
						<option value="">배송상태</option>
						<option value="베송준비">배송준비</option>
						<option value="배송중">배송중</option>
						<option value="배송완료">배송완료</option>
					</select>
				</div>
			</div>

			<hr>



			<!-- 상품 테이블 -->
			<table class="table">
				<thead class="table-light">
					<tr>
						<td><input type="checkbox" id="select-all"></td>
						<td>주문번호</td>
						<td>주문명</td>
						<td>주문상태</td>
						<td>배송상태</td>
						<td>구매자ID</td>
						<td>주문날짜</td>
					</tr>
				</thead>

				<tbody>


					<c:if test="${ empty saleslist }">
						<tr>
							<td style="text-align: center" colspan="7">조회 가능한 항목이 없습니다.<br>
							</td>
						</tr>
					</c:if>


					<c:forEach var="item" items="${saleslist}">
						<tr>
							<td><input type="checkbox" class="chk"
								data-orderId="${item.orderId}"></td>
							<td>${item.orderId}</td>
							<td>${item.orderName}</td>
							<td>${item.orderStatus}</td>
							<td>${item.shippingStatus}</td>
							<td>${item.userId}</td>
							<td>${item.orderDate}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<!-- 페이지네이션 -->
			<div id="pagination">
				<%=new BoardUtil().pagination(sVO)%>
			</div>
			<br>

			<!-- 저장 버튼 -->
			<div class="search-item button-group">
				<input type="button" id="btnSubmit" name="btnSubmit"
					class="btn-save" value="수정 항목 저장">
			</div>


		</div>

	</div>

</body>
</html>
