<%@page import="user.vo.SizeVO"%>
<%@page import="manage.review.ReviewVO"%>
<%@page import="manage.productlist.ProductVO"%>
<%@page import="user.dao.UserProductDAO"%>
<%@ page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
// 상품 ID 파라미터 받기
String productId = request.getParameter("id");

// DAO 인스턴스 생성
UserProductDAO dao = new UserProductDAO();

// 상품 상세 정보 조회
ProductVO product = dao.selectByProductId(Integer.parseInt(productId));

// 리뷰 목록 조회 - 수정된 부분
List<ReviewVO> reviewList = dao.selectAllProductReview(Integer.parseInt(productId));

// 상품 사이즈 목록 조회 추가
List<SizeVO> sizeList = dao.selectProductSizes(Integer.parseInt(productId));

// request에 데이터 설정
request.setAttribute("product", product);
request.setAttribute("sizeList", sizeList);
request.setAttribute("reviewList", reviewList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${product.name}-에고엠포리움</title>

<!-- CSS 파일 -->
<link rel="stylesheet"
	href="http://localhost/proejct1/user/css/main.css">
<link rel="stylesheet"
	href="http://localhost/proejct1/user/css/product_details.css">
<link rel="stylesheet"
	href="http://localhost/proejct1/user/css/review.css">

<!-- jQuery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<!-- FontAwesome CDN 추가 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
/* 상품 상세 테이블 스타일 */
table {
	width: 55%;
	margin: 0 auto;
	border-collapse: collapse;
	margin-bottom: 10px;
}

th, td {
	padding: 8px;
	text-align: left;
	border-top: 1px solid #e0e0e0;
	border-bottom: 1px solid #e0e0e0;
}

th {
	width: 25%;
	background-color: #f5f5f5;
	font-weight: normal;
}

.highlight {
	background-color: #f5f5f5;
}
</style>
<style>
/* 상품 이미지 컨테이너 스타일 */
.product-container {
	display: flex;
	gap: 40px;
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
}

.product-image {
	flex: 1;
	max-width: 600px;
}
/* 메인 이미지 스타일 */
.main-image {
	position: relative;
	width: 100%;
	margin-bottom: 20px;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.main-image img {
	width: 100%;
	height: auto;
	display: block;
	transition: transform 0.3s ease;
}

.main-image:hover img {
	transform: scale(1.05);
}
/* 서브 이미지 컨테이너 스타일 */
.sub-images {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 10px;
	margin-top: 20px;
}
/* 서브 이미지 개별 스타일 */
.sub-image {
	position: relative;
	aspect-ratio: 1;
	border-radius: 6px;
	overflow: hidden;
	cursor: pointer;
	border: 2px solid transparent;
	transition: all 0.2s ease;
}

.sub-image.active {
	border-color: #2563eb;
}

.sub-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.2s ease;
}

.sub-image:hover img {
	transform: scale(1.1);
}
/* 반응형 디자인 */
@media ( max-width : 768px) {
	.product-container {
		flex-direction: column;
	}
	.sub-images {
		grid-template-columns: repeat(3, 1fr);
	}
}
</style>
</head>
<body>
	<!-- 헤더 include -->
	<jsp:include page="/common/header.jsp" />

	<div class="product-container">
		<!-- 상품 이미지 -->
		<div class="product-image">
			<!-- 메인 이미지 -->
			<div class="main-image">
				<img
					src="http://localhost/proejct1/common/images/${product.mainImg}"
					alt="${product.name}" id="mainImage">
			</div>
			<!-- 서브 이미지들 -->
			<div class="sub-images">
				<!-- 메인 이미지도 서브 이미지 목록에 포함 -->
				<div class="sub-image active"
					onclick="changeImage(this, '${product.mainImg}')">
					<img
						src="http://localhost/proejct1/common/images/${product.mainImg}"
						alt="${product.name}">
				</div>
				<!-- 서브 이미지들 -->
				<c:if test="${not empty product.subImgList}">
					<c:forEach var="subImg" items="${product.subImgList}">
						<div class="sub-image" onclick="changeImage(this, '${subImg}')">
							<img src="http://localhost/proejct1/common/images/${subImg}"
								alt="${product.name}">
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>

		<!-- 상품 상세 정보 -->
		<div class="product-details">
			<h1>${product.name}</h1>

			<div class="price-container">
				<c:choose>
					<c:when test="${product.discountFlag eq 'Y'}">
						<span class="price line-through"> 정가 : <fmt:formatNumber
								value="${product.price}" type="number" />원<br>
						</span>
						<span class="discount-price"> 할인가 : <fmt:formatNumber
								value="${product.discountPrice}" type="number" />원
						</span>
					</c:when>
					<c:otherwise>
						<span class="price"> 정가 : <fmt:formatNumber
								value="${product.price}" type="number" />원
						</span>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="free-exchange">무료배송</div>

			<!-- 옵션 선택 -->
			<select id="color" name="color" onchange="updatePrice()">
				<option value="">컬러</option>
				<option value="black">블랙</option>
				<!-- 추가 컬러 옵션 -->
			</select>

			<!-- 사이즈 선택 부분 수정 -->
			<select id="size" name="size" onchange="updatePrice()">
				<option value="">사이즈</option>
				<c:forEach var="size" items="${sizeList}">
					<option value="${size.chooseSizeId}">${size.chooseSizeId}</option>
				</c:forEach>
			</select>

			<!-- 총 금액 -->
			<div class="totals">
				<div class="total-amount">총 상품 금액</div>
				<div>
					<span class="total-quantity" id="total-quantity">총 수량 0개</span> <span
						class="total-price" id="total-price">0원</span>
				</div>
			</div>

			<!-- 구매 버튼 -->
			<button class="buy-button" onclick="handleBuyClick()">구매하기</button>
		</div>
	</div>

	<!-- 탭 메뉴 -->
	<div class="tabs">
		<div class="tab active" data-tab="details">상세정보</div>
		<div class="tab" data-tab="reviews">리뷰</div>
	</div>

	<!-- 상품 상세 정보 -->
	<div id="details" class="tab-content active">
		<table>
			<tr>
				<th>상품번호</th>
				<td>${product.productId}</td>
				<th class="highlight">상품상태</th>
				<td>신상품</td>
			</tr>
			<tr>
				<th>제조사</th>
				<td>${product.brand}</td>
				<th class="highlight">브랜드</th>
				<td>${product.brand}</td>
			</tr>
			<tr>
				<th>원산지</th>
				<td colspan="3">대한민국</td>
			</tr>
			<tr>
				<th>A/S 안내</th>
				<td colspan="3">상세페이지 참조</td>
			</tr>
		</table>

		<!-- 상세 이미지 -->
		<div class="expanded-content">
			<img src="" alt="상세 정보">
		</div>

		<div class="parent-container">
			<button class="expand-button">상세정보 펼쳐보기</button>
		</div>
	</div>

	<!-- 리뷰 섹션 -->
	<div id="reviews" class="tab-content">
		<div class="review-container">
			<h1>상품 리뷰</h1>
			<div class="filter-container"></div>

			<c:choose>
				<c:when test="${not empty reviewList}">
					<c:forEach var="review" items="${reviewList}">
						<div class="review">
							<div class="review-header">
								<span class="stars" data-rating="${review.rating}"> <!-- 별점 표시 수정 -->
									<c:choose>
										<c:when test="${review.rating eq 1}">★☆☆☆☆</c:when>
										<c:when test="${review.rating eq 2}">★★☆☆☆</c:when>
										<c:when test="${review.rating eq 3}">★★★☆☆</c:when>
										<c:when test="${review.rating eq 4}">★★★★☆</c:when>
										<c:when test="${review.rating eq 5}">★★★★★</c:when>
									</c:choose>
								</span>
								<div class="user-info">
									<span class="user">${review.userId}</span> <span
										class="separator">|</span> <span class="date"><fmt:formatDate
											value="${review.createdAt}" pattern="yyyy.MM.dd" /></span>
								</div>
								<div class="product-info">
									<span>색상: 블랙</span> <span>사이즈: 260</span>
								</div>
							</div>
							<div class="review-body">
								<div class="review-content">
									<p>${review.content}</p>
								</div>
								<div class="review-image">
									<img
										src="http://localhost/proejct1/common/review_images/${review.reviewImg}"
										alt="리뷰 이미지">
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div style="text-align: center; padding: 50px 0;">
						<p>등록된 리뷰가 없습니다.</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>


	<!-- JavaScript -->
	<script>
    // 가격 업데이트
    function updatePrice() {
        const color = document.getElementById("color").value;
        const size = document.getElementById("size").value;
        const totalPrice = document.getElementById("total-price");
        const totalQuantity = document.getElementById("total-quantity");

        if (color !== "" && size !== "") {
            <c:choose>
            <c:when test="${product.discountFlag eq 'Y'}">
            totalPrice.textContent = '<fmt:formatNumber value="${product.discountPrice}" type="number"/>원';
            </c:when>
            <c:otherwise>
            totalPrice.textContent = '<fmt:formatNumber value="${product.price}" type="number"/>원';
            </c:otherwise>
            </c:choose>
            totalQuantity.textContent = "총 수량 1개";
        } else {
            totalPrice.textContent = "0원";
            totalQuantity.textContent = "총 수량 0개";
        }
    }

    // 구매 버튼 클릭
    function handleBuyClick() {
        const color = document.getElementById("color").value;
        const size = document.getElementById("size").value;

        if (color === "" || size === "") {
            alert("옵션을 선택해주세요.");
            return;
        }

        <c:choose>
        <c:when test="${product.discountFlag eq 'Y'}">
        location.href = '../payment/payment.jsp?productId=${product.productId}&color=' + color + '&size=' + size + '&price=${product.discountPrice}';
        </c:when>
        <c:otherwise>
        location.href = '../payment/payment.jsp?productId=${product.productId}&color=' + color + '&size=' + size + '&price=${product.price}';
        </c:otherwise>
        </c:choose>
    }

    // 탭 전환
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.getAttribute('data-tab');

            // 탭 활성화 상태 변경
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

            tab.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        });
    });

    // 상세정보 펼치기/접기
    const expandButton = document.querySelector('.expand-button');
    const expandedContent = document.querySelector('.expanded-content');

    expandButton.addEventListener('click', () => {
        expandedContent.classList.toggle('active');
        expandButton.textContent = expandedContent.classList.contains('active')
            ? '상세정보 접기'
            : '상세정보 펼쳐보기';

        // 스크롤 이동
        const scrollTarget = expandedContent.classList.contains('active')
            ? expandButton
            : expandedContent;
        scrollTarget.scrollIntoView({behavior: 'smooth'});
    });
    
    function changeImage(element, imgSrc) {
        // 메인 이미지 변경
        document.getElementById('mainImage').src = 'http://localhost/proejct1/common/images/' + imgSrc;
        // active 클래스 관리
        document.querySelectorAll('.sub-image').forEach(el => {
            el.classList.remove('active');
        });
        element.classList.add('active');
    }
    // 이미지 줌 기능 (선택적)
    const mainImage = document.getElementById('mainImage');
    const mainImageContainer = document.querySelector('.main-image');
    mainImageContainer.addEventListener('mousemove', function(e) {
        const bounds = this.getBoundingClientRect();
        const x = e.clientX - bounds.left;
        const y = e.clientY - bounds.top;
        const xPercent = x / bounds.width * 100;
        const yPercent = y / bounds.height * 100;
        mainImage.style.transformOrigin = `${xPercent}% ${yPercent}%`;
    });
    mainImageContainer.addEventListener('mouseenter', function() {
        mainImage.style.transform = 'scale(1.5)';
    });
    mainImageContainer.addEventListener('mouseleave', function() {
        mainImage.style.transform = 'scale(1)';
        mainImage.style.transformOrigin = 'center center';
    });
    
</script>

	<!-- 푸터 include -->
	<jsp:include page="/common/footer.jsp" />
</body>
</html>