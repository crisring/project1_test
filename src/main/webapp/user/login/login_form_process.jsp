
<%@page import="user.vo.UserVO"%>
<%@page import="user.dao.UserAuthenticationDAO"%>
<%@page import="kr.co.sist.chipher.DataDecryption"%>
<%@page import="java.sql.SQLException"%>

<%@page import="kr.co.sist.chipher.DataEncryption"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/post_chk.jsp"%>
<jsp:useBean id="uVO" class="user.vo.UserVO" scope="page" />
<jsp:setProperty name="uVO" property="*" />

<%
String id = request.getParameter("id");
String password = request.getParameter("password");

boolean loginFlag = false;
UserAuthenticationDAO uDAO = UserAuthenticationDAO.getInstance();
UserVO user = null;

if (id != null && password != null) {
	try {
		// 비밀번호 해싱 처리
		String hashedPassword = DataEncryption.messageDigest("SHA-1", password);

		// 로그인 시도
		user = uDAO.selectUserForLogin(id, hashedPassword);

		// 로그인 성공 여부 확인
		loginFlag = user != null;

		if (loginFlag) {
	// 로그인 성공 시, 암호화된 Address2 복호화
	DataDecryption dd = new DataDecryption("abcdef0123456789");
	if (user.getAddress2() != null) {
		user.setAddress2(dd.decrypt(user.getAddress2()));
	} //end if

	// 세션에 사용자 정보 저장 (비밀번호 제외)
	user.setPassword(""); // 보안을 위해 비밀번호 제거
	session.setAttribute("userData", user);
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
<title>로그인 페이지</title>
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
</head>
<body>
	<div id="wrap">
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
                window.location.href = "login_page_o.jsp";
            }//end if
        });
    } else {
        window.location.href = "../../index.jsp";
    }//end else
});//ready
</script>
	</div>
</body>
</html>
