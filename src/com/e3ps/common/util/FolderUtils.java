package com.e3ps.common.util;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import wt.clients.folder.FolderTaskLogic;
import wt.fc.QueryResult;
import wt.folder.Folder;
import wt.folder.FolderHelper;
import wt.folder.SubFolder;

public class FolderUtils {

	private FolderUtils() {

	}

	/**
	 * 폴더 구조 트리로 가져오기
	 */
	public static JSONArray tree(Map<String, String> params) throws Exception {
		String location = params.get("location");
		Folder root = FolderHelper.service.getFolder(location, WCUtil.getWTContainerRef());

		JSONArray list = new JSONArray();
		JSONObject rootNode = new JSONObject();
		rootNode.put("oid", root.getPersistInfo().getObjectIdentifier().getStringValue());
		rootNode.put("location", root.getFolderPath());
		rootNode.put("name", root.getName());

		JSONArray children = new JSONArray();
		Enumeration result = FolderTaskLogic.getSubFolders(root);
		while (result.hasMoreElements()) {
			Folder child = (Folder) result.nextElement();
			JSONObject node = new JSONObject();
			node.put("oid", child.getPersistInfo().getObjectIdentifier().getStringValue());
			node.put("location", child.getFolderPath());
			node.put("name", child.getName());
			tree(child, node);
			children.add(node);
		}
		rootNode.put("children", children);
		list.add(rootNode);
		return list;
	}

	/**
	 * 폴더 구조 트리로 가져오기 재귀함수
	 */
	private static void tree(Folder parent, JSONObject parentNode) throws Exception {
		JSONArray children = new JSONArray();
		Enumeration result = FolderTaskLogic.getSubFolders(parent);
		while (result.hasMoreElements()) {
			Folder child = (Folder) result.nextElement();
			JSONObject node = new JSONObject();
			node.put("oid", child.getPersistInfo().getObjectIdentifier().getStringValue());
			node.put("location", child.getFolderPath());
			node.put("name", child.getName());
			tree(child, node);
			children.add(node);
		}
		parentNode.put("children", children);
	}

	/**
	 * 자식 폴더 모두 가져오기
	 */
	public static ArrayList<Folder> recurciveFolder(Folder parent, ArrayList<Folder> list) throws Exception {
		QueryResult result = FolderHelper.service.findSubFolders(parent);
		while (result.hasMoreElements()) {
			SubFolder sub = (SubFolder) result.nextElement();
			recurciveFolder(sub, list);
			list.add(sub);
		}
		return list;
	}

	/**
	 * 모든 폴더 가져오기
	 */
	public static ArrayList<Folder> loadAllFolder(String location, String container) throws Exception {
		Folder root = null;
		if ("product".equalsIgnoreCase(container)) {
			root = FolderHelper.service.getFolder(location, WCUtil.getWTContainerRef());
		} else if ("document".equalsIgnoreCase(container)) {
			root = FolderHelper.service.getFolder(location, WCUtil.getWTContainerRef());
		} else if ("library".equalsIgnoreCase(container)) {
			root = FolderTaskLogic.getFolder(location, CommonUtil.getWTLibraryContainer());
		}

		ArrayList<Folder> list = new ArrayList<>();

		Enumeration result = FolderTaskLogic.getSubFolders(root);
		while (result.hasMoreElements()) {
			Folder folder = (Folder) result.nextElement();
			list.add(folder);
			recurciveFolder(folder, list);
		}
		return list;
	}

	/**
	 * 하위 폴더 리스트 가져오기
	 */
	public static ArrayList<Folder> getSubFolders(Folder root, ArrayList<Folder> folders) throws Exception {
		QueryResult result = FolderHelper.service.findSubFolders(root);
		while (result.hasMoreElements()) {
			SubFolder sub = (SubFolder) result.nextElement();
			folders.add(sub);
			getSubFolders(sub, folders);
		}
		return folders;
	}
}