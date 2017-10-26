package org.maojf.searchusers;

public class UserInfo{ 

	public UserInfo() {

	}

	public UserInfo(long id, String loginname, String password, String name) {
		this.id = id;
		this.loginname = loginname;
		this.password = password;
		this.name = name;

	}

	public long getId() {
		return id;
	}

	public String getLoginname() {
		return loginname;
	}

	public String getPassword() {
		return password;
	}

	public String getName() {
		return name;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setLoginname(String loginname) {
		this.loginname = loginname;

	}

	public void setPassword(String password) {
		this.password = password;

	}

	public void setName(String name) {
		this.name = name;

	}
	
 

	private long id;
	private String loginname;
	private String password; // º”√‹
	private String name;

}
