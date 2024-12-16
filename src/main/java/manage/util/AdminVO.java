package manage.util;

public class AdminVO {
	private String admin_id, password;

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public AdminVO() {
		super();
	}

	public AdminVO(String admin_id, String password) {
		super();
		this.admin_id = admin_id;
		this.password = password;
	}

}
