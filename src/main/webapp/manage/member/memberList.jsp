<%@page import="kr.co.sist.chipher.DataDecryption"%>
<%@page import="user.vo.UserVO"%>
<%@page import="manage.user.AdminMemberManageDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.List"%>
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
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">

<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style type="text/css">
#member-table {
	min-height: 500px;
}
</style>

<script type="text/javascript">
$(function(){
	// 페이지네이션 버튼 클릭 시
});
</script>


</head>


<body>
	<jsp:include page="/common/jsp/sidebar2.jsp"></jsp:include>

	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<form action="editMember.jsp" method="post">
			<div class="content-box" id="sub-title">
				<h4>회원관리</h4>
			</div>

			<div class="content-box" id="member-table">
				<h2>회원목록</h2>
				<table class="table">
				<jsp:useBean id="uVO" class="user.vo.UserVO" scope="page"/>
				<jsp:useBean id="amVO" class="manage.user.AdminMemberVO" scope="page"/>
				
				<% 
				AdminMemberManageDAO ammDAO = AdminMemberManageDAO.getInstance();
				
				// 총 회원 수를 구함
				int totalCount = ammDAO.selectTotalCount(amVO);
				int pageSize = 10; // 한 페이지에 보여줄 회원 수
				int currentPage = 1; // 기본값은 첫 번째 페이지
				if (request.getParameter("currentPage") != null) {
					currentPage = Integer.parseInt(request.getParameter("currentPage"));
				}

				// 페이지에 맞는 회원 데이터만 가져오기 위한 startNum과 endNum 계산
				int startNum = (currentPage - 1) * pageSize + 1;
				int endNum = startNum + pageSize - 1;

				// 검색된 회원 목록
				List<UserVO> listUser = null;
				try {
					
					// 조회할 회원 목록을 가져옴
					listUser = ammDAO.selectAllMember();
				} catch (SQLException se) {
					se.printStackTrace();
				}
				
				%>
				
				
					
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
					<%
					if (listUser != null && !listUser.isEmpty()) {
						for (UserVO tempVO : listUser) {
					%>
						<tr>
							 <td><a href="editMember.jsp?userid=<%= tempVO.getUserId() %>"><%= tempVO.getUserId() %></a></td>
							<td><%= tempVO.getName() %></td>
							<td><%= tempVO.getPhone() %></td>
							<td><%= tempVO.getAddress1() %><%= tempVO.getAddress2() %></td>
							<td><%= tempVO.getJoinDate() %></td>
							<td colspan="2"><%= tempVO.getEmail() %></td>
						</tr>
						<%
						}
					} else {
						%>
						<tr>
							<td colspan="7">등록된 회원이 없습니다.</td>
						</tr>
						<%
					}
					%>	
					</tbody>
				</table>

				<% 
    // 페이지네이션 처리
    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
%>

<div class="page-nation" style="text-align: center">
    <% if (currentPage > 1) { %>
        <a href="memberlist.jsp?currentPage=<%= currentPage - 1 %>">« 이전</a>
    <% } %>

    <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="memberlist.jsp?currentPage=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>">
            <%= i %>
        </a>
    <% } %>

    <% if (currentPage < totalPages) { %>
        <a href="memberlist.jsp?currentPage=<%= currentPage + 1 %>">다음 »</a>
    <% } %>
</div>

			</div>
		</form>
	</div>

</body>
</html>
