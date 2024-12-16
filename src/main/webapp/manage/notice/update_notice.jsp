<%@page import="manage.notice.NoticeVO"%>
<%@page import="manage.notice.MangeNoticeDAO"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json; charset=UTF-8");

boolean updateStatus = false;
boolean result = true;

// JSON 객체 생성
JSONObject jsonResponse = new JSONObject();

String noticeIdStr = request.getParameter("noticeId");
String category = request.getParameter("category");
String title = request.getParameter("title");
String content = request.getParameter("content");

try {
    if (noticeIdStr != null && !noticeIdStr.isEmpty()) {
        int noticeId = Integer.parseInt(noticeIdStr);

        // NoticeVO 객체 생성 및 업데이트할 데이터 설정
        NoticeVO nVO = new NoticeVO();
        nVO.setNotice_id(noticeId);
        nVO.setCategory_id(Integer.parseInt(category));
        nVO.setTitle(title);
        nVO.setContent(content);

        // DAO 인스턴스 생성 후 업데이트 수행
        MangeNoticeDAO noticeDAO = MangeNoticeDAO.getInstance();
        int updateCount = noticeDAO.updateOneNotice(nVO);

        // 업데이트 성공 여부 확인
        updateStatus = (updateCount > 0);
    } else {
        result = false;
    }

    // JSON 객체에 데이터 추가
    jsonResponse.put("result", result);
    jsonResponse.put("updateStatus", updateStatus);

} catch (Exception e) {
    // 에러 처리
    jsonResponse.put("result", false);
    jsonResponse.put("error", e.getMessage());
}

// JSON 응답 출력
out.print(jsonResponse.toJSONString());
%>
