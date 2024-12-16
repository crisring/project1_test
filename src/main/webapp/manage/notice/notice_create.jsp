<%@page import="manage.util.AdminVO"%>
<%@page import="user.vo.UserVO"%>
<%@page import="manage.notice.MangeNoticeDAO"%>
<%@page import="manage.notice.NoticeVO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
request.setCharacterEncoding("UTF-8");

//JSON 응답을 위한 설정
response.setContentType("application/json; charset=UTF-8");
// UserVO에서 admin_id만 가져오기
String adminId = "";
if(session != null && session.getAttribute("userData") != null) {
    AdminVO userData = (AdminVO)session.getAttribute("userData");
    adminId = userData.getAdmin_id();  // VO의 getter 메서드 사용
} else {
    response.sendRedirect("login.jsp");
    return;
}
    String category = request.getParameter("category");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    

    // NoticeVO 객체 생성
    NoticeVO notice = new NoticeVO();
    notice.setCategory_id(Integer.parseInt(category));  // 카테고리 ID 설정
    notice.setTitle(title);  // 제목 설정
    notice.setContent(content);  // 내용 설정
    notice.setAdmin_Id(adminId);

    // 데이터베이스에 공지사항 추가
    MangeNoticeDAO mnDAO = MangeNoticeDAO.getInstance();
    int result = mnDAO.insertNotice(notice);  // 공지사항 등록 메서드 호출

    // JSON 응답 생성
    JSONObject jsonResponse = new JSONObject();
    if (result > 0) {
        jsonResponse.put("success", true);  // 등록 성공
    } else {
        jsonResponse.put("success", false);  // 등록 실패
    }

    // JSON 응답 보내기
    response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write(jsonResponse.toString());  // JSON 응답 전송
%>
