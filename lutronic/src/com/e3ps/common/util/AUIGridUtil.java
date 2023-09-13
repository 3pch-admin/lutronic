package com.e3ps.common.util;

import com.ptc.wvs.server.util.PublishUtils;

import wt.content.ApplicationData;
import wt.content.ContentHelper;
import wt.content.ContentHolder;
import wt.content.ContentRoleType;
import wt.fc.QueryResult;
import wt.representation.Representable;
import wt.representation.Representation;
import wt.util.FileUtil;

public class AUIGridUtil {

	private AUIGridUtil() {

	}

	/**
	 * 그리드에서 주 첨부파일 표시
	 */
	public static String primary(ContentHolder holder) throws Exception {
		String template = "";
		QueryResult result = ContentHelper.service.getContentsByRole(holder, ContentRoleType.PRIMARY);
		if (result.hasMoreElements()) {
			ApplicationData data = (ApplicationData) result.nextElement();
			String ext = FileUtil.getExtension(data.getFileName());
			String icon = getFileIcon(ext);
			String url = "/Windchill/eSolution/content/download?oid="
					+ data.getPersistInfo().getObjectIdentifier().getStringValue();
			template += "<a href=" + url + "><img src=" + icon + "></a>";
		}
		return template;
	}

	/**
	 * 그리드에서 첨부파일 표시
	 */
	public static String secondary(ContentHolder holder) throws Exception {
		String template = "";
		QueryResult result = ContentHelper.service.getContentsByRole(holder, ContentRoleType.SECONDARY);
		while (result.hasMoreElements()) {
			ApplicationData data = (ApplicationData) result.nextElement();
			String ext = FileUtil.getExtension(data.getFileName());
			String icon = getFileIcon(ext);
			String url = "/Windchill/eSolution/content/download?oid="
					+ data.getPersistInfo().getObjectIdentifier().getStringValue();
			template += "<a href=" + url + "><img src=" + icon + "></a>&nbsp;";
		}
		return template;
	}

	/**
	 * 그리드에서 STEP 표시
	 */
	public static String step(ContentHolder holder) throws Exception {
		String template = "";
		Representable representable = PublishUtils.findRepresentable(holder);
		Representation representation = PublishUtils.getRepresentation(representable, true, null, false);
		if (representation != null) {
			QueryResult result = ContentHelper.service.getContentsByRole(representation, ContentRoleType.SECONDARY);
			while (result.hasMoreElements()) {
				ApplicationData data = (ApplicationData) result.nextElement();
				String ext = FileUtil.getExtension(data.getFileName());
				String icon = getFileIcon(ext);
				String url = "/Windchill/eSolution/content/download?oid="
						+ data.getPersistInfo().getObjectIdentifier().getStringValue();
				template += "<a href=" + url + "><img src=" + icon + "></a>&nbsp;";
			}
		}
		return template;
	}

	/**
	 * 그리드에서 PDF 표시
	 */
	public static String pdf(ContentHolder holder) throws Exception {
		String template = "";
		Representable representable = PublishUtils.findRepresentable(holder);
		Representation representation = PublishUtils.getRepresentation(representable, true, null, false);
		if (representation != null) {
			QueryResult result = ContentHelper.service.getContentsByRole(representation,
					ContentRoleType.ADDITIONAL_FILES);
			while (result.hasMoreElements()) {
				ApplicationData data = (ApplicationData) result.nextElement();
				String ext = FileUtil.getExtension(data.getFileName());
				String icon = getFileIcon(ext);
				String url = "/Windchill/eSolution/content/download?oid="
						+ data.getPersistInfo().getObjectIdentifier().getStringValue();
				template += "<a href=" + url + "><img src=" + icon + "></a>&nbsp;";
			}
		}
		return template;
	}

	/**
	 * 그리드에서 DFX 표시
	 */
	public static String dxf(ContentHolder holder) throws Exception {
		String template = "";
		Representable representable = PublishUtils.findRepresentable(holder);
		Representation representation = PublishUtils.getRepresentation(representable, true, null, false);
		if (representation != null) {
			QueryResult result = ContentHelper.service.getContentsByRole(representation, ContentRoleType.SECONDARY);
			while (result.hasMoreElements()) {
				ApplicationData data = (ApplicationData) result.nextElement();
				String ext = FileUtil.getExtension(data.getFileName());
				String icon = getFileIcon(ext);
				String url = "/Windchill/eSolution/content/download?oid="
						+ data.getPersistInfo().getObjectIdentifier().getStringValue();
				template += "<a href=" + url + "><img src=" + icon + "></a>&nbsp;";
			}
		}
		return template;
	}

	/**
	 * 첨부파일 다운로드 표기할 아이콘
	 */
	private static String getFileIcon(String ext) throws Exception {
		String icon = "/Windchill/extcore/images/fileicon/file_generic.gif";
		if (ext.equalsIgnoreCase("pdf")) {
			icon = "/Windchill/extcore/images/fileicon/file_pdf.gif";
		} else if (ext.equalsIgnoreCase("xls") || ext.equalsIgnoreCase("xlsx") || ext.equalsIgnoreCase("csv")) {
			icon = "/Windchill/extcore/images/fileicon/file_excel.gif";
		} else if (ext.equalsIgnoreCase("ppt") || ext.equalsIgnoreCase("pptx")) {
			icon = "/Windchill/extcore/images/fileicon/file_ppoint.gif";
		} else if (ext.equalsIgnoreCase("doc") || ext.equalsIgnoreCase("docs")) {
			icon = "/Windchill/extcore/images/fileicon/file_msword.gif";
		} else if (ext.equalsIgnoreCase("html") || ext.equalsIgnoreCase("htm")) {
			icon = "/Windchill/extcore/images/fileicon/file_html.gif";
		} else if (ext.equalsIgnoreCase("gif")) {
			icon = "/Windchill/extcore/images/fileicon/file_gif.gif";
		} else if (ext.equalsIgnoreCase("png")) {
			icon = "/Windchill/extcore/images/fileicon/file_png.gif";
		} else if (ext.equalsIgnoreCase("bmp")) {
			icon = "/Windchill/extcore/images/fileicon/file_bmp.gif";
		} else if (ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("jpeg")) {
			icon = "/Windchill/extcore/images/fileicon/file_jpg.jpg";
		} else if (ext.equalsIgnoreCase("zip") || ext.equalsIgnoreCase("rar") || ext.equalsIgnoreCase("jar")) {
			icon = "/Windchill/extcore/images/fileicon/file_zip.gif";
		} else if (ext.equalsIgnoreCase("tar") || ext.equalsIgnoreCase("gz")) {
			icon = "/Windchill/extcore/images/fileicon/file_zip.gif";
		} else if (ext.equalsIgnoreCase("exe")) {
			icon = "/Windchill/extcore/images/fileicon/file_exe.gif";
		} else if (ext.equalsIgnoreCase("dwg")) {
			icon = "/Windchill/extcore/images/fileicon/file_dwg.gif";
		} else if (ext.equalsIgnoreCase("xml")) {
			icon = "/Windchill/extcore/images/fileicon/file_xml.png";
		}
		return icon;
	}
}