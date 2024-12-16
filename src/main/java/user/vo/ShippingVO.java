package user.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class ShippingVO {

	private int shippingId, orderId;
	private String recipient, phone, address, address2, memo, status;

	private String isDefault;
}
