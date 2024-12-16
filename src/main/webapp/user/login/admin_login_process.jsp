<%@page import="manage.util.AdminVO"%>
<%@page import="manage.util.AdminAuthenticationDAO"%>
<%@page import="java.sql.SQLException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/post_chk.jsp"%>

<%
String id = request.getParameter("id");
String password = request.getParameter("password");

boolean loginFlag = false;
AdminAuthenticationDAO aDAO = AdminAuthenticationDAO.getInstance();
AdminVO admin = null;

System.out.println(id);
System.out.println(password);

if (id != null && password != null) {
	try {
		//로그인 시도
		admin = aDAO.selectAdminId(id, password);

		loginFlag = admin != null;

		if (loginFlag) {
	// 세션에 사용자 정보 저장
	session.setAttribute("adminId", admin);
		} //end if
	} catch (SQLException se) {
		se.printStackTrace();
	} //end catch
} //end if

pageContext.setAttribute("loginFlag", loginFlag);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap CDN 시작 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<style type="text/css">
</style>
<script type="text/javascript">
$(function(){
	const loginFlag = <%=loginFlag%>;

    if (!loginFlag) {
        Swal.fire({
            icon: 'error',
            title: '로그인 실패!',
            text: '아이디/비밀번호를 확인해주세요.',
            confirmButtonText: '확인'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "admin_login.jsp";
            }//end if
        });
    } else {
        window.location.href = "test.jsp";
    }//end else
});//ready
</script>
</head>
<body>
	<div id="wrap"></div>
</body>
</html>