<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="카탈로그 팝업"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="styles.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<style type="text/css">
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

.popup {
	display: flex;
	flex-direction: column;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 400px;
	border: 1px solid #ccc;
	border-radius: 8px;
	background-color: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	z-index: 1000;
}

.popup-header {
	display: flex;
	justify-content: space-between;
	padding: 10px;
	background-color: #4CAF50;
	color: white;
	border-radius: 8px 8px 0 0;
}

.popup-content {
	padding: 10px;
}

.search-section {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
}

#search-input {
	width: 70%;
	padding: 5px;
}

.product-list {
	max-height: 200px;
	overflow-y: auto;
}

.product-item {
	display: flex;
	margin-bottom: 10px;
}

.product-item img {
	width: 50px;
	height: auto;
	margin-right: 10px;
}

.product-info {
	flex: 1;
}

.pagination {
	display: flex;
	justify-content: center;
	margin-top: 10px;
}

.page-button {
	margin: 0 5px;
}
</style>


<script type="text/javascript">
	function selectProduct(productName, price) {
		// 부모 창의 특정 필드에 값을 전달
		if (window.opener && !window.opener.closed) {
			$(window.opener.document).find('#selectedProductName').val(
					productName);
			$(window.opener.document).find('#selectedProductPrice').val(price);
		}
		// 팝업 창 닫기
		window.close();
	}
</script>

<title>카탈로그 찾기 팝업</title>

</head>
<body>

	<div class="popup" id="catalog-popup">
		<div class="popup-header">
			<h2>카탈로그 찾기</h2>
			<button id="close-popup">&times;</button>
		</div>
		<div class="popup-content">
			<div class="search-section">
				<input type="text" id="search-input" placeholder="카테고리, 브랜드, 제품명 검색">
				<button id="search-button">검색</button>
			</div>
			<div class="product-list">
				<div class="product-item">
					<img src="shoe1.jpg" alt="뉴발란스 530 MR530SG">
					<div class="product-info">
						<strong>뉴발란스 530 MR530SG</strong> <span>98,437원</span> <span>브랜드:
							뉴발란스</span>
						<button class="select-button">선택</button>
					</div>
				</div>
				<div class="product-item">
					<img src="shoe2.jpg" alt="뉴발란스 ML2002RC">
					<div class="product-info">
						<strong>뉴발란스 ML2002RC</strong> <span>139,797원</span> <span>브랜드:
							뉴발란스</span>
						<button class="select-button">선택</button>
					</div>
				</div>
				<div class="product-item">
					<img src="shoe3.jpg" alt="뉴발란스 530 MR530KA">
					<div class="product-info">
						<strong>뉴발란스 530 MR530KA</strong> <span>114,100원</span> <span>브랜드:
							뉴발란스</span>
						<button class="select-button">선택</button>
					</div>
				</div>
			</div>
			<div class="pagination">
				<button class="page-button">1</button>
				<button class="page-button">2</button>
				<button class="page-button">3</button>
				<button class="page-button">4</button>
				<button class="page-button">5</button>
			</div>
		</div>
	</div>
</body>
</html>
