<%@page import="manager.util.BoardUtil"%>
<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@page import="manager.productlist.OrderVO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="manager.productlist.ProductVO"%>
<%@page import="java.util.List"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8UTF-8">
<title>Insert title here</title>
<link rel="shortcut icon"
	href="http://192.168.10.219/jsp_prj/common/images/favicon.ico" />
<link rel="stylesheet" type="text/css"
	href="http://192.168.10.219/jsp_prj/common/css/main_20240911.css">
<!-- bootstrap CDN 시작-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>
<!-- bootstrap CDN 끝-->

<style type="text/css">
</style>
<!-- jQuery CDN 시작-->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {

	}); // document.ready
</script>
</head>
<body>
	<div id="wrap">

		<%-- 		<!-- 상품 테이블 -->
		<table class="table">
			<thead class="table-light">
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
					<td><%=pVO.getProductId()%></td>
					<td><%=pVO.getProductName()%></td>
					<td><%=pVO.getModelName()%></td>
					<td><%=pVO.getBrand()%></td>
					<td><input type="button" id="explanation" value="상세설명"></td>
					<td><%=pVO.getSaleStatus()%></td>
					<td><%=pVO.getStockQuantity()%></td>
					<td><%=pVO.getPrice()%></td>
					<td><%=pVO.getDiscount_price()%></td>
					<td><%=pVO.getCreateAt()%></td>
					<td><%=pVO.getFinishAt()%></td>
				</tr>
			</tbody>
		</table>

		<br> <br> --%>


		<jsp:useBean id="sVO" class="manager.util.SearchVO" scope="page" />
		<jsp:setProperty property="*" name="sVO" />

		<%
		AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();

		// 총 레코드 수 구하기
		int totalCount = 0;

		try {
			totalCount = apmDAO.selectTotalCount(sVO);
		} catch (SQLException se) {
			se.printStackTrace();
		}

		// 페이지 당 레코드 수 및 페이지 수 계산
		final int pageScale = 10;

		int totalPage = (int) Math.ceil((double) totalCount / pageScale);

		// 현재 페이지와 시작, 끝 번호 계산
		String paramPage = request.getParameter("currentPage");
		int currentPage = 1;
		try {
			if (paramPage != null) {
				currentPage = Integer.parseInt(paramPage);
			}
		} catch (NumberFormatException e) {
			currentPage = 1; // 기본값 설정
		}
		int startNum = currentPage * pageScale - pageScale + 1;
		int endNum = startNum + pageScale - 1; //끝 번호

		// SearchVO에 값 설정
		sVO.setCurrentPage(currentPage);
		sVO.setStartNum(startNum);
		sVO.setEndNum(endNum);
		sVO.setTotalPage(totalPage);
		sVO.setTotalCount(totalCount);
		sVO.setUrl("test_jdbc.jsp"); // 페이지 URL 설정

		List<ProductVO> listBoard = null;
		try {
			listBoard = apmDAO.selectBoard(sVO); // 시작번호와 끝 번호를 사용해 데이터 조회

			// 상품명이 20자를 초과할 경우 잘라내기
			String tempName = "";
			for (ProductVO tempVO : listBoard) {
				tempName = tempVO.getProductName();
				if (tempName != null && tempName.length() > 20) {
			tempVO.setProductName(tempName.substring(0, 19) + "...");
				}
			}

		} catch (SQLException se) {
			se.printStackTrace();
		}

		// 페이지 정보를 JSP에 전달
		pageContext.setAttribute("totalCount", totalCount);
		pageContext.setAttribute("pageScale", pageScale);
		pageContext.setAttribute("totalPage", totalPage);
		pageContext.setAttribute("currentPage", currentPage);
		request.setAttribute("productList", listBoard);
		%>
		<!-- 상품 테이블 -->
		<table class="table">
			<thead class="table-light">
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
				<c:forEach var="item" items="${productList}">
					<tr>
						<td><input type="checkbox" class="chk"></td>
						<td><input type="button" value="수정" class="edit"></td>
						<td>${item.productId}</td>
						<td>${item.productName}</td>
						<td>${item.modelName}</td>
						<td>${item.brand}</td>
						<td><input type="button" value="상세설명"></td>
						<td>${item.saleStatus}</td>
						<td>${item.stockQuantity}</td>
						<td>${item.price}</td>
						<td>${item.discount_price}</td>
						<td>${item.createAt}</td>
						<td>${item.finishAt}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- 페이지네이션 -->
		<div id="pagination" style="text-align: center">
			<%=new BoardUtil().pagination(sVO)%>
		</div>
</body>
</html>