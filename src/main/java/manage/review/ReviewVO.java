package manage.review;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class ReviewVO {
	private int reviewId, productId, rating, prdNum;
	private String productName, userId, content, reviewImg;
	private Date createAt;

}