package com.e3ps.doc.beans;

import java.rmi.RemoteException;
import java.util.Locale;

import wt.content.ContentHelper;
import wt.content.ContentHolder;
import wt.content.ContentItem;
import wt.content.ContentRoleType;
import wt.doc.DocumentType;
import wt.doc.WTDocument;
import wt.enterprise.BasicTemplateProcessor;
import wt.fc.QueryResult;
import wt.session.SessionHelper;
import wt.util.WTException;

import com.e3ps.common.beans.VersionData;
import com.e3ps.common.iba.AttributeKey;
import com.e3ps.common.iba.IBAUtil;
import com.e3ps.common.message.Message;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.web.WebUtil;

public class DocumentData extends VersionData {
	
	public WTDocument doc;
	
	public String number;
	public String icon;
	public String linkOid;
	public String icon2;
	
	public DocumentData(WTDocument doc) throws Exception {
		super(doc);
		this.doc = doc;
		this.number = doc.getNumber();
		
		ContentItem item = null;
		QueryResult result = ContentHelper.service.getContentsByRole ((ContentHolder)doc, ContentRoleType.PRIMARY );
		while(result.hasMoreElements()) {
			item = (ContentItem) result.nextElement ();
		}
		
		if(item != null) {
			this.icon = CommonUtil.getContentIconStr(item);
		}
		
		this.icon2 = BasicTemplateProcessor.getObjectIconImgTag(doc);
	}
	
	public String getDocumentName(int index) {
		try {
			
			if(index == 2) {
				String docName1 = StringUtil.checkNull(IBAUtil.getAttrValue2(doc, "DOCUMENTNAME1"));
				String docName2 = StringUtil.checkNull(IBAUtil.getAttrValue2(doc, "DOCUMENTNAME2"));
				if(docName1.length() == 0 && docName2.length() == 0) {
					return this.name;
				}else {
					return docName2;
				}
			}else {
				return StringUtil.checkNull(IBAUtil.getAttrValue2(doc, "DOCUMENTNAME"+index));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getDescription(boolean isView) {
		String description = StringUtil.checkNull(this.doc.getDescription());
		if(isView) {
			description = WebUtil.getHtml(description);
		}
		return description;
	}
	
	public String getDocumentType() {
		String type = this.doc.getDocType().getDisplay(Message.getLocale());
		return type;
	}
	
	public String getIBAValue(String iba) {
		try {
			return IBAUtil.getAttrValue(this.doc, iba);
		} catch(Exception e) {
			return "";
		}
	}
	

	public WTDocument getDoc() {
		return doc;
	}
	

	public void setDoc(WTDocument doc) {
		this.doc = doc;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}
	
	/**
	 * 문서와 링크 eca,개발마스터 Activity
	 * @return
	 */
	public String getLinkOid() {
		return linkOid;
	}

	public void setLinkOid(String linkOid) {
		this.linkOid = linkOid;
	}

	public String getIcon2() {
		return icon2;
	}

	public void setIcon2(String icon2) {
		this.icon2 = icon2;
	}
	
	

	
}