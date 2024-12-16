<%@page import="user.dao.OrderDAO"%>
<%@page import="java.io.File"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/session_chk.jsp"%>
<%
// 세션에서 데이터 받아오기
String productName = (String) session.getAttribute("reviewProductName");
String imgName = (String) session.getAttribute("reviewImgName");
String orderId = (String) session.getAttribute("reviewOrderId");

// product_id 조회
OrderDAO oDAO = new OrderDAO();
int productId = oDAO.selectProductId(orderId);

// 세션 데이터 사용 후 삭제
session.removeAttribute("reviewProductName");
session.removeAttribute("reviewImgName");
session.removeAttribute("reviewOrderId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap CDN 시작 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
	text-align: center; /* 전체 중앙 정렬 */
}

h2 {
	margin-bottom: 20px;
}

.review-container {
	max-width: 600px;
	margin: auto;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
	background-color: #f9f9f9;
}

.product-info {
	display: flex;
	align-items: center; /* 이미지와 텍스트 수평 정렬 */
	margin-bottom: 20px;
}

.product-info img {
	width: 100px; /* 이미지 크기 조정 */
	margin-right: 15px; /* 이미지와 이름 사이 간격 */
}

.star-rating {
	display: flex;
	justify-content: center;
	margin-bottom: 10px;
}

.star {
	font-size: 40px; /* 별 크기 증가 */
	color: lightgray;
	cursor: pointer;
}

.star.selected {
	color: gold;
}

.prompt {
	text-align: center; /* 중앙 정렬 */
	margin: 10px 0; /* 여백 추가 */
	font-weight: bold; /* 진하게 */
	font-size: 18px; /* 글자 크기 증가 */
}

.review-textarea {
	width: 100%; /* 전체 너비 사용 */
	height: 100px;
	margin-top: 10px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	resize: none;
	background-color: white; /* 흰색 배경 */
	box-sizing: border-box; /* 패딩 및 테두리 포함 */
}

.proName {
	font-weight: bold;
	font-size: 15px;
}

.upload-btn {
	margin-top: 10px;
	width: 95%; /* 전체 너비 사용 */
	border: 2px dashed #ccc; /* 점선 테두리 */
	background-color: #fff; /* 흰색 배경 */
	padding: 10px;
	border-radius: 5px;
	text-align: center; /* 중앙 정렬 */
}

.upload-btn label {
	color: #333; /* 진한 검정색 글씨 */
	cursor: pointer; /* 손가락 커서 */
	display: block; /* 블록으로 변경하여 전체 너비 사용 */
}

.button-container {
	display: flex;
	justify-content: center; /* 중앙 정렬 */
	margin-top: 20px;
}

button {
	padding: 10px 0; /* 수직 패딩 */
	border: none;
	border-radius: 5px;
	cursor: pointer;
	width: calc(50% - 10px); /* 반반 크기 조정 */
	margin: 0 5px; /* 버튼 간격 */
}

.submit {
	background-color: #808080; /* 회색 */
	color: white; /* 흰색 글씨 */
}

.cancel {
	background-color: white; /* 흰색 */
	color: black; /* 검정색 글씨 */
	border: 1px solid #ccc; /* 회색 테두리 */
}

.submit:hover {
	background-color: #696969; /* 어두운 회색 */
}

.cancel:hover {
	background-color: #f0f0f0; /* 밝은 회색 */
}

.small-text {
	font-size: 12px; /* 작은 글씨 크기 */
	color: #666; /* 회색 */
	margin-top: -5px; /* 약간 위로 위치 조정 */
}
</style>
<script type="text/javascript">
$(function(){

});//ready
</script>
</head>
<body>
	<div class="review-container">
		<form id="reviewForm" action="review_process.jsp" method="post"
			enctype="multipart/form-data">
			<div class="product-info">
				<%
				String contextPath = request.getContextPath();
				String imagePath = "http://localhost/proejct1/common/images/" + imgName;
				%>
				<img src="<%=imagePath%>" alt="<%=imgName%>"
					onerror="this.onerror=null; this.src='http://localhost/proejct1/common/images/no-image.png';" />
				<div>
					<span class="proName"><%=productName%></span>
				</div>
			</div>
			<div class="prompt">상품은 만족하셨나요?</div>
			<div class="star-rating">
				<span class="star" data-value="1">★</span> <span class="star"
					data-value="2">★</span> <span class="star" data-value="3">★</span>
				<span class="star" data-value="4">★</span> <span class="star"
					data-value="5">★</span>
			</div>
			<div class="small-text">선택하세요</div>
			<div class="prompt">어떤 점이 좋았나요?</div>
			<textarea class="review-textarea" id="reviewText"
				name="reviewContent" placeholder="리뷰 내용을 10자 이상 입력하세요..."></textarea>
			<div class="image-upload">
				<div class="preview-container"
					style="display: none; margin: 10px 0;">
					<img id="preview" style="max-width: 200px; max-height: 200px;">
				</div>
				<div class="upload-btn" style="margin: 10px 0;">
					<input type="file" id="reviewImage" name="reviewImage"
						accept="image/*" style="display: none;"
						onchange="previewImage(this)">
					<button type="button"
						onclick="document.getElementById('reviewImage').click()"
						style="padding: 8px 15px;">사진 첨부하기</button>
					<span id="fileName" style="margin-left: 10px; color: #666;"></span>
				</div>
			</div>
			<input type="hidden" name="rating" id="ratingInput" value="0">
			<input type="hidden" name="orderId" value="<%=orderId%>">
			<div class="button-container">
				<button type="button" class="cancel"
					onclick="location.href='http://localhost/proejct1/index.jsp'">취소</button>
				<button type="button" class="submit" onclick="submitReview()">확인</button>
			</div>
		</form>
	</div>

	<script>
        // 별점 선택 기능
        const stars = document.querySelectorAll('.star');
        let selectedRating = 0;

        stars.forEach(star => {
            star.addEventListener('click', () => {
                selectedRating = star.getAttribute('data-value');
                document.getElementById('ratingInput').value = selectedRating;
                updateStarRating();
                updateRatingText(selectedRating);
            });
        });

        function updateStarRating() {
            stars.forEach(star => {
                star.classList.remove('selected');
                if (star.getAttribute('data-value') <= selectedRating) {
                    star.classList.add('selected');
                }
            });
        }
        
        function updateRatingText(rating) {
            const smallText = document.querySelector('.small-text');
            smallText.textContent = rating + "점";
        }
        
        function previewImage(input) {
            const preview = document.getElementById('preview');
            const previewContainer = document.querySelector('.preview-container');
            const fileNameSpan = document.getElementById('fileName');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    // 미리보기 이미지에 Data URL 설정
                    preview.src = e.target.result;
                    previewContainer.style.display = 'block';
                    fileNameSpan.textContent = input.files[0].name;
                };
                
                // 이미지를 Data URL로 읽기
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.src = '';
                previewContainer.style.display = 'none';
                fileNameSpan.textContent = '';
            }
        }

        function submitReview() {
        	  const reviewText = document.getElementById('reviewText').value;
        	  const rating = document.getElementById('ratingInput').value;
        	  const fileInput = document.getElementById('reviewImage');
        	  
        	  const orderId = '<%=orderId%>';
        	  
        	  if (reviewText.length < 10) {
        	    alert('리뷰는 최소 10자 이상 입력해야 합니다.');
        	    return;
        	  }

        	  if (rating === '0') {
        	    alert('별점을 선택해주세요.');
        	    return;
        	  }

        	  const formData = new FormData();
        	  formData.append('reviewContent', reviewText);
        	  formData.append('rating', rating);
        	  formData.append('orderId', orderId);

        	  if (fileInput.files.length > 0) {
        	    const file = fileInput.files[0];

        	    // 파일 크기 체크 (5MB 제한)
        	    if (file.size > 5 * 1024 * 1024) {
        	      alert('파일 크기는 5MB를 초과할 수 없습니다.');
        	      return;
        	    }

        	    // 파일 형식 체크
        	    const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
        	    if (!validTypes.includes(file.type)) {
        	      alert('JPG, PNG, GIF 형식의 이미지만 업로드 가능합니다.');
        	      return;
        	    }

        	    formData.append('reviewImage', file);
        	  }

        	  $.ajax({
        	    type: 'POST',
        	    url: 'review_process.jsp',
        	    data: formData,
        	    processData: false,
        	    contentType: false,
        	    success: function(response) {
        	        alert('리뷰가 등록되었습니다.');
        	        window.location.href = 'http://localhost/proejct1/index.jsp';
        	    },
        	    error: function(xhr, status, error) {
        	      console.error('Error:', error);
        	      alert('리뷰 등록 중 오류가 발생했습니다. 다시 시도해주세요.');
        	    }
        	  });
        	}
    </script>
</body>
</html>