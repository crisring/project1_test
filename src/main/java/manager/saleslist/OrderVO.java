package manager.saleslist;

import java.util.Date;

public class OrderVO {

	private String userId, orderStatus, orderName, shippingStatus; // 유저Id, 주문상태, 주문명, 배송상태
	private int orderId, addressId; // 주문번호, ?
	private float totalAmount; // 총 주문수
	private Date orderDate; // 주문일자

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getAddressId() {
		return addressId;
	}

	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}

	public float getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(float totalAmount) {
		this.totalAmount = totalAmount;
	}

	public Date getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	public String getShippingStatus() {
		return shippingStatus;
	}

	public void setShippingStatus(String shippingStatus) {
		this.shippingStatus = shippingStatus;
	}

	@Override
	public String toString() {
		return "OrderVO [userId=" + userId + ", orderStatus=" + orderStatus + ", orderName=" + orderName
				+ ", shippingStatus=" + shippingStatus + ", orderId=" + orderId + ", addressId=" + addressId
				+ ", totalAmount=" + totalAmount + ", orderDate=" + orderDate + "]";
	}

}
