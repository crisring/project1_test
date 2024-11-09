package manager.productlist;

import java.util.Arrays;
import java.util.Date;

public class ProductVO {

	private int productId, catalog, size, price, salePrice, stockQuantity, discount_price;
	// 상품번호, 카탈로그번호, 선택 사이즈, 가격, 할인가격, 수량, 할인가
	private int[] subimgId, standardSize; // 서브이미지 ID, 표준 신발 사이즈
	private String mainImg, description, productName, modelName, brand, saleStatus;
	// 메인이미지, 상세설명, 상품명, 모델명, 브랜드명, 판매상태

	private String[] sizes;
	private Date createAt, finishAt;

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public int getCatalog() {
		return catalog;
	}

	public void setCatalog(int catalog) {
		this.catalog = catalog;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(int salePrice) {
		this.salePrice = salePrice;
	}

	public int[] getSubimgId() {
		return subimgId;
	}

	public void setSubimgId(int[] subimgId) {
		this.subimgId = subimgId;
	}

	public String getMainImg() {
		return mainImg;
	}

	public void setMainImg(String mainImg) {
		this.mainImg = mainImg;
	}

	public int getStockQuantity() {
		return stockQuantity;
	}

	public void setStockQuantity(int stockQuantity) {
		this.stockQuantity = stockQuantity;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public String[] getSizes() {
		return sizes;
	}

	public void setSizes(String[] sizes) {
		this.sizes = sizes;
	}

	public Date getCreateAt() {
		return createAt;
	}

	public void setCreateAt(Date createAt) {
		this.createAt = createAt;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getSaleStatus() {
		return saleStatus;
	}

	public void setSaleStatus(String saleStatus) {
		this.saleStatus = saleStatus;
	}

	public int getDiscount_price() {
		return discount_price;
	}

	public void setDiscount_price(int discount_price) {
		this.discount_price = discount_price;
	}

	public Date getFinishAt() {
		return finishAt;
	}

	public void setFinishAt(Date finishAt) {
		this.finishAt = finishAt;
	}

	public int[] getStandardSize() {
		return standardSize;
	}

	public void setStandardSize(int[] standardSize) {
		this.standardSize = standardSize;
	}

	@Override
	public String toString() {
		return "ProductVO [productId=" + productId + ", catalog=" + catalog + ", size=" + size + ", price=" + price
				+ ", salePrice=" + salePrice + ", stockQuantity=" + stockQuantity + ", discount_price=" + discount_price
				+ ", subimgId=" + Arrays.toString(subimgId) + ", standardSize=" + Arrays.toString(standardSize)
				+ ", mainImg=" + mainImg + ", description=" + description + ", productName=" + productName
				+ ", modelName=" + modelName + ", brand=" + brand + ", saleStatus=" + saleStatus + ", sizes="
				+ Arrays.toString(sizes) + ", createAt=" + createAt + ", finishAt=" + finishAt + "]";
	}

}
