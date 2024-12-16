package manage.dashboard;

public class DeliveryStatusVO {
	private String status; // 배송 상태 (배송전, 배송중, 배송완료 등)
	private int count; // 해당 상태의 개수

	// 기본 생성자
	public DeliveryStatusVO() {
	}

	// 생성자
	public DeliveryStatusVO(String status, int count) {
		this.status = status;
		this.count = count;
	}

	// Getter와 Setter
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	@Override
	public String toString() {
		return "DeliveryStatusVO [status=" + status + ", count=" + count + "]";
	}
}
