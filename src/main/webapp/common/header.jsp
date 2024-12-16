<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org">
<head>
<meta charset="UTF-8">
<title>header.jsp</title>
<link rel="stylesheet"
	href="http://localhost/project1/user/css/main.css">
<!--    bootstrap CDN  start-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>
<!--    JQuery CDN start-->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style>
.dropdown {
	position: relative;
	display: inline-block;
}

.dropdown-menu {
	display: none;
	position: absolute;
	background-color: #fff;
	min-width: 160px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	list-style: none;
	padding: 0;
	margin: 0;
	border: 1px solid #ddd;
}

.dropdown:hover .dropdown-menu {
	display: block;
}

.dropdown-menu li a {
	padding: 12px 16px;
	text-decoration: none;
	display: block;
	color: #333;
}

.dropdown-menu li a:hover {
	background-color: #f5f5f5;
}

/* 기존 auth-button 스타일이 있다면 유지하고, 없다면 추가해주세요 */
.auth-button {
	text-decoration: none;
	padding: 8px 15px;
	color: #333;
	cursor: pointer;
}
</style>
</head>

<body>
	<div class="head">
		<div class="header">
			<div class="header-content">
				<a href="http://localhost/project1/index.jsp"> <img
					src="http://localhost/project1/common/egoporium.png" alt="쇼핑몰 로고">
				</a>
			</div>

			<div class="search-and-login">
				<div class="search-bar">
					<form action="index.jsp" method="get" id="searchForm">
						<input type="text" name="name" value="${param.name}"
							placeholder="검색..." id="searchInput"> <input
							type="hidden" name="sort" value="${param.sort}">
						<button type="submit" aria-label="검색">🔍</button>
					</form>
				</div>
				<div class="auth-buttons">
					<c:choose>
						<c:when test="${empty userData}">
							<!-- 비로그인 상태 -->
							<button class="login-button"
								onclick="location.href='http://localhost/proejct1/user/login/login_page_o.jsp'">로그인</button>
						</c:when>
						<c:otherwise>
							<!-- 로그인 상태 -->
							<button class="auth-button" id="logout-button" onclick="logout()">로그아웃</button>
							<div class="dropdown">
								<a href="#" class="auth-button dropdown-toggle"
									id="mypage-button">마이페이지</a>
								<ul class="dropdown-menu">
									<li><a
										href="http://localhost/proejct1/user/mypage/order_list.jsp">주문확인/배송조회</a></li>
									<li><a
										href="http://localhost/proejct1/user/mypage/user_edit.html">보안
											설정</a></li>
									<li><a
										href="http://localhost/proejct1/user/mypage/qa_list.jsp">나의
											Q&A조회</a></li>
								</ul>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<div class="logo-container">
			<a href="/index.jsp"> <img
				src="http://localhost/project1/common/egoporium.png" alt="로고"
				class="main-logo">
			</a>
		</div>

		<div class="nav-section">
			<div class="nav-wrapper">
				<ul class="nav-list">
					<li><a
						href="http://localhost/proejct1/index.jsp?category=best"
						class="nav-item ${param.category eq 'best' ? 'active' : ''}">베스트상품</a></li>
					<li><a href="http://localhost/proejct1/index.jsp"
						class="nav-item ${empty param.category and empty param.brand ? 'active' : ''}">전체상품</a></li>
					<li class="brand-menu"><span class="nav-item">브랜드</span>
						<ul class="brand-submenu">
							<li><a
								href="http://localhost/proejct1/index.jsp?brand=ADIDAS"
								class="${param.brand eq 'ADIDAS' ? 'active' : ''}">아디다스</a></li>
							<li><a href="http://localhost/proejct1/index.jsp?brand=NIKE"
								class="${param.brand eq 'NIKE' ? 'active' : ''}">나이키</a></li>
							<li><a
								href="http://localhost/proejct1/index.jsp?brand=NEWBALANCE"
								class="${param.brand eq 'NEWBALANCE' ? 'active' : ''}">뉴발란스</a></li>
							<li><a
								href="http://localhost/proejct1/index.jsp?brand=ASICS"
								class="${param.brand eq 'ASICS' ? 'active' : ''}">아식스</a></li>
						</ul></li>
					<li><a
						href="http://localhost/proejct1/user/main/notification.jsp"
						class="nav-item">공지사항</a></li>
				</ul>
			</div>
		</div>
	</div>
	<script>
		$(function() {

		});
		function logout() {
			// 로그아웃 처리 로직
			location.href = "http://localhost/proejct1/user/login/logout.jsp";
		}
	</script>

</body>
</html>
