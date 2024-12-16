<%@page import="manage.productlist.ProductVO"%>
<%@page import="user.dao.UserProductDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" info=""%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
// DAO 인스턴스 생성
UserProductDAO dao = new UserProductDAO();
ProductVO pVO = new ProductVO();

// 검색 파라미터 처리
String searchBrand = request.getParameter("brand");
String searchName = request.getParameter("name");
String searchModel = request.getParameter("model");
String priceStr = request.getParameter("price");
String sortMethod = request.getParameter("sort");
String category = request.getParameter("category");

// 검색 조건 설정
if (searchBrand != null && !searchBrand.isEmpty()) {
	pVO.setBrand(searchBrand);
}
if (searchName != null && !searchName.isEmpty()) {
	pVO.setProductName(searchName);
}
if (searchModel != null && !searchModel.isEmpty()) {
	pVO.setModelName(searchModel);
}
if (priceStr != null && !priceStr.isEmpty()) {
	try {
		pVO.setPrice(Integer.parseInt(priceStr));
	} catch (NumberFormatException e) {
		// 가격이 숫자가 아닌 경우 무시
	}
}

// 브랜드 파라미터 처리
String brand = request.getParameter("brand");
if (brand != null && !brand.isEmpty()) {
	pVO.setBrand(brand);
}

// 정렬 방식 기본값 설정
if (sortMethod == null) {
	if ("best".equals(category)) {
		sortMethod = "popular"; // 베스트상품은 인기도순으로 정렬
	} else {
		sortMethod = "latest"; // 기본 정렬은 최신순
	}
}

try {
	List<ProductVO> productList = dao.selectAll(pVO, sortMethod);
	request.setAttribute("productList", productList);
} catch (SQLException e) {
	e.printStackTrace();
	request.setAttribute("productList", new ArrayList<ProductVO>());
}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>에고엠포리움</title>
<link rel="stylesheet"
	href="http://localhost/proejct1/user/css/main.css">
</head>
<body>
	<!-- 헤더 include -->
	<jsp:include page="/common/header.jsp" />

	<!-- 메인 배너 -->
	<div class="banner">
		<p>배너</p>
	</div>

	<!-- 상품 목록 타이틀 -->
	<div class="product-title">
		<c:choose>
			<c:when test="${param.category eq 'best'}">베스트상품</c:when>
			<c:when test="${not empty param.brand}">${param.brand}</c:when>
			<c:otherwise>전체상품</c:otherwise>
		</c:choose>
	</div>

	<!-- 정렬 옵션 -->
	<div class="sort-options">
		<a
			href="index.jsp?sort=popular${not empty param.name ? '&name='.concat(param.name) : ''}${not empty param.brand ? '&brand='.concat(param.brand) : ''}${not empty param.category ? '&category='.concat(param.category) : ''}"
			class="sort-link ${sortMethod eq 'popular' ? 'active' : ''}">인기도순</a>
		| <a
			href="index.jsp?sort=latest${not empty param.name ? '&name='.concat(param.name) : ''}${not empty param.brand ? '&brand='.concat(param.brand) : ''}${not empty param.category ? '&category='.concat(param.category) : ''}"
			class="sort-link ${sortMethod eq 'latest' ? 'active' : ''}">최신등록순</a>
		| <a
			href="index.jsp?sort=lowPrice${not empty param.name ? '&name='.concat(param.name) : ''}${not empty param.brand ? '&brand='.concat(param.brand) : ''}${not empty param.category ? '&category='.concat(param.category) : ''}"
			class="sort-link ${sortMethod eq 'lowPrice' ? 'active' : ''}">낮은가격순</a>
		| <a
			href="index.jsp?sort=highPrice${not empty param.name ? '&name='.concat(param.name) : ''}${not empty param.brand ? '&brand='.concat(param.brand) : ''}${not empty param.category ? '&category='.concat(param.category) : ''}"
			class="sort-link ${sortMethod eq 'highPrice' ? 'active' : ''}">높은가격순</a>
	</div>

	<!-- 상품 그리드 -->
	<div class="product-grid">
		<c:choose>
			<c:when test="${not empty productList}">
				<c:forEach var="product" items="${productList}">
					<div class="product-item">
						<a href="user/main/product_detail.jsp?id=${product.productId}">
							<img
							src="http://localhost/project1/common/images/${product.mainImg}"
							alt="${product.productName}">
						</a>
						<div class="product-info ">
							<h3>${product.productName}</h3>
							<p class="brand">${product.brand}</p>
							<p class="price">
								<fmt:formatNumber value="${product.price}" type="number" />
								원
							</p>
						</div>
					</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<div class="no-products-message">
					<p>등록된 상품이 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- 브랜드 필터링 스크립트 -->
	<script>
    function showBrandProducts(brand) {
        const allProducts = document.querySelectorAll('.product-item');
        allProducts.forEach(product => {
            if (product.querySelector('h3').textContent.includes(brand)) {
                product.style.display = 'block';
            } else {
                product.style.display = 'none';
            }
        });
    }

    // DOM 로드 완료 시 실행
    document.addEventListener('DOMContentLoaded', () => {
        // 기본 네비게이션 버튼 활성화
        const bestButton = document.querySelector('.nav-button.active');
        if (bestButton) {
            setActive(bestButton);
        }
    });

    // 네비게이션 버튼 활성화 함수
    function setActive(element) {
        const buttons = document.querySelectorAll('.nav-button');
        const contents = document.querySelectorAll('.content');

        // 모든 버튼 비활성화
        buttons.forEach(button => {
            button.classList.remove('active');
            button.style.color = 'gray';
        });

        // 선택된 버튼 활성화
        element.classList.add('active');
        element.style.color = 'black';

        // 모든 콘텐츠 숨김
        contents.forEach(content => {
            content.style.display = 'none';
        });

        // 선택된 콘텐츠 표시
        const contentId = element.textContent.trim();
        if (contentId === '베스트상품') {
            document.querySelector('#전체상품').style.display = 'block';
        } else {
            const contentElement = document.getElementById(contentId);
            if (contentElement) {
                contentElement.style.display = 'block';
            }
        }
    }
</script>

	<!-- 푸터 include -->
	<jsp:include page="common/footer.jsp" />
</body>
</html>