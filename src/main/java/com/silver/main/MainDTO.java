package com.silver.main;

import org.apache.ibatis.type.Alias;

@Alias("test")
public class MainDTO {
	private String mem_id;

	public String getMem_id() {
		return mem_id;
	}

	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	
	
}
