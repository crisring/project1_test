<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
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

<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style type="text/css">
#member-table {
	min-height: 500px;
}
</style>

<script type="text/javascript">
	
</script>


</head>


<body>
	<jsp:include page="sidebar.jsp"></jsp:include>

	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<form action="editMember.jsp" method="post">
			<div class="content-box" id="sub-title">
				<h4>회원관리</h4>
			</div>

			<div class="content-box" id="member-table">
				<h2>회원목록</h2>
				<table class="table">
					<colgroup>
						<col width="11%">
						<col width="11%">
						<col width="17%">
						<col width="24%">
						<col width="15%">
						<col width="11%">
						<col width="15%">
					</colgroup>

					<thead class="table-light" align="center">
						<tr>
							<th>회원ID</th>
							<th>회원성명</th>
							<th>전화번호</th>
							<th>주소</th>
							<th>가입일자</th>
							<th colspan="2">이메일</th>
						</tr>
					</thead>

					<tbody align="center">
						<tr>

							<td><a href="editMember.jsp?memberID=admin">admin</a></td>
							<td>회원성명</td>
							<td>전화번호</td>
							<td>주소</td>
							<td>가입일자</td>
							<td colspan="2">이메일</td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>

</body>
</html>