<%@ page contentType="text/html;charset=UTF-8" language="java" info="" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상품 리뷰</title>
<link rel="stylesheet" href="main.css">
<style type="text/css">

</style>

<script>
    function maskNickname(nickname) {
        return nickname.slice(0, 4) + '*****';
    }

    window.onload = function() {
        const nicknames = document.querySelectorAll('.user');
        nicknames.forEach(nicknameElement => {
            const nickname = nicknameElement.innerText;
            nicknameElement.innerText = maskNickname(nickname);
        });

        const reviewContainer = document.querySelector('.review-container');
        const reviews = Array.from(document.querySelectorAll('.review'));
        
        // 원래 순서를 저장합니다.
        const originalOrder = [...reviews];

        // 최신순 클릭 이벤트 추가
        document.querySelector('.latest-reviews').addEventListener('click', function(event) {
            event.preventDefault(); // 기본 클릭 동작 방지
            reviews.sort((a, b) => {
                const dateA = new Date(a.querySelector('.date').innerText);
                const dateB = new Date(b.querySelector('.date').innerText);
                return dateB - dateA; // 최신순 정렬
            });
            reviews.forEach(review => reviewContainer.appendChild(review));
        });

        // 전체보기 클릭 이벤트 추가
        document.querySelector('.filter-list li a[href="#"]').addEventListener('click', function(event) {
            event.preventDefault(); // 링크 기본 동작 방지
            // 원래 순서로 다시 추가
            originalOrder.forEach(review => reviewContainer.appendChild(review));
        });
    };
</script>


</head>
<body>
	<div class="review-container">
		<h1>상품 리뷰</h1>

		<div class="option-container">
			<div class="option">상품 옵션</div>
			<div class="option">#만족도</div>
			<div class="option">#사이즈</div>
			<div class="option">#배송</div>
			<div class="option">#디자인</div>
		</div>

		<div class="filter-container">
			<ul class="filter-list">
				<li><a href="#">전체보기</a></li>
				<li><a href="#" class="latest-reviews">최신순</a></li>
			</ul>
		</div>
	</div>

	<!-- 첫 번째 리뷰 -->
	<div class="review">
		<div class="review-header">
			<span class="stars" data-rating="3">★★★☆☆</span>
			<div class="user-info">
				<span class="user">user12345</span> <span class="separator">|</span>
				<span class="date">2024.10.16</span>
			</div>
			<div class="product-info">
				<span>색상: 블랙</span> <span>사이즈: 260</span>
			</div>
		</div>
		<div class="review-body">
			<div class="review-content">
				<p>이 제품은 크기도 적당하고 편안하게 착용할 수 있었습니다. 하지만 조금 무거운 감이 있어서 장시간 착용에는
					불편했습니다.</p>
			</div>
			<div class="review-image">
				<img src="shoe1.jpg" alt="상품 이미지">
			</div>
		</div>
	</div>

	<!-- 두 번째 리뷰 -->
	<div class="review">
		<div class="review-header">
			<span class="stars" data-rating="4">★★★★☆</span>
			<div class="user-info">
				<span class="user">user56789</span> <span class="separator">|</span>
				<span class="date">2024.10.17</span>
			</div>
			<div class="product-info">
				<span>색상: 화이트</span> <span>사이즈: 270</span>
			</div>
		</div>
		<div class="review-body">
			<div class="review-content">
				<p>깔끔한 디자인이 마음에 듭니다. 가볍고 편하게 신을 수 있어서 만족스럽습니다.</p>
			</div>
			<div class="review-image">
				<img src="shoe2.jpg" alt="상품 이미지">
			</div>
		</div>
	</div>

	<!-- 세 번째 리뷰 -->
	<div class="review">
		<div class="review-header">
			<span class="stars" data-rating="5">★★★★★</span>
			<div class="user-info">
				<span class="user">user98765</span> <span class="separator">|</span>
				<span class="date">2024.10.18</span>
			</div>
			<div class="product-info">
				<span>색상: 레드</span> <span>사이즈: 280</span>
			</div>
		</div>
		<div class="review-body">
			<div class="review-content">
				<p>색상이 너무 예뻐서 샀는데, 실제로 보니 더 예쁩니다. 재질도 좋아서 오래 신을 수 있을 것 같아요.</p>
			</div>
			<div class="review-image">
				<img src="shoe3.jpg" alt="상품 이미지">
			</div>
		</div>
	</div>

	<!-- 네 번째 리뷰 -->
	<div class="review">
		<div class="review-header">
			<span class="stars" data-rating="3">★★★☆☆</span>
			<div class="user-info">
				<span class="user">user54321</span> <span class="separator">|</span>
				<span class="date">2024.10.19</span>
			</div>
			<div class="product-info">
				<span>색상: 블루</span> <span>사이즈: 250</span>
			</div>
		</div>
		<div class="review-body">
			<div class="review-content">
				<p>디자인은 좋은데, 발볼이 좁아서 조금 불편했습니다. 발볼이 넓은 분들은 참고하세요.</p>
			</div>
			<div class="review-image">
				<img src="shoe4.jpg" alt="상품 이미지">
			</div>
		</div>
	</div>

	<!-- 다섯 번째 리뷰 -->
	<div class="review">
		<div class="review-header">
			<span class="stars" data-rating="5">★★★★★</span>
			<div class="user-info">
				<span class="user">user13579</span> <span class="separator">|</span>
				<span class="date">2024.10.20</span>
			</div>
			<div class="product-info">
				<span>색상: 그린</span> <span>사이즈: 240</span>
			</div>
		</div>
		<div class="review-body">
			<div class="review-content">
				<p>아주 편하고 가벼워서 매일 신게 될 것 같아요. 색상도 너무 마음에 듭니다.</p>
			</div>
			<div class="review-image">
				<img src="shoe5.jpg" alt="상품 이미지">
			</div>
		</div>
	</div>
</body>
</html>
