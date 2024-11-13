package manager.util;

/**
 * 현재페이지, 시작번호, 끝 번호, 검색컬럼, 검색값, 검색URL
 */
public class AdminSearchVO {
	private int startNum, endNum, currentPage, totalPage, totalCount, pageScale;
	// 시작번호, 끝번호, 현재 페이지 번호, 총 페이지 수, 페이지스캐일

	private String brand, productName, saleStatus, startDate, endDate, dateType, sortBy;
	// 검색할 브랜드, 상품명, 판매상태, 기간, 조회기간, 정렬기준

	private String url, OrderStatus; // url, 주문상태

	public int getStartNum() {
		return startNum;
	}

	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}

	public int getEndNum() {
		return endNum;
	}

	public void setEndNum(int endNum) {
		this.endNum = endNum;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getSaleStatus() {
		return saleStatus;
	}

	public void setSaleStatus(String saleStatus) {
		this.saleStatus = saleStatus;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getDateType() {
		return dateType;
	}

	public void setDateType(String dateType) {
		this.dateType = dateType;
	}

	public String getSortBy() {
		return sortBy;
	}

	public void setSortBy(String sortBy) {
		this.sortBy = sortBy;
	}

	public String getOrderStatus() {
		return OrderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		OrderStatus = orderStatus;
	}

	public int getPageScale() {
		return pageScale;
	}

	public void setPageScale(int pageScale) {
		this.pageScale = pageScale;
	}

	@Override
	public String toString() {
		return "SearchVO [startNum=" + startNum + ", endNum=" + endNum + ", currentPage=" + currentPage + ", totalPage="
				+ totalPage + ", totalCount=" + totalCount + ", pageScale=" + pageScale + ", brand=" + brand
				+ ", productName=" + productName + ", saleStatus=" + saleStatus + ", startDate=" + startDate
				+ ", endDate=" + endDate + ", dateType=" + dateType + ", sortBy=" + sortBy + ", url=" + url
				+ ", OrderStatus=" + OrderStatus + "]";
	}

}
