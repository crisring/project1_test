package manager.productlist;

public class ShippingVO {

	private int shippingId, orderId; // 배송번호, 주문번호
	private String recipient, phone, address, memo; // 수령인, 전화번호, 주소, 배송메모

	public int getShippingId() {
		return shippingId;
	}

	public void setShippingId(int shippingId) {
		this.shippingId = shippingId;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public String getRecipient() {
		return recipient;
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	@Override
	public String toString() {
		return "ShippingVO [shippingId=" + shippingId + ", orderId=" + orderId + ", recipient=" + recipient + ", phone="
				+ phone + ", address=" + address + ", memo=" + memo + "]";
	}

}
