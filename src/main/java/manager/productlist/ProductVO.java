package manager.productlist;

import java.util.Arrays;
import java.util.Date;

public class ProductVO {

	private int productId, catalog, size, price, salePrice; // 상품번호, 카탈로그번호, 선택 사이즈, 가격, 할인가격
	private int[] subimgId;
	private String imgName, stockQuantity, description, productName, modelName; // 메인이미지, 수량, 상세설명, 상품명, 모델명
	private String[] sizes, brand;
	private Date createAt;

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

	public String getImgName() {
		return imgName;
	}

	public void setImgName(String imgName) {
		this.imgName = imgName;
	}

	public String getStockQuantity() {
		return stockQuantity;
	}

	public void setStockQuantity(String stockQuantity) {
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

	public String[] getBrand() {
		return brand;
	}

	public void setBrand(String[] brand) {
		this.brand = brand;
	}

	public Date getCreateAt() {
		return createAt;
	}

	public void setCreateAt(Date createAt) {
		this.createAt = createAt;
	}

	@Override
	public String toString() {
		return "ProductVO [productId=" + productId + ", catalog=" + catalog + ", size=" + size + ", price=" + price
				+ ", salePrice=" + salePrice + ", subimgId=" + Arrays.toString(subimgId) + ", imgName=" + imgName
				+ ", stockQuantity=" + stockQuantity + ", description=" + description + ", productName=" + productName
				+ ", modelName=" + modelName + ", sizes=" + Arrays.toString(sizes) + ", brand=" + Arrays.toString(brand)
				+ ", createAt=" + createAt + "]";
	}

}
