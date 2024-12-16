<%@page import="user.dao.ShippingDAO"%>
<%@page import="user.vo.ShippingVO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	request.setCharacterEncoding("UTF-8");

	// 파라미터 받기
	int shippingId = Integer.parseInt(request.getParameter("shippingId"));
	String recipient = request.getParameter("recipient");
	String phone = request.getParameter("phone");
	String address = request.getParameter("address");
	String address2 = request.getParameter("address2");

	// ShippingVO 객체 생성 및 데이터 설정
	ShippingVO sVO = new ShippingVO();
	sVO.setShippingId(shippingId);
	sVO.setRecipient(recipient);
	sVO.setPhone(phone);
	sVO.setAddress(address);
	sVO.setAddress2(address2);

	// 배송지 정보 수정
	ShippingDAO dao = new ShippingDAO();
	int result = dao.updateShipping(sVO);

	if (result > 0) {
		jsonResponse.put("success", true);
		jsonResponse.put("message", "배송지가 수정되었습니다.");
	} else {
		jsonResponse.put("success", false);
		jsonResponse.put("message", "배송지 수정에 실패했습니다.");
	}

} catch (Exception e) {
	jsonResponse.put("success", false);
	jsonResponse.put("message", "배송지 수정 중 오류가 발생했습니다: " + e.getMessage());
	e.printStackTrace();
}

response.setContentType("application/json");
out.print(jsonResponse.toJSONString());
%>