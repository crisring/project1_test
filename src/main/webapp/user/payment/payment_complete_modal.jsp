<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/session_chk.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 완료</title>
    <style>
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .modal {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .modal-header {
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: white;
            background-color: #4CAF50;
        }
        .modal-body {
            padding: 20px;
            text-align: center;
        }
        .modal-body p {
            margin-bottom: 20px;
            color: #333;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: white;
            color: #333;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
<div class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            결제 완료
        </div>
        <div class="modal-body">
            <p>주문이 정상적으로 처리되었습니다.</p>
            <p>주문번호: <%= request.getParameter("orderId") %></p>
            <button class="btn btn-primary" onclick="location.href='http://localhost/proejct1/user/mypage/order_list.jsp'">
                주문내역 확인하기
            </button>
            <button class="btn btn-secondary" onclick="closeModal()">
                확인
            </button>
        </div>
    </div>
</div>

<script>
    function closeModal() {
        const modalOverlay = document.querySelector('.modal-overlay');
        modalOverlay.style.display = 'none';
        location.href = "/index.jsp";
    }
</script>
</body>
</html>