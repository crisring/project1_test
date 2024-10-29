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

<!-- 내가 쓴거 -->
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
<script type="text/javascript">
	$(function() {

		// 수정 버튼 클릭시 페이지 이동
		$(".edit").click(function() {
			window.location.href = "productRegistration.jsp";

		})

		// 상세설명 버튼 클릭시 popup창 띄우기
		$("#explanation").click(function() {
			openDescription();
		})

	})// ready

	//부모창에서 자식창으로 값 전달
	function openDescription() {
		var left = window.screenX + 350;
		var top = window.screenY + 200;

		/* // 1. 현재창에 아이디를 가져와서 */
		/* var explanation = document.memberFrm.id.value; */

		// 2. query string 만들어서 팝업을 띄운다.
		window.open("description.jsp?explanation="
				+ encodeURIComponent(explanation), "descriptionFrm",
				"width=460,height=380,left=" + left + ",top=" + top);
	}
</script>

</head>
<body>

	<jsp:include page="sidebar.jsp"></jsp:include>

	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<div class="content-box" id="sub-title">
			<h4>상품 리스트</h4>
		</div>
		<div class="content-box" id="status-container">
			<div class="status-item">
				<div class="icon all"></div>
				<span>전체</span> <span>1 건</span>
			</div>
			<div class="status-item">
				<div class="icon on-sale"></div>
				<span>판매중</span> <span>0 건</span>
			</div>
			<div class="status-item">
				<div class="icon sale-paused"></div>
				<span>판매중지</span> <span>1 건</span>
			</div>
			<div class="status-item">
				<div class="icon sale-ended"></div>
				<span>판매종료</span> <span>0 건</span>
			</div>
		</div>

		<div class="content-box" id="search-container">
			<!-- Search Keyword -->
			<div class="search-item">
				<label for="keyword">검색어</label> <label for="product-name">상품명</label>
				<input type="text" id="product-name" placeholder="상품명 입력"> <label
					for="brand-name">브랜드명</label> <input type="text" id="brand-name"
					placeholder="브랜드명 입력">
			</div>

			<!-- Sales Status -->
			<div class="search-item">
				<label>판매상태</label>
				<div class="checkbox-group">
					<label><input type="checkbox" name="sales-status"
						value="전체"> 전체</label> <label><input type="checkbox"
						name="sales-status" value="판매중"> 판매중</label> <label><input
						type="checkbox" name="sales-status" value="판매중지"> 판매중지</label> <label><input
						type="checkbox" name="sales-status" value="판매종료"> 판매종료</label>
				</div>
			</div>



			<!-- Date Range Selection -->
			<div class="search-item">
				<!-- Date Type Selection -->
				<div class="search-item">
					<label for="date-type">조회 기간</label> <select id="date-type">
						<option value="상품등록일">상품등록일</option>
						<option value="판매시작일">판매시작일</option>
						<option value="판매종료일">판매종료일</option>
					</select>
				</div>

				<select id="date-range">
					<option value="today">오늘</option>
					<option value="1-week">1주일</option>
					<option value="1-month">1개월</option>
					<option value="3-months">3개월</option>
					<option value="6-months">6개월</option>
					<option value="1-year">1년</option>
				</select> <input type="date" id="start-date"> <input type="date"
					id="end-date">
			</div>

			<!-- Search and Reset Buttons -->
			<div class="search-item button-group">
				<button id="search-btn" class="btn-search">검색</button>
				<input type="reset" id="reset-btn" class="btn-reset" value="초기화">
			</div>
		</div>

		<div class="content-box" id="content-box4">
			<div class="product-list-actions">
				<!-- 상품 목록 카운트 및 정렬, 선택삭제 -->
				<div class="product-count">
					<span>상품 목록(총 0개)</span> <select id="REG_DATE">
						<option value="판매시작일순">상품명순</option>
						<option value="판매가 낮은순">판매가 낮은순</option>
						<option value="판매가 높은순">판매가 높은순</option>

					</select> <select id="count_product">
						<option value="10">10개씩</option>
						<option value="30">30개씩</option>
						<option value="50">50개씩</option>
					</select>
					<button type="submit" class="select-delete-btn">선택삭제</button>
				</div>

				<!-- 판매변경 -->
				<div class="product-count">
					<select id="sale-type" class="form-select"
						aria-label="Default select example">
						<option value="판매변경">판매변경</option>
						<option value="판매중">판매중</option>
						<option value="판매중지">판매중지</option>
					</select>
				</div>

			</div>

			<hr>

			<!-- 상품 테이블 -->
			<table class="table">
				<thead class="table-light" style="text-align: center;">
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
				<tbody>
					<tr>
						<td><input type="checkbox" class="chk"></td>
						<td><input type="button" value="수정" class="edit"></td>
						<td>10001</td>
						<td>뉴발란스 993</td>
						<td>MLGREY993</td>
						<td>뉴발란스</td>
						<td><input type="button" id="explanation" value="상세설명"></td>
						<td>판매상태</td>
						<td>재고수량</td>
						<td>판매가</td>
						<td>할인가</td>
						<td>판매시작일</td>
						<td>판매종료일</td>
					</tr>
				</tbody>
			</table>

			<!-- 저장 버튼 -->
			<div class="search-item button-group">
				<button id="submit" class="btn-save">수정 항목 저장</button>
			</div>
		</div>

		<!-- end main -->
	</div>


</body>
</html>