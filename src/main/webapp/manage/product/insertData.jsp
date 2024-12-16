<%@page import="java.util.Arrays"%>
<%@page import="manage.productlist.ProductVO"%>
<%@page import="java.util.List"%>
<%@page import="manage.productlist.AdminProductManagementDAO"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"
	trimDirectiveWhitespaces="true"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<%
// 요청 파라미터 받기
String productName = request.getParameter("productName");
String sellingPriceStr = request.getParameter("sellingPrice");
String brandSelect = request.getParameter("brandSelect");
String modelName = request.getParameter("modelName");
String detailDescription = request.getParameter("detailDescription");
String discountAmountStr = request.getParameter("discountAmount");
String discountPriceStr = request.getParameter("discountPrice");
String saleSelected = request.getParameter("saleSelected");
String stockQuantityParam = request.getParameter("stockQuantity");
String selectedSizes = request.getParameter("selectedSizes");

String mainImgName = request.getParameter("mainImgName");
String additionalImgName = request.getParameter("additionalImgName");

//서브 이미지 변환
String[] subImgArr = additionalImgName.split(",");

// 사이즈 변환
String[] sizeStrings = selectedSizes.split(",");
int[] sizeInts = new int[sizeStrings.length];
for (int i = 0; i < sizeStrings.length; i++) {
	sizeInts[i] = Integer.parseInt(sizeStrings[i]); // 각 문자열을 정수로 변환
}

// 숫자 변환
int sellingPrice = Integer.parseInt(sellingPriceStr);
int discountAmount = Integer.parseInt(discountAmountStr);
int discountPrice = Integer.parseInt(discountPriceStr);
int stockQuantity = Integer.parseInt(stockQuantityParam);

// 할인 플래그 설정 (Y 또는 N)
String discountFlag = saleSelected.toUpperCase();

String msg = "";
int productId = 0;

AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();

// 데이터 중복 검사
boolean isDuplicate = apmDAO.checkProductExists(productName, brandSelect, modelName);

//중복이 없는 경우에만 제품 삽입
if (!isDuplicate) {
	try {
		apmDAO.insertProduct(productName, sellingPrice, discountPrice, discountFlag, detailDescription, mainImgName,
		brandSelect, modelName, stockQuantity);

		productId = apmDAO.selectProductId(productName, brandSelect, modelName);

		apmDAO.insertSize(productId, sizeInts);
		apmDAO.insertSubImg(productId, subImgArr);
		msg = "제품이 성공적으로 삽입되었습니다.";
	} catch (Exception e) {
		e.printStackTrace();
		msg = "데이터 삽입 중 오류가 발생했습니다: " + e.getMessage();
	}
} else {
	msg = "이미 존재하는 제품입니다.";
}

out.print(msg);
%>

