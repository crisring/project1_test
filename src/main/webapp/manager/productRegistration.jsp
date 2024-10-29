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
	href="http://192.168.10.219/project1/common/images/favicon.ico" />
<link rel="stylesheet" type="text/css"
	href="http://192.168.10.219/project1/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://192.168.10.219/project1/common/css/main_Sidbar.css">
<link rel="stylesheet"
	href="http://192.168.10.219/project1/common/css/footer.css">


<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
/* General Styles */
.essential {
	color: red;
}

textarea {
	width: 100%;
	margin-top: 10px;
	resize: none;
	padding: 10px;
}

button {
	cursor: pointer;
}

/* Main Container Styles */
#productName-container, #saleprice-container, #size-container,
	#image-container {
	display: flex;
	flex-direction: column;
	padding: 20px;
}

/* Product Name Input */
#productName {
	width: 1100px;
}

/* Sale Price Section */
#saleprice-container .price-input, .discount-input {
	display: flex;
	gap: 10px;
	align-items: center;
	margin-top: 10px;
}

#saleprice-container .discount-section {
	margin-top: 20px;
	display: flex;
	flex-direction: column;
}

#saleprice-container .radio-buttons {
	display: flex;
	gap: 20px;
	margin-top: 10px;
}

#saleprice-container .discount-details {
	margin-top: 10px;
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

#totalprice {
	margin-top: 10px;
}

/* Size Section */
.size-section {
	display: flex;
	justify-content: space-between;
	margin-top: 10px;
}

.size-checkboxes {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	/
}

.size-checkboxes label {
	flex: 1 1 23%;
	box-sizing: border-box;
}

.size-checkboxes input {
	margin-right: 5px;
}

.size-box {
	flex: 0 0 200px;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.size-box ul {
	list-style-type: none;
	padding: 0;
}

.size-box ul li {
	background-color: #f9f9f9;
	padding: 5px;
	margin: 5px 0;
	border-radius: 3px;
}

/* Image Container */
#image-container div {
	margin-top: 10px;
}

#image-container input[type="file"] {
	margin-left: 10px;
}

.preview-container {
	margin-top: 20px;
	border: 1px solid 000;
}

.preview-container img {
	max-width: 100px;
	max-height: 100px;
	margin-right: 10px;
	display: inline-block;
}

/* Button Styles */
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

button.button-add-size {
	padding: 10px 15px;
	border-radius: 4px;
	border: none;
	margin-top: 20px;
	font-size: 14px;
	min-width: 80px;
}

#reset-btn, #search-btn {
	padding: 10px 20px;
	border-radius: 4px;
	border: none;
	margin-top: 20px;
}

button.button-add-size {
	margin-top: 10px;
	background-color: #48c774;
	color: white;
}

#reset-btn {
	color: white;
	margin-right: 10px;
}

#search-btn {
	background-color: #48c774;
	color: white;
}
</style>



<!-- 상품 주요정보 -->
<style type="text/css">
.form-group {
	margin-top: 15px;
}
</style>
<!-- 버튼 클릭 설정 -->
<script type="text/javascript">
	$(function() {
		/* 상태 아이콘 변경 */
		$(".status-item").click(function() {
			$(this).css("background-color", "#48c774");
		});

		$('.btn').click(function() {
			// 다른 버튼의 active 클래스 제거
			$('.btn').removeClass('active');

			// 클릭한 버튼에 active 클래스 추가
			$(this).addClass('active');
		});

		/* 상품 주요정보-찾기 클릭시 카탈로그 popup */
		$("#btn-find").click(function() {
			openCatalog();
		});

	})// document ready

	/* 카탈로그 찾기 */
	// 부모창에서 자식창으로 값 전달
	function openCatalog() {
		var left = window.screenX + 350;
		var top = window.screenY + 200;

		// query string 없이 팝업을 띄운다.
		window.open("catalog.jsp", "descriptionFrm",
				"width=460,height=380,left=" + left + ",top=" + top);
	}
</script>

<!-- 사이즈 -->
<script type="text/javascript">
	function addSelectedSizes() {
		// Clear the existing items
		$('#selected-sizes').empty();

		$('.size-checkboxes input[type="checkbox"]:checked').each(
				function() {
					const size = $(this).val();
					const li = $('<li>' + size
							+ ' <button class="delete-size">삭제</button></li>');
					$('#selected-sizes').append(li);
				});
	}// addSelectedSizes

	$(function() {
		$('.button-add-size').on('click', function() {
			addSelectedSizes();
		});

		$('#selected-sizes').on('click', '.delete-size', function() {
			$(this).parent().remove();
		});
	});// ready
</script>

<!-- 글자 수 계산  -->
<script type="text/javascript">
	$(function() {

		$('#productName').on('input', function() {
			var currentLength = $(this).val().length; // 현재 입력된 글자 수
			$('#charCount').val(currentLength + "/100"); // 글자 수 업데이트
		});

	})
</script>

<!-- 상품 가격 계산 -->
<script type="text/javascript">
	$(function() {
		// 할인 설정 라디오 버튼 변경 시 할인 입력란 토글
		$('input[name="sale"]').change(function() {
			if ($('#sale-on').is(':checked')) {
				$('#discount-details').show();
			} else {
				$('#discount-details').hide();
				$('#totalprice').text('할인가 0원(0원 할인)');
			}
		});

		// 판매가 및 할인 금액 입력 시 계산
		$('#selling-price, #discount-amount')
				.on(
						'input',
						function() {
							const sellingPrice = parseFloat($('#selling-price')
									.val());
							const discountAmount = parseFloat($(
									'#discount-amount').val()) || 0;

							if (!isNaN(sellingPrice)) {
								const discountedPrice = Math.max(sellingPrice
										- discountAmount, 0);
								const discountText = sellingPrice > discountAmount ? `${discountAmount}원 할인`
										: '할인 금액이 판매가보다 큽니다.';

								$('#totalprice')
										.text(
												`할인가 ${discountedPrice}원(${discountText})`);
							} else {
								$('#totalprice').text('할인가 0원(0원 할인)');
							}
						});
	});// ready
</script>


<!-- img container -->
<script type="text/javascript">
	$(function() {
		//대표 이미지 미리보기
		$('#mainImage').change(function(event) {
			const file = event.target.files[0]; // 파일 가져오기
			const reader = new FileReader(); // FileReader 객체 생성

			reader.onload = function(e) {
				$('#mainImagePreview').attr('src', e.target.result).show(); // 미리보기 이미지 설정 및 보이게 하기
			}

			if (file) {
				reader.readAsDataURL(file); // 파일을 Data URL로 읽기
			}
		});

		// 추가 이미지 미리보기
		$('#additionalImages').change(
				function(event) {
					const files = event.target.files; // 선택된 파일들 가져오기
					const previewContainer = $('#additionalImagePreviews');
					previewContainer.empty(); // 이전 미리보기 이미지 지우기

					for (let i = 0; i < files.length && i < 5; i++) { // 최대 5개까지 처리
						const file = files[i];
						const reader = new FileReader(); // FileReader 객체 생성

						reader.onload = function(e) {
							const imgElement = $('<img>').attr('src',
									e.target.result).show(); // jQuery를 사용해 이미지 생성
							previewContainer.append(imgElement); // 미리보기 컨테이너에 추가
						}

						if (file) {
							reader.readAsDataURL(file); // 파일을 Data URL로 읽기
						}
					}
				});
	});
</script>

</head>
<body>

	<jsp:include page="sidebar.jsp"></jsp:include>
	<div id="wrap">
		<!--  메인 콘텐츠	-->
		<div class="main-content">
			<div class="content-box" id="sub-title">
				<h4>상품 등록</h4>
				<span class="essential">*필수항목</span>
			</div>

			<div class="content-box" id="productName-container">
				<strong>상품명 <span class="essential">*</span></strong>
				<div>
					<input type="text" id="productName" class="productName"
						maxlength="99"> <input type="text" id="charCount"
						value="0/100" disabled="disabled" style="min-width: 30px">
				</div>
			</div>



			<div class="content-box" id="saleprice-container">
				<div>
					<strong>판매가 <span class="essential">*</span></strong>
				</div>
				<div class="price-input">
					<input type="number" id="selling-price" placeholder="숫자만 입력">
					<input type="text" value="원" disabled="disabled"
						style="width: 30px">
				</div>

				<div class="discount-section">
					<strong>즉시할인</strong>
					<div class="radio-buttons">
						<label for="sale-on"> <input type="radio" id="sale-on"
							class="onoff" value="설정함" name="sale"> 설정함
						</label> <label for="sale-off"> <input type="radio" id="sale-off"
							class="onoff" value="설정안함" name="sale"> 설정안함
						</label>
					</div>

					<div class="discount-details" id="discount-details"
						style="display: none;">
						<p>기본할인 판매가에서 즉시 할인이 가능한 할인 유형으로 할인된 가격으로 상품을 판매할 수 있습니다.</p>
						<div class="discount-input">
							<input type="number" id="discount-amount" placeholder="판매가에서">
							<input type="text" value="원" disabled="disabled"> <span>할인</span>
						</div>
						<div id="totalprice">할인가 0원(0원 할인)</div>
					</div>
				</div>
			</div>



			<div class="content-box" id="size-container">
				<div>
					<strong>사이즈 <span class="essential">*</span></strong>
				</div>
				<div class="discount-section">
					<strong>사이즈 분류</strong>
					<div class="size-section">

						<div class="size-checkboxes">
							<%
							for (int i = 225; i <= 300; i += 5) {
								out.print("<label><input type=\"checkbox\" value=\"" + i + "\"> " + i + "</label>");
							}
							%>

							<button class="button-add-size">추가</button>
						</div>

						<div class="size-box">
							<strong>선택한 사이즈</strong>
							<ul id="selected-sizes"></ul>
						</div>
					</div>
				</div>

			</div>

			<!-- 상품 이미지 -->
			<div class="content-box" id="image-container">
				<strong>상품 이미지</strong>
				<div>
					<strong>대표이미지 <span class="essential">*</span></strong> <input
						type="file" id="mainImage" accept="image/*"> <strong>추가이미지
						(최대 5개)</strong> <input type="file" id="additionalImages" accept="image/*"
						multiple>
				</div>

				<!-- 미리보기 영역 -->
				<div class="preview-container">
					<strong>미리보기</strong>
					<div>
						<img id="mainImagePreview" src="" alt="대표이미지 미리보기"
							style="display: none;">
						<div id="additionalImagePreviews"
							style="display: flex; flex-wrap: wrap;"></div>
					</div>
				</div>


				<div>
					<strong>상세설명 <span class="essential">*</span></strong>
					<textarea rows="4" cols="50"></textarea>
				</div>
			</div>


			<div class="content-box" id="size-container">
				<strong>상품 주요정보 <span class="essential">*</span></strong>

				<div class="form-group">
					<strong>카탈로그</strong> <input type="text" id="catalog"
						placeholder="카탈로그를 입력하세요"> <input type="button" value="찾기"
						id="btn-find">
				</div>

				<div class="form-group">
					<strong>브랜드</strong> <select id="brand-select">
						<option value="">브랜드명을 입력해주세요</option>
						<option value="나이키">나이키</option>
						<option value="아디다스">아디다스</option>
						<option value="뉴발란스">뉴발란스</option>
						<option value="아식스">아식스</option>
					</select>
				</div>

				<div class="form-group">
					<strong>모델명</strong> <input type="text" id="model_name"
						class="text" placeholder="모델명을 입력하세요">
				</div>
			</div>

			<div class="search-item button-group">
				<button id="search-btn" class="btn-search">저장하기</button>
				<input type="reset" id="reset-btn" class="btn-reset" value="초기화">
			</div>



			<!--  end main-content-->
		</div>

		<footer>
			<nav>
				<a href="#" target='_Blank'>Shop</a> <a href="#" target='_Blank'>Support</a>
			</nav>
			<p>
				<span>저자: 코더</span> <span>이메일: coder@example.com</span> <span>Copyright
					&copy; 2024 cocoder. All Rights Reserved</span>
			</p>
		</footer>
	</div>
</body>
</html>