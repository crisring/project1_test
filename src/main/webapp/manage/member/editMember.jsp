<%@page import="user.vo.UserVO"%>
<%@page import="manage.user.AdminMemberManageDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" info=""%>

<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("userid");
    
    if (userId == null || userId.trim().isEmpty()) {
        out.println("<script>alert('회원 ID가 제공되지 않았습니다.'); history.back();</script>");
        return;
    }

    AdminMemberManageDAO ammDAO = AdminMemberManageDAO.getInstance();
    UserVO uVO = ammDAO.selectOneMember(userId);

    if (uVO == null) {
        out.println("<script>alert('회원 정보를 찾을 수 없습니다.'); history.back();</script>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 수정</title>

    <!-- 부트스트랩 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">
        $(function() {
            // 수정 버튼 클릭 시
            $("#update").click(function() {
                $.ajax({
                    url: "updateMember.jsp",
                    dataType : "json",
                    type: "POST",
                    data: {
                        memberId: $("#memberId").val(),
                        memberName: $("#memberName").val(),
                        /* zipcode: $("#zipcode").val(), */
                        address1: $("#address1").val(),
                        address2: $("#address2").val(),
                        email: $("#email").val()
                    },
                    success: function(response) {
                        if (response.status === "success") {
                            alert(response.message);
                            window.location.href = "memberList.jsp";
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다. 다시 시도해 주세요.");
                    }
                });
            });

            // 삭제 버튼 클릭
            $("#delete").click(function() {
                if(confirm("정말 삭제하시겠습니까?")) {
                    $.ajax({
                        url: "deleteMember.jsp",
                        type: "POST",
                        data: { memberId: $("#memberId").val() },
                        success: function(response) {
                            if (response.status === "success") {
                                alert(response.message);
                                window.location.href = "memberList.jsp";
                            } else {
                                alert(response.message);
                            }
                        },
                        error: function() {
                            alert("서버 오류가 발생했습니다. 다시 시도해 주세요.");
                        }
                    });
                }
            });
            
            // 목록 버튼 클릭
            $("#list").click(function() {
                window.location.href = "memberList.jsp";
            });
        });
    </script>
</head>
<body>
    <jsp:include page="/common/jsp/sidebar2.jsp"></jsp:include>

    <!-- 메인 콘텐츠 영역 -->
    <div class="main-content">
        <div class="content-box" id="sub-title">
            <h4>회원관리</h4>
        </div>

        <div class="content-box">
            <h2>회원 수정</h2>
            <table class="table">
                <colgroup>
                    <col width="40%">
                    <col width="60%">
                </colgroup>
                <tbody>
                    <tr>
                        <th>회원ID</th>
                        <td><input type="text" id="memberId" value="<%= uVO.getUserId() %>" readonly="readonly"></td>
                    </tr>
                    <tr>
                        <th>회원성명</th>
                        <td><input type="text" id="memberName" value="<%= uVO.getName() %>" /></td>
                    </tr>
                    <tr>
                        <th>회원주소</th>
                        <td>
                            <%-- <input type="text" id="zipcode" value="<%= uVO.getZipcode() %>" style="width: 80px;" /> --%>
                            <input type="text" id="address1" value="<%= uVO.getAddress1() %>" style="width: 45%;" />
                            <input type="text" id="address2" value="<%= uVO.getAddress2() %>" style="width: 45%;" />
                        </td>
                    </tr>
                    <tr>
                        <th>가입일자</th>
                        <td><input type="text" id="joindate" value="<%= uVO.getJoinDate() %>" readonly="readonly"></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><input type="text" id="email" value="<%= uVO.getEmail() %>" /></td>
                    </tr>
                </tbody>
            </table>

            <div class="btn_group" style="text-align: center">
                <%-- <button type="button" id="update" class="btn btn-primary">수정</button>
                <button type="button" id="delete" class="btn btn-danger">삭제</button> --%>
                <button type="button" id="list" class="btn btn-secondary">목록</button>
            </div>
        </div>
    </div>
</body>
</html>