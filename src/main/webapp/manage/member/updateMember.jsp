<!-- updateMember.jsp -->
<%@page import="user.vo.UserVO"%>
<%@page import="manage.user.AdminMemberManageDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 요청 파라미터 받기
    String userId = request.getParameter("memberId");
    String memberName = request.getParameter("memberName");
    String phone = request.getParameter("phone");  // 추가
    String zipcode = request.getParameter("zipcode");
    String address1 = request.getParameter("address1");
    String address2 = request.getParameter("address2");
    String email = request.getParameter("email");

    AdminMemberManageDAO dao = AdminMemberManageDAO.getInstance();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 유저 정보 조회
        UserVO user = dao.selectOneMember(userId);
        if (user != null) {
            // 회원 정보 수정
            user.setName(memberName);
            user.setPhone(phone);  // 추가
            user.setZipcode(zipcode);
            user.setAddress1(address1);
            user.setAddress2(address2);
            user.setEmail(email);

            // 회원 정보 업데이트
            int result = dao.updateMember(user);
            if (result > 0) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "회원 정보가 정상적으로 수정되었습니다.");
            } else {
                jsonResponse.put("status", "failure");
                jsonResponse.put("message", "회원 정보 수정에 실패했습니다. 다시 시도해 주세요.");
            }
        } else {
            jsonResponse.put("status", "failure");
            jsonResponse.put("message", "회원 정보를 찾을 수 없습니다.");
        }
    } catch (SQLException e) {
        jsonResponse.put("status", "failure");
        jsonResponse.put("message", "데이터베이스 오류가 발생했습니다. 다시 시도해 주세요.");
        e.printStackTrace();
    }

    // JSON 응답 출력
    out.print(jsonResponse.toJSONString());
%>