<%@page import="java.util.List"%>
<%@page import="manager.productlist.ProductVO"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="상품 리스트"%>

<%
// 이동한 페이지에서 새로 고침 했을 때 작업이 여러번 발생하지 않도록 하기위한 flag값 저장
session.setAttribute("uploadFlag", false);
%>

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
	href="http://localhost/project1/common/images/favicon.ico" />
<link rel="stylesheet" type="text/css"
	href="http://localhost/project1/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://localhost/project1/common/css/main_Sidbar.css">
<link rel="stylesheet"
	href="http://localhost/project1/common/css/footer.css">


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
	width: 1000px;
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
	width: 60%;
	margin: 0 auto;
	padding: 20px;
	border: 1px solid #ccc;
	box-sizing: border-box;
}

#selected-sizes {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	padding: 0;
	list-style: none;
}

.size-item {
	width: 23%;
	padding: 5px;
	border: 1px solid #ccc;
	text-align: center;
	box-sizing: border-box;
}

.size-item:nth-child(4n) {
	margin-right: 0;
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

#btnReset, #btnSubmit {
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

button.button-select-all {
	margin-top: 10px;
	font-size: 13px;
	background-color: #ddd;
	border: none;
	border-radius: 5px;
}

#reset-btn {
	color: white;
	margin-right: 10px;
}

#btnSubmit {
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
<!-- 사이즈 -->
<script type="text/javascript">

$(function() {
	$('.button-add-size').on('click', function() {
		addSelectedSizes();
	});
	

	$('#selected-sizes').on('click', '.delete-size', function() {
		$(this).parent().remove();
	});
	

	$('.button-select-all').click(function() {
	    toggleSelectAll();
	});
	
	
});// ready

	function addSelectedSizes() {
		$('#selected-sizes').empty();

		$('.size-checkboxes input[type="checkbox"]:checked').each(
				function() {
					const size = $(this).val();
					const li = $('<li>' + size
							+ ' <button class="delete-size">삭제</button></li>');
					$('#selected-sizes').append(li);
				});
	}// addSelectedSizes

	function toggleSelectAll() {
	    const $checkboxes = $('.size-checkbox');
	    const allChecked = $checkboxes.filter(':checked').length === $checkboxes.length;

	    $checkboxes.prop('checked', !allChecked);
	}// toggleSelectAll

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
$(document).ready(function() {
  // 할인 설정 라디오 버튼 변경 시 이벤트 처리
  $('input[name="sale"]').change(function() {
    if ($('#sale-on').is(':checked')) {
      $('#discount-details').show(); // 할인 입력란 표시
      updateTotalPrice();
    } else {
      $('#discount-details').hide();
      $('#totalprice').text('할인가: 0원 (할인 없음)');
    }
  });

  // 판매가나 할인 금액이 변경될 때 실시간으로 할인된 가격 업데이트
  $('#selling-price, #discount-amount').on('input', function() {
    updateTotalPrice();
  });
});

//할인된 가격을 계산하고 표시하는 함수
function updateTotalPrice() {
  const sellingPrice = parseFloat($('#selling-price').val()) || 0; // 판매가
  const discountAmount = parseFloat($('#discount-amount').val()) || 0; // 할인 금액

  let discountedPrice = sellingPrice;

  // 할인 적용 시 유효성 검사
  if ($('#sale-on').is(':checked')) {
    if (sellingPrice <= 0 || discountAmount < 0 || isNaN(sellingPrice) || isNaN(discountAmount) || discountAmount >= sellingPrice) {
      $('#totalprice').text('유효한 판매가와 할인 금액을 입력해 주세요.');
      return;
    }

    // 할인 적용하여 최종 가격 계산
    discountedPrice = sellingPrice - discountAmount;
  }

  // 최종 가격 표시(반올림)
  $('#totalprice').text('할인가: ' + Math.round(discountedPrice) + '원 (' + Math.round(discountAmount) + '원 할인)');

}
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
					const files = event.target.files;
					const previewContainer = $('#additionalImagePreviews');
					previewContainer.empty(); // 이전 미리보기 이미지 지우기

					// 선택된 파일 개수 검사
					if (files.length > 5) {
						alert("추가 이미지는 최대 5개까지 선택할 수 있습니다.");
						return;
					}

					for (let i = 0; i < files.length; i++) { // 최대 5개까지 처리
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

<!-- 상품등록  -->
<script type="text/javascript">
	$(function() {

		let isSaving = false;
		
		$(window).on("beforeunload", function() {
		    if (!isSaving) {
		        return "페이지를 벗어나시겠습니까?";
		    }
		});
		
		$("#btnSubmit").click(function() {
			isSaving = true;
			
			if(chkNull()){
				uploadImg();
				insertData();
			} 
		})// click
		
		$('#btnReset').click(function() {

			if (confirm("초기화 하시겠습니까?")){
		    $("#productName").val('');        
		    $("#selling-price").val('');       
		    $("#brand-select").val('');         
		    $("#model_name").val('');           
		    $("#mainImage").val('');            
		    $("textarea").val('');             
		    $("#stockQuantity").val('');        
		    $("#additionalImages").val('');
		    
		 	// 미리보기 이미지 숨기기
		     $('#mainImagePreview').empty(); 
		     $('#additionalImagePreviews').empty();
		     
		     // 체크박스 초기화
		     $("input[type='checkbox']").prop('checked', false);

		     // 라디오 버튼 초기화
		     $("input[name='sale']").prop('checked', false); 
		     
			}
		});


	})
	
function chkNull() {
    // 필수 항목들을 jQuery를 이용해 선택
    var productName = $("#productName").val().trim();
    var sellingPrice = $("#selling-price").val().trim();
    var brandSelect = $("#brand-select").val();
    var modelName = $("#model_name").val().trim();
    var mainImage = $("#mainImage").val();
    var detailDescription = $("textarea").val().trim();
    var stockQuantity = $("#stockQuantity").val().trim();

    // 사이즈 체크박스 선택 여부 확인
    var sizeChecked = $("input[type='checkbox']:checked").length > 0;

    // 라디오 버튼 선택 여부 확인
    var saleSelected = $("input[name='sale']:checked").val();

    // 필수 항목 검증
    if (productName === "") {
        alert("상품명을 입력해 주세요.");
        $("#productName").focus();
        return false;
    }
    if (sellingPrice === "" || isNaN(sellingPrice) || Number(sellingPrice) <= 0) {
        alert("판매 가격을 올바르게 입력해 주세요.");
        $("#selling-price").focus();
        return false;
    }
    if (brandSelect === "" || brandSelect === null) {
        alert("브랜드를 선택해 주세요.");
        $("#brand-select").focus();
        return false;
    }
    if (modelName === "") {
        alert("모델명을 입력해 주세요.");
        $("#model_name").focus();
        return false;
    }
    if (mainImage === "") {
        alert("대표 이미지를 선택해 주세요.");
        $("#mainImage").focus();
        return false;
    }
    if (!sizeChecked) {
        alert("사이즈를 하나 이상 선택해 주세요.");
        return false;
    }
    if (detailDescription === "") {
        alert("상세 설명을 입력해 주세요.");
        $("textarea").focus();
        return false;
    }

 // 할인가 요구 사항 추가
    if (saleSelected === "Y") {
        var discountAmount = $("#discount-amount").val().trim();

        // 할인 금액이 null이거나 비어있는지 확인
        if (discountAmount === "") {
            alert("할인 금액을 입력해 주세요.");
            $("#discount-amount").focus();
            return false;
        }

        // 할인 금액이 0보다 작은지 확인
        if (isNaN(discountAmount) || Number(discountAmount) <= 0) {
            alert("할인 금액은 0보다 작을 수 없습니다.");
            $("#discount-amount").focus();
            return false;
        }
    }


    // 재고 수량 추가 검증
    if (stockQuantity === "" || isNaN(stockQuantity) || Number(stockQuantity) < 0) {
    	$('#stockError').show();
        $("#stockQuantity").focus();
        return false;
    }

    return true;
}// chkNull


	function insertData() {
	    var productName = $("#productName").val();
	    var sellingPrice = parseFloat($("#selling-price").val().trim());
	    var brandSelect = $("#brand-select").val();
	    var modelName = $("#model_name").val().trim().toUpperCase();
	    var detailDescription = $("textarea").val().trim();
	    var discountAmount = parseFloat($("#discount-amount").val().trim()) || 0; // 할인 금액, 없으면 0
	    var discountPrice = 0;
	    var mainImgName = $("#mainImage")[0].files[0].name;
	    var stockQuantity = $("#stockQuantity").val().trim();
	    var additionalImgName = Array.from($("#additionalImages")[0].files).map(file => file.name);
	    
	    
	    // 라디오 버튼 선택 여부 확인
	    var saleSelected = $("input[name='sale']:checked").val();

	    // 할인 적용
	    if (saleSelected === 'Y') {
	        discountPrice = sellingPrice - discountAmount; // 할인 적용
	    } else {
	        discountAmount = 0; // 할인 선택 안 하면 할인 금액 0
	    }
	    
	    // 선택한 사이즈
	    var selectedSizes = [];
		$("input[type='checkbox']:checked").each(function() {
			selectedSizes.push($(this).val());
		});
	    
	 // AJAX 요청 전송
	    $.ajax({
	        url: "insertData.jsp",
	        type: "POST",
	        data: {
	            productName: productName,
	            sellingPrice: sellingPrice,
	            brandSelect: brandSelect,
	            modelName: modelName,
	            detailDescription: detailDescription,
	            discountAmount: discountAmount,
	            discountPrice: discountPrice,
	            saleSelected: saleSelected,
	            mainImgName: mainImgName,
	            stockQuantity: stockQuantity,
	            selectedSizes: selectedSizes.join(","),
	            additionalImgName: additionalImgName.join(",")
	        },
	        success: function(response) {
	            if (response.includes("제품이 성공적으로 삽입되었습니다.")) {
	                alert(response);
	                location.href = "productList.jsp";
	            } else {
	                alert(response);
	            }
	        },
	        error: function(xhr) {
	            alert("데이터 삽입 중 오류가 발생했습니다: " + xhr.statusText);
	        }
	    }); // ajax

	} // insertData
	
	function uploadImg(){

		// 업로드 가능 확장자는 이미지 관련 확장자만 가능하도록 유효성 검증을 해야한다.
		// jpg, gif, png, bmp 확장자만 업로드 가능
		// 위의 확장자가 아니면 alert("업로드 가능 확장자가 아닙니다.")를 보여주고 return
		allowedExtensions = /(\.jpg|\.jpeg|\.gif|\.png|\.bmp)$/i;
		var filePath = $("#mainImage").val();

		if (!allowedExtensions.exec(filePath)) {
			alert("업로드 가능 확장자가 아닙니다.");
			return;
		}
		$("#frm").submit();
	
	}

</script>

</head>
<body>

	<jsp:include page="sidebar.jsp" />


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
						maxlength="100"> <input type="text" id="charCount"
						value="0/100" disabled="disabled" style="width: 55px">
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
							class="onoff" value="Y" name="sale"> 설정함
						</label> <label for="sale-off"> <input type="radio" id="sale-off"
							class="onoff" value="N" name="sale"> 설정안함
						</label>
					</div>

					<div class="discount-details" id="discount-details"
						style="display: none;">
						<p>기본할인 판매가에서 즉시 할인이 가능한 할인 유형으로 할인된 가격으로 상품을 판매할 수 있습니다.</p>
						<div class="discount-input">
							<input type="number" id="discount-amount"
								placeholder="할인 금액을 입력하세요" min="0" required> <input
								type="text" value="원" disabled style="width: 30px"> <span>할인</span>
						</div>
						<div id="totalprice">할인가 0원(0원 할인)</div>
					</div>

				</div>
			</div>
			<div class="content-box" id="saleprice-container">
				<strong>재고수량 <span class="essential">*</span></strong>
				<div>
					<input type="number" id="stockQuantity" class="productName"
						placeholder="재고 수량을 입력하세요" min="0" required>
				</div>
				<div id="stockError" style="color: red; display: none;">재고 수량은
					0 이상이어야 합니다.</div>
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
							AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
							List<ProductVO> standardSizeList = apmDAO.selectStandardSize();

							if (standardSizeList != null) {
								for (ProductVO pVO : standardSizeList) {
									int[] standardSizes = pVO.getStandardSize(); // 배열을 가져옴
									if (standardSizes != null) {
								for (int size : standardSizes) {
									out.print("<label><input type=\"checkbox\" class=\"size-checkbox\" value=\"" + size + "\"> " + size
											+ "</label>");
								}
									}
								}
							}
							%>
							<button class="button-select-all">전체 선택/해제</button>
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

				<form action="upload_process.jsp" method="post"
					enctype="multipart/form-data" id="frm" name="frm">
					<strong>상품 이미지</strong>
					<div>
						<strong>대표이미지 <span class="essential">*</span></strong> <input
							type="file" id="mainImage" name="mainImage" accept="image/*">
						<strong>추가이미지 (최대 5개)</strong> <input type="file"
							id="additionalImages" accept="image/*" multiple>
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

				</form>
			</div>


			<div class="content-box" id="size-container">
				<strong>상품 주요정보 <span class="essential">*</span></strong>
				<div class="form-group">
					<strong>브랜드</strong> <select id="brand-select">
						<option value="">브랜드명을 입력해주세요</option>
						<option value="NIKE">나이키</option>
						<option value="ADIDAS">아디다스</option>
						<option value="NEWBALANCE">뉴발란스</option>
						<option value="ASICS">아식스</option>
					</select>
				</div>
				<div class="form-group">
					<strong>모델명</strong> <input type="text" id="model_name"
						class="text" placeholder="모델명을 입력하세요">
				</div>
			</div>

			<div class="search-item button-group">
				<input type="button" id="btnSubmit" class="btn-save" value="저장하기">
				<input type="reset" id="btnReset" class="btn-reset" value="초기화">
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