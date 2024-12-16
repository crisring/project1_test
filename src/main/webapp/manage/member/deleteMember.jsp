<%@page import="manage.user.AdminMemberManageDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = request.getParameter("memberId");
    AdminMemberManageDAO dao = AdminMemberManageDAO.getInstance();
    JSONObject jsonResponse = new JSONObject();

    try {
        int result = dao.deleteMember(userId);
        if (result > 0) {
            jsonResponse.put("status", "success");
            jsonResponse.put("message", "회원이 정상적으로 삭제되었습니다.");
        } else {
            jsonResponse.put("status", "failure");
            jsonResponse.put("message", "회원 삭제에 실패했습니다. 다시 시도해 주세요.");
        }
    } catch (SQLException e) {
        jsonResponse.put("status", "failure");
        jsonResponse.put("message", "데이터베이스 오류가 발생했습니다. 다시 시도해 주세요.");
        e.printStackTrace();
    }

    out.print(jsonResponse.toJSONString());
%>