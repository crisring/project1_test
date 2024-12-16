<%@page import="manage.productlist.AdminProductManagementDAO"%>
<%@page import="manage.productlist.ProductVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세설명</title>
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">
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

<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

textarea {
	width: 100%;
	height: 200px;
}

#save-button {
	padding: 10px 15px;
	font-size: 16px;
	border-radius: 5px;
	border: none;
	background-color: #48c774;
	color: white;
}

button:hover {
	background-color: #45a049;
}
</style>
<!-- jQuery CDN 시작-->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		$("#save-button").click(function() {
			const description = $("#newDescription").val();
			const productId = $("#productId").val();

			$.ajax({
				type : "POST",
				url : "updateDescription.jsp",
				data : {
					productId : productId,
					description : description
				},
				success : function(response) {
					alert("저장되었습니다!");
					close();2
				},
				error : function(xhr, status, error) {
					console.error("Error occurred: ", error);
					alert("저장 중 오류가 발생했습니다. 다시 시도해 주세요.");
				}
			});
		});
	});
</script>
</head>
<body>
	<%
	int productId = Integer.parseInt(request.getParameter("productId"));

	AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
	ProductVO pVO = apmDAO.selectByProductId(productId);
	%>

	<h2>상세 설명 수정</h2>
	<form id="descriptionForm" method="post">
		<label for="newDescription">새로운 설명:</label>
		<textarea id="newDescription" name="newDescription"><%=pVO.getDescription()%></textarea>
		<input type="hidden" id="productId" value="<%=pVO.getProductId()%>" />
		<br> <br> <input type="button" id="save-button" value="저장">
	</form>
</body>
</html>
