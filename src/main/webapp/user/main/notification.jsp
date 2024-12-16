<%@page import="manage.notice.NoticeVO"%>
<%@page import="user.dao.UserNoticeDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="공지사항 페이지"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
// 캐시 제어 헤더 추가
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="http://localhost/proejct1/user/css/main.css">
<!-- bootstrap CDN 시작 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
.notice_nav {
	display: flex;
	margin: 20px 0;
	border-top: 2px solid #dddddd;
	border-bottom: 2px solid #dddddd;
	padding: 5px;
	padding-left: 50px;
}

.notice_nav a {
	text-decoration: none;
	color: black;
	padding: 20px 15px;
	font-size: 14px;
	font-weight: bold;
}

.notice_nav a:hover {
	background-color: #ddd;
}

.content {
	text-align: center;
}

.table-container {
	margin: 20px auto;
	width: 90%;
	text-align: center;
}

.table_text {
	font-weight: bold;
	font-size: 25px;
	float: left;
	margin-bottom: 15px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
	font-size: 13px;
}

table td {
	border-top: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
	height: 60px;
}

table th {
	border-top: 2px solid #333;
	background-color: #f4f4f4;
	height: 60px;
}

#th_div {
	width: 10%;
}

#th_name {
	width: 70%;
}

#th_date {
	width: 10%;
}

#th_view {
	width: 10%;
}

tbody a {
	text-decoration: none;
	color: #333;
}

tbody a:hover {
	text-decoration: none;
}

.notice_pagination {
	display: flex;
	margin-top: 50px;
	justify-content: center;
	list-style: none;
	padding: 0;
}

.notice_pagination li {
	margin: 0 2px;
}

.notice_pagination li a {
	padding: 10px 15px;
	text-decoration: none;
	background-color: #eee;
	color: black;
	border-radius: 5px;
}

.notice_pagination li a:hover {
	background-color: #ddd;
}

.notice_pagination .active {
	padding: 10px 15px;
	background-color: #ddd;
	color: black;
	border-radius: 5px;
	font-weight: bold;
}

.search-box {
	margin-top: 80px;
	display: flex;
	justify-content: center;
}

.search-box input[type="text"] {
	width: 200px;
	padding: 10px;
	font-size: 16px;
}

.searchBtn {
	padding: 10px 20px;
	font-size: 16px;
	background-color: #a384dd;
	color: white;
	border: none;
	cursor: pointer;
}

.searchBtn:hover {
	background-color: #8c6ec6;
}
</style>
<script type="text/javascript">
$(function(){
	$("#keyword").keyup(function( evt){
		//엔터 쳐졌을 때
		if(evt.which == 13){
			chkNull();
		}//end if
	});//keyup
	
	$("#btn").click(function(){
		chkNull();
	});//click
	
	if(${ not empty param.keyword }){
		$("#keyword").val("${ param.keyword}");
	}//end if
	
});//ready

function chkNull(){
	var keyword=$("#keyword").val();
	if(keyword.length < 2){
		alert("한글자 이상 입력하세요!");
		return;
	}//end if
	
	$("#searchFrm").submit();
	
}//chkNull

</script>
</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<div class="content">
		<jsp:useBean id="sVO" class="user.vo.SearchVO" scope="page" />
		<jsp:setProperty property="*" name="sVO" />
		<%
		//1. 총 레코드 수 구하기
				int totalCount = 0;

				UserNoticeDAO unDAO = UserNoticeDAO.getInstance();

				try {
			totalCount = unDAO.selectTotalCount(sVO);
				} catch (SQLException se) {
			se.printStackTrace();
				} //end catch

				//2. 한 화면에 보여줄 레코드의 수
				int pageScale = 10;

				//3. 총 페이지 수
				int totalPage = (int) Math.ceil(((double) totalCount / pageScale));
				int remain = totalCount % pageScale;

				//4. 검색의 시작번호를 구하기(pagination의 번호) [1][2][3]
				String paramPage = request.getParameter("currentPage");

				int currentPage = 1;
				if (paramPage != null) {
			try {
				currentPage = Integer.parseInt(paramPage);
			} catch (NumberFormatException nfe) {
			} //end catch
				} //end if

				int startNum = currentPage * pageScale - pageScale + 1;//시작번호
				//5.끝 번호
				int endNum = startNum + pageScale - 1;

				sVO.setStartNum(startNum);
				sVO.setEndNum(endNum);
				sVO.setTotalPage(totalPage);
				sVO.setCurrentPage(currentPage);
				sVO.setTotalCount(totalCount);

				unDAO.selectAllNotice(sVO);

				List<NoticeVO> list = null;

				try {
					list = unDAO.selectAllNotice(sVO);

					String tempTitle = "";
					for (NoticeVO tempVO : list) {
						tempTitle = tempVO.getTitle();
						if (tempTitle.length() > 40) {
							tempVO.setTitle(tempTitle.substring(0, 39) + "...");
						} //end if
					} //end for
				} catch (SQLException se) {
					se.printStackTrace();
				}

				pageContext.setAttribute("totalCount", totalCount);
				pageContext.setAttribute("pageScale", pageScale);
				pageContext.setAttribute("currentPage", currentPage);
				pageContext.setAttribute("totalPage", totalPage);
				pageContext.setAttribute("list", list);
		%>
		<div class="table-container">
			<span class="table_text">공지사항</span>
			<table>
				<thead>
					<tr>
						<th id="th_div">구분</th>
						<th id="th_name">제목</th>
						<th id="th_date">작성일</th>
						<th id="th_view">조회수</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${ not empty param.keyword }">
						<c:set var="searchParam" value="&keyword=${ param.keyword }" />
					</c:if>

					<c:forEach var="nVO" items="${ list }" varStatus="i">
						<tr>
							<td><c:out value="${ nVO.category }" /></td>
							<td><a
								href="notice_detail_page.jsp?notice_id=${ nVO.noticeId }&currentPage=${ currentPage }${ searchParam }"><c:out
										value="${ nVO.title }" /></a></td>
							<td><c:out value="${ nVO.createdAt }" /></td>
							<td><c:out value="${ nVO.hits }" /></td>
						</tr>
					</c:forEach>

				</tbody>
			</table>

			<ul class="notice_pagination">
				<%
				sVO.setUrl("notification.jsp");
				%>
				<li><%=unDAO.pagination(sVO)%></li>
			</ul>
			<form action="notification.jsp" method="get" name="searchFrm"
				id="searchFrm">
				<div class="search-box">
					<input type="text" id="keyword" name="keyword"
						placeholder="공지 제목 검색"> <input type="button" id="btn"
						class="searchBtn" value="검색">
				</div>
			</form>
		</div>
	</div>

	<footer>
		<jsp:include page="/common/footer.jsp" />
	</footer>

</body>
</html>