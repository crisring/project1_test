package manager.productlist;

import java.util.Date;

public class SalesListVO {

	private ProductVO pVO;

	private String orderStatus, shippingStatus, userId;
	private Date orderDate;

	public ProductVO getpVO() {
		return pVO;
	}

	public void setpVO(ProductVO pVO) {
		this.pVO = pVO;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getShippingStatus() {
		return shippingStatus;
	}

	public void setShippingStatus(String shippingStatus) {
		this.shippingStatus = shippingStatus;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	@Override
	public String toString() {
		return "SalesListVO [pVO=" + pVO + ", orderStatus=" + orderStatus + ", shippingStatus=" + shippingStatus
				+ ", userId=" + userId + ", orderDate=" + orderDate + "]";
	}

}
