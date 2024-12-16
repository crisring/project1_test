<%@page import="manage.notice.MangeNoticeDAO"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.SQLException"%>
<%@page language="java" contentType="application/json; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json; charset=UTF-8");

String idsParam = request.getParameter("ids");
boolean success = false;

if (idsParam != null && !idsParam.isEmpty()) {
    String[] ids = idsParam.split(",");
    MangeNoticeDAO mnDAO = MangeNoticeDAO.getInstance();
    
    try {
        success = true;
        // 각 ID에 대해 삭제 처리
        for (String id : ids) {
            int noticeId = Integer.parseInt(id);
            int result = mnDAO.deleteNotice(noticeId);
            if (result == 0) {
                success = false;
                break;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        success = false;
    }
}

// JSON 응답 생성
out.print("{\"success\":" + success + "}");
%>