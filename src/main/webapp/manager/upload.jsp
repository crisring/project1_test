<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%
boolean uploadFlag = (boolean) session.getAttribute("uploadFlag");

if (!uploadFlag) {
	File saveDir = new File("C:/dev/workspace/project1/src/main/webapp/manager/images");

	int maxSize = 1024 * 1024 * 12; // 12MB

	try {
		MultipartRequest mr = new MultipartRequest(request, saveDir.getAbsolutePath(), maxSize, "UTF-8",
		new DefaultFileRenamePolicy());

		String originName = mr.getOriginalFileName("upfile");
		String fileSysname = mr.getFilesystemName("upfile");

		// 중복 파일 체크
		File existingFile = new File(saveDir.getAbsolutePath() + "/" + fileSysname);
		if (existingFile.exists()) {
	existingFile.delete(); // 기존 파일 삭제
	out.print("기존의 " + originName + " 파일이 삭제되었습니다. 새로 업로드를 시작합니다.<br>");
		}

		File uploadFile = new File(saveDir.getAbsolutePath() + "/" + fileSysname);
		if (uploadFile.length() > maxSize) {
	uploadFile.delete(); // 파일 삭제
	out.print(originName + "은 12MB를 초과합니다. 업로드 파일의 크기내의 파일로 변환하여 업로드 해주세요.");
		} else {
	out.print("파일 업로드 성공!");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.print("파일 업로드 실패!");
	}
	session.setAttribute("uploadFlag", true);
} else {
	out.print("파일 업로드가 이미 처리되었습니다.");
}
%>
