
<%@page import="manage.review.ReviewVO"%>
<%@page import="manage.review.AdminReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>리뷰 관리 팝업</title>

<!-- Bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>
<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style>
body, html {
	margin: 0;
	padding: 0;
	height: 100%;
	font-family: Arial, sans-serif;
}

.header {
	width: 100%;
	background-color: #28a745;
	color: white;
	padding: 15px;
	font-weight: bold;
	text-align: center;
}

.content {
	padding: 20px;
	width: 100%;
}

.titleTable {
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
}

th, td {
	text-align: left;
	padding: 10px;
	border: 1px solid #ddd;
	white-space: nowrap;
}

.reviewContainer {
	display: flex;
	border: 1px solid #ddd;
	margin-top: 20px;
	padding: 20px;
	min-height: 150px;
	max-height: 300px;
}

.reviewImage {
	flex: 0 0 40%;
	margin-right: 20px;
	max-width: 40%;
}

.reviewText {
	flex: 1; /* 전체 공간을 차지하도록 수정 */
}

img {
	max-width: 100%;
	max-height: 100%;
	height: auto;
	width: auto;
	object-fit: contain;
}
</style>
<script type="text/javascript">
	$(function() {
		$("#delete").click(function() {
			if (confirm("삭제하시겠습니까?")) {
				$("#submitFrm").submit();
			}//end if
		});

		$("#close").click(function() {
			self.close();
		});//close btn
	}); //ready
</script>
</head>

<body>
	<div class="header">리뷰 상세보기</div>

	<div class="content">
		<%
		AdminReviewDAO arDAO = AdminReviewDAO.getInstance();
		ReviewVO rVO = null;
		int reviewId = Integer.parseInt(request.getParameter("reviewId"));

		try {
			rVO = arDAO.selectOneReview(reviewId);
		} catch (NumberFormatException ne) {
			ne.printStackTrace();
			out.println("<p>유효하지 않은 리뷰 ID입니다.</p>");
		}

		if (rVO == null) {
			out.println("<p>해당 ID로 리뷰를 찾을 수 없습니다.</p>");
		} else {
		%>
		<table class="titleTable">
			<tr>

				<th>작성자</th>
				<td><%=rVO.getUserId()%></td>
				<th>리뷰 등록일</th>

				<td><fmt:formatDate value="<%=rVO.getCreateAt()%>"
						pattern="yyyy-MM-dd" /></td>
				<th>평점 <img
					src="http://localhost/proejct1/common/img/img7.png">
				</th>
				<td><c:out value="<%=rVO.getRating()%>"></c:out></td>

			</tr>

			<tr>
				<th>상품명</th>
				<td colspan="5"><%=rVO.getProductName()%></td>
			</tr>
		</table>

		<div class="reviewContainer">
			<% if(rVO.getReviewImg() != null && !rVO.getReviewImg().isEmpty()) { %>
			    <!-- 이미지 영역 -->
			    <div class="reviewImage">
			        <img src="http://localhost/proejct1/common/review_images/<%=rVO.getReviewImg()%>" alt="리뷰 이미지">
			    </div>
			<% } %>

			<!-- 리뷰 내용 -->
			<div class="reviewText">
				<p><%=rVO.getContent()%></p>
			</div>
		</div>

		<form action="admin_review_process.jsp" method="post" name="submitFrm"
			id="submitFrm">
			<input type="hidden" name="reviewId" value="<%=reviewId%>">
			<div style="text-align: center; margin-top: 20px;">
				<input type="button" class="btn btn-danger btn-sm" value="삭제"
					id="delete" name="delete"> <input type="button"
					class="btn btn-light btn-sm" value="닫기" id="close" name="close">
			</div>
		</form>

		<%
		}
		%>
		<img src="${rVO.getReviewImg()}">

	</div>
	<c:out value="${rVO.createAt }" />
</body>
</html>
