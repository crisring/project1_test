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
	String recipient = request.getParameter("recipient");
	String phone = request.getParameter("phone");
	String address = request.getParameter("address");
	String address2 = request.getParameter("address2");
	String isDefault = request.getParameter("isDefault"); // 기본 배송지 여부

	// 임시 userId (실제로는 세션에서 가져와야 함)
	String userId = sessionId;

	// ShippingVO 객체 생성 및 데이터 설정
	ShippingVO sVO = new ShippingVO();
	sVO.setRecipient(recipient);
	sVO.setPhone(phone);
	sVO.setAddress(address);
	sVO.setAddress2(address2);
	sVO.setIsDefault(isDefault != null && isDefault.equals("Y") ? "Y" : "N");

	// 배송지 정보 저장
	ShippingDAO dao = new ShippingDAO();
	int result = dao.insertNewShipping(sVO, userId);

	if (result > 0) {
		// 방금 추가한 배송지가 기본 배송지로 설정된 경우, 페이지에 보여줄 정보도 함께 반환
		if ("Y".equals(sVO.getIsDefault())) {
	jsonResponse.put("success", true);
	jsonResponse.put("message", "배송지가 추가되었습니다.");
	jsonResponse.put("shippingId", sVO.getShippingId());
	jsonResponse.put("recipient", recipient);
	jsonResponse.put("phone", phone);
	jsonResponse.put("address", address);
	jsonResponse.put("address2", address2);
	jsonResponse.put("isDefault", "Y");
	jsonResponse.put("refreshPage", true); // 페이지 새로고침 여부
		} else {
	jsonResponse.put("success", true);
	jsonResponse.put("message", "배송지가 추가되었습니다.");
	jsonResponse.put("refreshPage", false);
		}
	} else {
		jsonResponse.put("success", false);
		jsonResponse.put("message", "배송지 추가에 실패했습니다.");
	}

} catch (Exception e) {
	System.out.println("배송지 추가 중 오류: " + e.getMessage());
	e.printStackTrace();
	jsonResponse.put("success", false);
	jsonResponse.put("message", "배송지 추가 중 오류가 발생했습니다: " + e.getMessage());
}

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(jsonResponse.toJSONString());
out.flush();
%>