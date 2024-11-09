<%@page import="java.sql.SQLException"%>
<%@page import="manager.util.SearchVO"%>
<%@page import="manager.util.BoardUtil"%>
<%@page import="java.util.List"%>
<%@page import="manager.productlist.ProductVO"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="상품 리스트"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



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

<!-- 내가 쓴거 -->
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

.icon.sale-paused::before {
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
	max-width: 400px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	box-sizing: border-box;
}

.checkbox-group {
	display: flex;
	gap: 15px;
}

.checkbox-group label {
	display: flex;
	align-items: center;
}
</style>

<!-- 버튼 그룹 스타일 -->
<style type="text/css">
.button-group {
	display: flex;
	justify-content: center;
	gap: 20px;
}

.btn-search, .btn-reset {
	padding: 12px 30px;
	font-size: 16px;
	border-radius: 5px;
	border: none;
}

.btn-search {
	background-color: #48c774;
	color: white;
}

.btn-reset {
	background-color: #ddd;
	color: black;
}

.btn-save {
	padding: 10px 20px;
	font-size: 16px;
	background-color: #48c774;
	color: white;
	border: none;
	border-radius: 5px;
}
</style>

<!-- 상품 리스트 액션 버튼 스타일 -->
<style type="text/css">
.product-list-actions {
	display: flex;
	justify-content: space-between; /* 좌우 정렬 */
	align-items: center;
	padding: 10px 0;
}

.product-count {
	font-size: 14px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.select-delete-btn {
	padding: 8px 20px;
	font-size: 14px;
	background-color: #ddd;
	border: none;
	border-radius: 5px;
	display: inline-block;
}

.action-buttons {
	display: flex;
	gap: 10px;
}

.action-buttons button {
	padding: 10px 20px;
	font-size: 14px;
	border-radius: 5px;
	background-color: #48c774;
	color: white;
	border: none;
}

#cancel-button {
	background-color: #f14668;
}

/* 테이블 스타일 */
table {
	font-size: 13px;
	text-align: center;
}

/* 페이지네이션 */
#pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	text-align: center;
}
</style>

<!-- 리스트 -->
<jsp:useBean id="sVO" class="manager.util.SearchVO" scope="page" />
<jsp:setProperty property="*" name="sVO" />
<%
AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();

// 검색 조건 설정
String productName = request.getParameter("product-name");
String brand = request.getParameter("brand");
String salesStatus = request.getParameter("sales-status");
String dateType = request.getParameter("date-type");
String startDate = request.getParameter("start-date");
String endDate = request.getParameter("end-date");
String sortBy = request.getParameter("sortBy");

// SearchVO에 검색 조건 설정
if (productName != null && !productName.trim().isEmpty()) {
	sVO.setProductName(productName);
}
if (brand != null && !brand.trim().isEmpty()) {
	sVO.setBrand(brand);
}
if (salesStatus != null && !salesStatus.trim().isEmpty()) {
	sVO.setSaleStatus(salesStatus);
}
if (dateType != null && !dateType.trim().isEmpty()) {
	sVO.setDateType(dateType);
}
if (startDate != null && !startDate.trim().isEmpty()) {
	sVO.setStartDate(startDate);
}
if (endDate != null && !endDate.trim().isEmpty()) {
	sVO.setEndDate(endDate);
}
if (sortBy != null && !sortBy.trim().isEmpty()) {
	sVO.setSortBy(sortBy);
}

// 총 레코드 수 구하기
int totalCount = 0;
try {
	totalCount = apmDAO.selectTotalCount(sVO);
} catch (SQLException se) {
	se.printStackTrace();
}

// 페이지당 보여줄 게시물 수
int pageScale = 10;

// 총 페이지 수 계산
int totalPage = (int) Math.ceil((double) totalCount / pageScale);

// 현재 페이지 설정
String paramPage = request.getParameter("currentPage");
int currentPage = 1;
try {
	if (paramPage != null) {
		currentPage = Integer.parseInt(paramPage);
	}
} catch (NumberFormatException e) {
	currentPage = 1; // 기본값 설정
}

// 시작번호와 끝번호 계산
int startNum = currentPage * pageScale - pageScale + 1;
int endNum = startNum + pageScale - 1;

// SearchVO에 페이징 정보 설정
sVO.setCurrentPage(currentPage);
sVO.setStartNum(startNum);
sVO.setEndNum(endNum);
sVO.setTotalPage(totalPage);
sVO.setTotalCount(totalCount);
sVO.setUrl("productList.jsp");

// 상품 목록 조회
List<ProductVO> listBoard = null;
try {
	listBoard = apmDAO.selectBoard(sVO);

	// 상품명이 20자를 초과할 경우 잘라내기
	String tempName = "";
	for (ProductVO tempVO : listBoard) {
		tempName = tempVO.getProductName();
		if (tempName != null && tempName.length() > 20) {
	tempVO.setProductName(tempName.substring(0, 19) + "...");
		}
	}
} catch (SQLException se) {
	se.printStackTrace();
}

// JSP에서 사용할 속성 설정
pageContext.setAttribute("totalCount", totalCount);
pageContext.setAttribute("pageScale", pageScale);
pageContext.setAttribute("totalPage", totalPage);
pageContext.setAttribute("currentPage", currentPage);
request.setAttribute("productList", listBoard);

// 검색 조건도 속성으로 설정
request.setAttribute("productName", productName);
request.setAttribute("brand", brand);
request.setAttribute("salesStatus", salesStatus);
request.setAttribute("dateType", dateType);
request.setAttribute("startDate", startDate);
request.setAttribute("endDate", endDate);
request.setAttribute("sortBy", sortBy);
%>


<!-- 날짜 설정 -->
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


<!-- 체크박스 전체 선택 스크립트 -->
<script type="text/javascript">
	$(function() {
		// 전체 선택 체크박스 클릭 이벤트
		$('#select-all').click(function() {
			// 체크박스의 체크 상태에 따라 모든 체크박스 선택/해제
			$('.chk').prop('checked', this.checked);
		});
	});
</script>

<!-- 상세설명 + 수정페이지 -->
<script type="text/javascript">
	$(function() {

		// 수정 버튼 클릭시 페이지 이동
		$(".edit").click(function() {

			// 클릭된 버튼의 data-product-id 속성을 가져옴
			var productId = $(this).data("product-id");
			window.location.href = "productEdit.jsp?productId=" + productId;
		});

		// 상세설명 버튼 클릭시 popup창 띄우기
		$(".explanation").on(
				"click",
				function() {
					var productId = $(this).data("product-id"); // 각 버튼의 data-product-id 속성값 가져오기
					var left = window.screenX + 350;
					var top = window.screenY + 200;

					// productId를 쿼리 문자열에 추가하여 팝업 창 열기
					window
							.open("description.jsp?productId="
									+ encodeURIComponent(productId),
									"descriptionFrm",
									"width=460,height=380,left=" + left
											+ ",top=" + top);
				});

	})// ready
</script>

<!-- 검색어 입력 -->
<script type="text/javascript">
	$(function() {

		// Enter 키를 눌렀을 때 검색 실행
		$("#product-name, #brand").keyup(function(evt) {
			if (evt.which == 13) {
				chkNull();
			}
		});

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
		var keyword1 = $("#product-name").val();
		var keyword2 = $("#brand").val();
		var startDate = $("#start-date").val();
		var endDate = $("#end-date").val();

		// 입력이 없거나, 두 글자 이상인 경우만 통과
		if ((keyword1 && keyword1.length < 2)
				|| (keyword2 && keyword2.length < 2)) {
			alert("검색 키워드는 두 글자 이상 입력하셔야 합니다.");
			return;
		}

		// start-date와 end-date 값이 반드시 필요
		if (!startDate || !endDate) {
			alert("검색 기간을 설정해 주세요.");
			return;
		}

		$("#searchFrm").submit();
	}

	// 초기화 버튼
	function resetForm() {

		// 입력 필드 초기화  
		$('input[name="brand"]').val('');
		$('input[name="product-name"]').val('');

		// URL 파라미터 제거
		history.replaceState({}, '', location.pathname);
		location.reload();
	}
</script>

<!-- 정렬 검색 -->
<script type="text/javascript">
	$(function() {

		$("#sortBy").change(function() {
			arrange();
		});// change

		$("#count_product").change(function() {
			changePageScale();
		});// change
	});// ready

	function arrange() {

		// 정렬할 값 가져오기
		var sortBy = $('#sortBy').val();

		// 각 hidden input 요소의 값을 가져오기
		const pramProduct = $('#pramProduct').val();
		const paramBrand = $('#paramBrand').val();
		const paramStatus = $('#paramStatus').val();
		const paramDateType = $('#paramDateType').val();
		const paramStartDate = $('#paramStartDate').val();
		const paramEndDate = $('#paramEndDate').val();

		// 가져온 값들을 출력
		console.log("Product Name:", pramProduct);
		console.log("Brand:", paramBrand);
		console.log("Sales Status:", paramStatus);
		console.log("Date Type:", paramDateType);
		console.log("Start Date:", paramStartDate);
		console.log("End Date:", paramEndDate);
		console.log("Sort By:", sortBy);

		$('#sortFrm').submit();
	}

	function changePageScale() {

	}
</script>

<!-- 게시물 수 검색  -->
<script type="text/javascript">
	$(function() {

		// 카운트 업데이트
		$('#all .count').text(totalSalesStatusCnt() + ' 건');
		$('#on-sale .count').text(getSalesCount("판매중") + ' 건');
		$('#sale-paused .count').text(getSalesCount("판매중지") + ' 건');
		$('#sale-ended .count').text(getSalesCount("판매종료") + ' 건');

	})// ready

	function totalSalesStatusCnt() {
		var cnt = 0;

		// AJAX 요청을 통해 판매 수량을 가져옵니다.
		$.ajax({
			url : "salesTotalCnt.jsp",
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
	}

	function getSalesCount(salesStatus) {
		var cnt = 0;

		// AJAX 요청을 통해 판매 수량을 가져옵니다.
		$.ajax({
			url : "salesCnt.jsp",
			type : "get",
			data : {
				salesStatus : salesStatus
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
	}// getSalesCount
</script>


<!-- 판매 상태 변경  -->
<script type="text/javascript">
	$(function() {

		$("#btnSubmit").click(function() {

			updateSaleStatus();

		})// click
	})// ready

	/* 판매상태 변경 */
	function updateSaleStatus() {

		// select에서 선택된 옵션의 값을 가져옴
		var selectedSaleType = $("#sale-type").val();

		// 체크된 체크박스들의 productId 값을 배열로 가져옴
		var checkedProductIds = $('.chk:checked').map(function() {
			return $(this).data("product-id"); // data-product-id 속성에서 productId 가져오기
		}).get();

		if (checkedProductIds.length > 0) {
			// 서버에 데이터 전송
			$.ajax({
				url : 'updateSaleStatus.jsp',
				method : 'POST',
				data : {
					saleType : selectedSaleType,
					productIds : checkedProductIds
				},
				traditional : true, // 배열 데이터를 서버에 보낼 때 사용
				success : function(response) {
					alert("변경이 성공적으로 완료되었습니다.");
				},
				error : function(xhr) {
					alert("변경 중 오류가 발생했습니다.");
					console.log(xhr.status);
				}
			});
		} else {
			alert("변경할 항목을 선택해 주세요.");
		}
	}// updateSaleStatus
</script>



<!-- 선택 삭제 -->
<script type="text/javascript">
	$(function() {

		$("#deleteBtn").click(function() {

			deleteData();

		})// click
	})// ready

	function deleteData() {

		// 체크된 체크박스들의 productId 값을 배열로 가져옴
		var checkedProductIds = $('.chk:checked').map(function() {
			return $(this).data("product-id"); // data-product-id 속성에서 productId 가져오기
		}).get();

		if (checkedProductIds.length > 0) {
			// 서버에 데이터 전송
			$.ajax({
				url : 'deleteProduct.jsp',
				method : 'POST',
				data : {
					productIds : checkedProductIds
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

</head>
<body>

	<!-- 사이드바 포함 -->
	<jsp:include page="sidebar.jsp"></jsp:include>




	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">

		<div class="content-box" id="sub-title">
			<h4>상품 리스트</h4>
		</div>
		<div class="content-box" id="status-container">
			<div class="status-item" id="all">
				<div class="icon all"></div>
				<span>전체</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="on-sale">
				<div class="icon on-sale"></div>
				<span>판매중</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="sale-paused">
				<div class="icon sale-paused"></div>
				<span>판매중지</span> <span class="count">0 건</span>
			</div>
			<div class="status-item" id="sale-ended">
				<div class="icon sale-ended"></div>
				<span>판매종료</span> <span class="count">0 건</span>
			</div>
		</div>

		<div class="content-box" id="search-container">

			<!-- Search Keyword -->
			<form action="productList.jsp" method="get" name="searchFrm"
				id="searchFrm">
				<div class="search-item">

					<label for="product-name">상품명</label><input type="text"
						id="product-name" name="product-name" class="keyword"
						placeholder="상품명 입력"> <label for="brand">브랜드명</label><input
						type="text" id="brand" name="brand" placeholder="브랜드명 입력"
						class="keyword">

				</div>
				<br>

				<!-- Sales Status -->
				<div class="search-item">
					<label>판매상태</label>
					<div class="radio-group">
						<label><input type="radio" name="sales-status" value=""
							checked> 전체</label> <label><input type="radio"
							name="sales-status" value="판매중"> 판매중</label> <label><input
							type="radio" name="sales-status" value="판매중지"> 판매중지</label> <label><input
							type="radio" name="sales-status" value="판매종료"> 판매종료</label>
					</div>
				</div>


				<br>

				<!-- Date Range Selection -->
				<div class="search-item">
					<!-- Date Type Selection -->
					<div class="search-item">
						<label for="date-type">조회 기간</label> <select id="date-type"
							name="date-type">
							<option value="CREATED_AT">판매시작일</option>
							<option value="FINISH_AT">판매종료일</option>
						</select>
					</div>

					<select id="date-range">
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
				<!-- Search and Reset Buttons -->
				<div class="search-item button-group">
					<button type="button" id="search-btn" class="btn-search">검색</button>
					<input type="button" id="reset-btn" class="btn-reset" value="초기화">
				</div>
			</form>
		</div>

		<div class="content-box" id="content-box4">
			<form action="productList.jsp" method="get" name="sortFrm"
				id="sortFrm">

				<div class="product-list-actions">

					<!-- hidden으로 값 설정 -->
					<input type="hidden" id="pramProduct" name="pramProduct"
						value="${productName}" /> <input type="hidden" id="paramBrand"
						name="paramBrand" value="${brand}" /> <input type="hidden"
						id="paramStatus" name="paramStatus" value="${salesStatus}" /> <input
						type="hidden" id="paramDateType" name="paramDateType"
						value="${dateType}" /> <input type="hidden" id="paramStartDate"
						name="paramStartDate" value="${startDate}" /> <input
						type="hidden" id="paramEndDate" name="paramEndDate"
						value="${endDate}" />

					<!-- 상품 목록 카운트 및 정렬, 선택삭제 -->
					<div class="product-count">
						<span style="margin-right: 10px;">상품 목록(총 <%=sVO.getTotalCount()%>개)
						</span> <select id="sortBy" name="sortBy">
							<option>정렬기준</option>
							<option value="NAME">상품명순</option>
							<option value="PRICE">판매가 낮은순</option>
							<option value="PRICE DESC">판매가 높은순</option>

						</select> <select id="count_product" name="count_product">
							<option value="10">10개씩</option>
							<option value="20">20개씩</option>
							<option value="30">30개씩</option>
						</select>
					</div>

					<!-- 판매변경 -->
					<div class="product-count">
						<input type="button" id="deleteBtn" class="select-delete-btn"
							value="선택삭제"> <select id="sale-type" class="form-select"
							aria-label="Default select example">
							<option value="판매변경">판매변경</option>
							<option value="판매중">판매중</option>
							<option value="판매중지">판매중지</option>
							<option value="판매종료">판매종료</option>
						</select>
					</div>

				</div>

				<hr>



				<!-- 상품 테이블 -->
				<table class="table">
					<thead class="table-light">
						<tr>
							<td><input type="checkbox" id="select-all"></td>
							<td>수정</td>
							<td>상품번호</td>
							<td>상품명</td>
							<td>모델명</td>
							<td>브랜드명</td>
							<td>상세설명</td>
							<td>판매상태</td>
							<td>재고수량</td>
							<td>판매가</td>
							<td>할인가</td>
							<td>판매시작일</td>
							<td>판매종료일</td>
						</tr>
					</thead>

					<tbody id="productList">
						<c:if test="${ empty productList }">
							<tr>
								<td style="text-align: center" colspan="13">조회 가능한 항목이
									없습니다.<br>
								</td>
							</tr>
						</c:if>



						<c:forEach var="item" items="${productList}">
							<tr>
								<td><input type="checkbox" class="chk"
									data-product-id="${item.productId}"></td>
								<td><input type="button" value="수정" class="edit"
									data-product-id="${item.productId}"></td>
								<td>${item.productId}</td>
								<td>${item.productName}</td>
								<td>${item.modelName}</td>
								<td>${item.brand}</td>
								<td><input type="button" class="explanation" value="상세설명"
									data-product-id="${item.productId}"></td>
								<td>${item.saleStatus}</td>
								<td>${item.stockQuantity}</td>
								<td>${item.price}</td>
								<td>${item.discount_price}</td>
								<td>${item.createAt}</td>
								<td>${item.finishAt}</td>
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
			</form>
		</div>

		<!-- end main -->

	</div>


</body>
</html>