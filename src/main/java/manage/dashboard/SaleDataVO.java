package manage.dashboard;

public class SaleDataVO {
	private String date; // 날짜 (예: "2024-04-01")
	private int amount; // 매출액

	// 생성자
	public SaleDataVO(String date, int amount) {
		this.date = date;
		this.amount = amount;
	}

	// Getter 및 Setter
	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	@Override
	public String toString() {
		return "SaleData [date=" + date + ", amount=" + amount + "]";
	}

}
