package com.iyouxun.data.beans;

/** 联系人实体 */
public class Contact {
	/** 联系人名字 */
	private String name = "";

	/** 排序字母 */
	private String sortKey = "";

	/** 电话号码 */
	private String number = "";

	/** 被选中 */
	private boolean isSelected;

	public void setNumber(String number) {
		this.number = number;
	}

	public String getNumber() {
		return number;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSortKey() {
		return sortKey;
	}

	public void setSortKey(String sortKey) {
		this.sortKey = sortKey;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}

		if (obj instanceof Contact) {
			Contact tc = (Contact) obj;

			if (tc.getName().equals(this.name) && tc.getNumber().equals(this.number)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}

}