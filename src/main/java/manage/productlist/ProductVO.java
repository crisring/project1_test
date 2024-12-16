package manage.productlist;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class ProductVO {

	private int productId, size, price, salePrice, stockQuantity, discount_price;
	// 상품번호, 카탈로그번호, 선택 사이즈, 가격, 할인가격, 수량, 할인가
	private int[] standardSize; // 표준 신발 사이즈
	private String mainImg, description, productName, modelName, brand, saleStatus, discountFlag;
	// 메인이미지, 상세설명, 상품명, 모델명, 브랜드명, 판매상태

	private List<String> SubImgList; // 서브이미지

	private String[] sizes; // 사이즈
	private Date createAt, finishAt;

}
