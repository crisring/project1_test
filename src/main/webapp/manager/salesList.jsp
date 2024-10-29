<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="상품 리스트"%>
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
	href="http://192.168.10.219/jsp_prj/common/images/favicon.ico" />
<link rel="stylesheet" type="text/css"
	href="http://192.168.10.219/jsp_prj/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://192.168.10.219/project1/common/css/main_Sidbar.css">

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

.icon.no-sale::before {
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

#cancel-button {
	background-color: #f14668;
}

/* 테이블의 폰트 크기도 조정 가능 */
table {
	font-size: 14px;
}

.btn-save {
	padding: 10px 20px;
	font-size: 14px;
	background-color: #48c774;
	color: white;
	border: none;
	border-radius: 5px;
}
</style>
<!-- 상태 아이콘 클릭 스크립트 -->
<script type="text/javascript">
	$(function() {
		// 상태 아이콘 클릭 (토글 기능 추가)
		$(".status-item").click(function() {
			var currentColor = $(this).css("background-color");
			if (currentColor === "rgb(72, 199, 116)") { // 초록색
				$(this).css("background-color", "#f0f0f0"); // 원래 색으로 돌아감
			} else {
				$(this).css("background-color", "#48c774"); // 초록색으로 변경
			}
		});

		// 전체 선택 체크박스 클릭 이벤트
		$('#select-all').click(function() {
			// 체크박스의 체크 상태에 따라 모든 체크박스 선택/해제
			$('.chk').prop('checked', this.checked);
		});
	});
</script>
</head>
<body>

	<!-- 사이드바 포함 -->
	<jsp:include page="sidebar.jsp"></jsp:include>

	<!-- 메인 콘텐츠 -->
	<div class="main-content">
		<!-- 판매 리스트 제목 -->
		<div class="content-box" id="sub-title">
			<h4>판매 리스트</h4>
		</div>

		<!-- 상태 아이콘 -->
		<div class="content-box" id="status-container">
			<div class="status-item">
				<div class="icon all"></div>
				<span>전체</span> <span>1 건</span>
			</div>
			<div class="status-item">
				<div class="icon on-sale"></div>
				<span>구매확정</span> <span>0 건</span>
			</div>
			<div class="status-item">
				<div class="icon no-sale"></div>
				<span>구매 미정</span> <span>0 건</span>
			</div>
			<div class="status-item">
				<div class="icon sale-paused"></div>
				<span>취소요청</span> <span>1 건</span>
			</div>
		</div>

		<!-- 검색 섹션 -->
		<div class="content-box" id="search-container">
			<!-- 주문 상태 선택 -->
			<div class="search-item">

				<div class="checkbox-group">
					<label>주문상태</label><label><input type="checkbox"
						name="sales-status" value="전체"> 전체</label> <label><input
						type="checkbox" name="sales-status" value="구매확정"> 구매확정</label> <label><input
						type="checkbox" name="sales-status" value="구매 미정"> 구매 미정</label> <label><input
						type="checkbox" name="sales-status" value="취소요청"> 취소요청</label>
				</div>
			</div>

			<!-- 조회 기간 선택 -->
			<div class="search-item">
				<label for="date-range">조회 기간</label> <select id="date-range">
					<option value="today">오늘</option>
					<option value="1-week">1주일</option>
					<option value="1-month">1개월</option>
					<option value="3-months">3개월</option>
					<option value="6-months">6개월</option>
					<option value="1-year">1년</option>
				</select> <input type="date" id="start-date"> <input type="date"
					id="end-date">
			</div>

			<!-- 검색 및 초기화 버튼 -->
			<div class="search-item button-group">
				<button id="search-btn" class="btn-search">검색</button>
				<input type="reset" id="reset-btn" class="btn-reset" value="초기화">
			</div>
		</div>

		<!-- 상품 목록 -->
		<div class="content-box" id="content-box4">
			<div class="product-list-actions">
				<!-- 상품 목록 카운트 및 정렬, 선택삭제 -->
				<div class="product-count">
					<span>상품 목록(총 0개)</span>
					<button type="submit" class="select-delete-btn">선택삭제</button>
				</div>

				<!-- 교환처리, 취소처리 버튼 -->
				<div class="action-buttons">
					<button id="cancel-button">취소 처리</button>
				</div>

				<div class="product-count">
					<select id="sale-type" class="form-select"
						aria-label="Default select example">
						<option value="배송상태">배송상태</option>
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
						<td>상품명</td>
						<td>주문상태</td>
						<td>배송상태</td>
						<td>구매자ID</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="checkbox" class="chk"></td>
						<td>10001</td>
						<td>뉴발란스 993</td>
						<td>주문상태</td>
						<td>배송상태</td>
						<td>구매자ID</td>
					</tr>
				</tbody>
			</table>

			<!-- 저장 버튼 -->
			<div class="search-item button-group">
				<button id="submit" class="btn-save">수정 항목 저장</button>
			</div>
		</div>
	</div>

</body>
</html>
