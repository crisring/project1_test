<%@page import="java.util.Arrays"%>
<%@page import="manager.productlist.ProductVO"%>
<%@page import="java.util.List"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
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

String paramProductId = request.getParameter("productId");

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
int productId = Integer.parseInt(paramProductId);

// 할인 플래그 설정 (Y 또는 N)
String discountFlag = saleSelected.toUpperCase();

String msg = "";

AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();

try {
	apmDAO.updateProduct(productName, sellingPrice, discountPrice, discountFlag, detailDescription, mainImgName,
	brandSelect, modelName, stockQuantity, productId);

	// 삭제 후 다시 추가
	apmDAO.deleteSizes(productId);
	apmDAO.insertSize(productId, sizeInts);

	apmDAO.deleteSubimg(productId);
	apmDAO.insertSubImg(productId, subImgArr);
	msg = "제품이 성공적으로 변경되었습니다.";
} catch (Exception e) {
	e.printStackTrace();
	msg = "데이터 변경 중 오류가 발생했습니다: " + e.getMessage();
}

out.print(msg);
%>

