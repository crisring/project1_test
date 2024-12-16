package user.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class UserVO {
	private int question_id;
	private String userId, password, name, email, phone, gender, address1, address2, birth, securityQuestion_id,
			securityAnswer, joinDate, user_status_flag, zipcode;

}
