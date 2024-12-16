package manage.saleslist;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class OrderVO {

	private String userId, orderStatus, orderName, shippingStatus, orderFlag; // 유저Id, 주문상태, 주문명, 배송상태
	private int orderId, totalAmount; // 주문번호, 총 주문 가격
	private Date orderDate; // 주문일자

}
