package com.e3ps.common.util;

//import sun.security.action.GetPropertyAction;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.ServletRequest;

import wt.content.ApplicationData;
import wt.content.ContentHolder;
import wt.content.ContentItem;
import wt.content.URLData;
import wt.doc.WTDocument;
import wt.fc.IconDelegate;
import wt.fc.IconDelegateFactory;
import wt.fc.ObjectIdentifier;
import wt.fc.Persistable;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.fc.ReferenceFactory;
import wt.fc.WTObject;
import wt.fc.WTReference;
import wt.httpgw.URLFactory;
import wt.iba.value.IBAHolder;
import wt.method.RemoteMethodServer;
import wt.org.OrganizationServicesHelper;
import wt.org.WTPrincipal;
import wt.org.WTUser;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.session.SessionHelper;
import wt.util.IconSelector;
import wt.util.WTContext;
import wt.util.WTException;
import wt.util.WTProperties;
import wt.vc.Iterated;
import wt.vc.VersionForeignKey;
import wt.vc.VersionReference;

import com.e3ps.common.iba.AttributeKey;
import com.e3ps.common.iba.IBAAttributes;
import com.e3ps.common.iba.IBAUtil;
import com.e3ps.common.jdf.config.Config;
import com.e3ps.common.jdf.config.ConfigEx;
import com.e3ps.common.jdf.config.ConfigExImpl;
import com.e3ps.common.jdf.config.ConfigImpl;
import com.e3ps.common.message.Message;
import com.e3ps.groupware.workprocess.AsmApproval;


public class CommonUtil  implements wt.method.RemoteAccess, java.io.Serializable {

	private static ReferenceFactory rf = null;
	static final boolean SERVER = wt.method.RemoteMethodServer.ServerFlag;
	
	public static String getObjectIconImageTag(WTObject object) throws Exception{

		if(!SERVER) {
			Class argTypes[] = new Class[]{WTObject.class};
			Object args[] = new Object[]{object};
			try {
				return (String)wt.method.RemoteMethodServer.getDefault().invoke(
						"getObjectIconImageTag",
						"com.e3ps.common.util.CommonUtil",
						null,
						argTypes,
						args);
			}
			catch(RemoteException e) {
				e.printStackTrace();
				throw new WTException(e);
			}
			catch(InvocationTargetException e) {
				e.printStackTrace();
				throw new WTException(e);
			}
			catch(Exception e){
				e.printStackTrace();
				throw new WTException(e);
			}
		}

		return wt.enterprise.BasicTemplateProcessor.getObjectIconImgTag(object);
	}

	public static String getContentIconStr(ContentItem item) throws WTException {
		URLFactory urlFac = new URLFactory ();
		String iconStr = "";
		String fileiconpath = "jsp/portal/images/icon/fileicon/";
		String filename = "";
		if (item instanceof URLData) {
			iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "link.gif";
		} else if (item instanceof ApplicationData) {
			ApplicationData data = (ApplicationData) item;

			String extStr = "";
			String tempFileName = data.getFileName ();
			filename = tempFileName;
			int dot = tempFileName.lastIndexOf ( "." );
			if (dot != -1) extStr = tempFileName.substring ( dot + 1 ); // includes
																									// "."

			if (extStr.equalsIgnoreCase ( "cc" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "ed.gif";
			else if (extStr.equalsIgnoreCase ( "exe" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "exe.gif";
			else if (extStr.equalsIgnoreCase ( "doc" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "doc.gif";
			else if (extStr.equalsIgnoreCase ( "ppt" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "ppt.gif";
			else if (extStr.equalsIgnoreCase ( "xls" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "xls.gif";
			else if (extStr.equalsIgnoreCase ( "csv" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "xls.gif";
			else if (extStr.equalsIgnoreCase ( "txt" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "notepad.gif";
			else if (extStr.equalsIgnoreCase ( "mpp" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "mpp.gif";
			else if (extStr.equalsIgnoreCase ( "pdf" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "pdf.gif";
			else if (extStr.equalsIgnoreCase ( "tif" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "tif.gif";
			else if (extStr.equalsIgnoreCase ( "gif" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "gif.gif";
			else if (extStr.equalsIgnoreCase ( "jpg" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "jpg.gif";
			else if (extStr.equalsIgnoreCase ( "ed" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "ed.gif";
			else if (extStr.equalsIgnoreCase ( "zip" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "zip.gif";
			else if (extStr.equalsIgnoreCase ( "tar" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "zip.gif";
			else if (extStr.equalsIgnoreCase ( "rar" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "zip.gif";
			else if (extStr.equalsIgnoreCase ( "jar" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "zip.gif";
			else if (extStr.equalsIgnoreCase ( "igs" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "pcb" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "asc" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "dwg" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "dxf" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "sch" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "epmall.gif";
			else if (extStr.equalsIgnoreCase ( "html" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "htm.gif";
			else if (extStr.equalsIgnoreCase ( "htm" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "htm.gif";
			else if (extStr.equalsIgnoreCase ( "docx" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "doc.gif";
			else if (extStr.equalsIgnoreCase ( "pptx" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "ppt.gif";
			else if (extStr.equalsIgnoreCase ( "xlsx" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "xls.gif";
			else if (extStr.equalsIgnoreCase ( "bmp" )) iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "bmp.gif";
			else iconStr = urlFac.getBaseURL ().getPath () + fileiconpath + "generic.gif";
		}
        else
        {
            return null;
        }
		iconStr = "<img src='" + iconStr + "' border=0 alt='" + filename + "'>";
		return iconStr;
	}
	
	/**
	 * 占쏙옙체 占쏙옙占쏙옙 占쏙옙占쏙옙占싹깍옙 占쏙옙占쌔쇽옙 占쏙옙占쏙옙트 占쏙옙占쌘몌옙 Private占쏙옙 占쏙옙占쏙옙
	 */
	private CommonUtil() {
	}

	/**
	 * 占식띰옙占쏙옙庫占� 占쏙옙占쏙옙 Persistable 占쏙옙체占쏙옙 OID 占쏙옙 占쏙옙占쏙옙占싹댐옙 Method <br>
	 */
	public static String getOIDString(Persistable per) {
		if (per == null) return null;
		return PersistenceHelper.getObjectIdentifier ( per ).getStringValue ();
	}
	
	public static String getFullOIDString(Persistable persistable) {
        try {
            if (rf == null) rf = new ReferenceFactory();
            return rf.getReferenceString(rf.getReference(persistable));
        } catch (Exception e) {
            return null;
        }
    }
	
	public static long getOIDLongValue(String oid) {
		String tempoid = oid;
		tempoid = tempoid.substring ( tempoid.lastIndexOf ( ":" ) + 1 );
		return Long.parseLong ( tempoid );
	}

	public static long getOIDLongValue(Persistable per) {
		String tempoid = getOIDString ( per );
		tempoid = tempoid.substring ( tempoid.lastIndexOf ( ":" ) + 1 );
		return Long.parseLong ( tempoid );
	}
	
	  /**
     * VR oid占쏙옙 占쏙옙占쏙옙占싼댐옙.
     * 
     * @param oid
     * @return
     */
    public static String getVROID(String oid)
    {
        Object obj = getObject(oid);
        if (obj == null)
            return null;
        return getVROID((Persistable) getObject(oid));
    }

    private static String getVRString(WTReference wtRef) throws WTException
    {
        VersionReference verRef = (VersionReference) wtRef;
        VersionForeignKey verForeignKey = (VersionForeignKey) verRef.getKey();
        return "VR:" + verRef.getKey().getClassname() + ":" + verForeignKey.getBranchId();
    }
    
    /**
     * VR oid占쏙옙 占쏙옙占쏙옙占싼댐옙.
     * 
     * @param persistable
     * @return
     */
    public static String getVROID(Persistable persistable)
    {

    	if (persistable == null)
            return null;
        try
        {
            if (rf == null)
                rf = new ReferenceFactory();
            return rf.getReferenceString(VersionReference.newVersionReference((Iterated)persistable));
        }
        catch (Exception e)
        {
        	e.printStackTrace();
            return null;
        }
    }
	/**
	 * OID占쏙옙 占쏙옙체占쏙옙 찾占쏙옙 占쏙옙占쏙옙 占싼댐옙 <br>
	 */
	public static Persistable getObject(String oid) {
		if (oid == null) return null;
		try {
			if (rf == null) rf = new ReferenceFactory ();
			return rf.getReference ( oid ).getObject ();
		} catch (Exception e) {
			//e.printStackTrace();
			return null;
		}
	}

	/**
	 * 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙 Admin 占쌓룹에 占쏙옙占쏙옙 占실억옙 占쌍댐옙占쏙옙占쏙옙 占싯아놂옙占쏙옙 <br>
	 */
	public static boolean isCheckPW() throws Exception {
		ConfigExImpl conf = ConfigEx.getInstance("eSolution");
		boolean enableCheckPW = conf.getBoolean("e3ps.checkpw.enable", true);
		
		return enableCheckPW;
	}
	
	/**
	 * 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙 Admin 占쌓룹에 占쏙옙占쏙옙 占실억옙 占쌍댐옙占쏙옙占쏙옙 占싯아놂옙占쏙옙 <br>
	 */
	public static boolean isAdmin() throws Exception {
		return isMember ( "Administrators" );
	}

	/**
	 * 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙 Parameter占쏙옙 占싼억옙占� group 占쏙옙占쏙옙 占쌓룹에 占쏙옙占쏙옙 占실억옙 占쌍댐옙占쏙옙占쏙옙 占싯아놂옙占쏙옙 <br>
	 */
	public static boolean isMember(String group) throws Exception {
		WTUser user = (wt.org.WTUser) SessionHelper.manager.getPrincipal();
		return isMember(group, user);
	}
    
    public static boolean isMember(String group, WTUser user) throws Exception {
        Enumeration en = user.parentGroupNames ();
        while (en.hasMoreElements ()) {
            String st = (String) en.nextElement ();
            if (st.equals ( group )) return true;
        }
        return false;
    }

	/**
	 * 占시쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙求占� 占쌈쏙옙 占쏙옙占썰리占쏙옙 占쏙옙占� 占쏙옙罐占� 占쏙옙占쏙옙占싹댐옙 Method <br>
	 * 
	 * @return <code>java.lang.String</code> 占시쏙옙占쏙옙 占쌈쏙옙 占쏙옙占썰리
	 */
	public static String getTempDir() {
		//GetPropertyAction getpropertyaction = new GetPropertyAction ( "java.io.tmpdir" );
		//String tmpdir = (String) AccessController.doPrivileged ( getpropertyaction );
		String tmpdir = System.getProperty("java.io.tmpdir");
		return tmpdir;
	}
    
    public static String getWCTempDir(){
        String tmpdir = "";
        try {
            WTProperties properties = WTProperties.getLocalProperties();
            tmpdir = properties.getProperty("wt.temp");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return tmpdir;
    }

	/**
	 * @param :
	 *                  String
	 * @return : String
	 * @author : PTC KOREA Yang Kyu
	 * @since : 2004.01
	 */
	public static WTUser findUserID(String userID) throws WTException {
		WTUser wtuser = (WTUser) OrganizationServicesHelper.manager.getAuthenticatedUser ( userID );
		return wtuser;
	}

	public static String getUserIDFromSession() throws WTException {
		return ( (WTUser) SessionHelper.manager.getPrincipal () ).getName ();
	}
	
	public static String getUserNameFromOid( String ida2a2 ) throws WTException {
		String oid = "wt.org.WTUser:" +ida2a2;
		WTUser wtuser = (WTUser)getObject(oid);
		
		if ( wtuser != null ){
			return findUserName(wtuser.getName());
		} else {
			
			return "";
		}
		
	}

	public static String getUsernameFromSession() throws WTException {
		return ( (WTUser) SessionHelper.manager.getPrincipal () )
				.getFullName ();
	}

	
	public static String findUserName(String userID) throws WTException {
		String userName = "";
		WTUser wtuser = (WTUser) OrganizationServicesHelper.manager.getAuthenticatedUser ( userID );
		userName = wtuser.getFullName ();
		return userName;
	}

	public static TreeMap getUsers() throws WTException {
		QuerySpec query = new QuerySpec ( WTUser.class );
		query.appendWhere ( new SearchCondition ( WTUser.class , "disabled" , "FALSE" ) );
		
		QueryResult result = PersistenceHelper.manager.find ( query );

		TreeMap userTree = new TreeMap ();
		while (result.hasMoreElements ()) {
			wt.org.WTUser wtuser = (wt.org.WTUser) result.nextElement ();
			userTree.put ( wtuser.getFullName () , wtuser.getName () );
		}
		return userTree;
	}

	public static Vector removeDuplicate(Vector duplicateVector)
			throws Exception {
		HashSet hashset = new HashSet ();
		Vector vec1 = new Vector ();

		for (int i = 0; i < duplicateVector.size (); i++) {
			Persistable persistable = (Persistable) duplicateVector.get ( i );
			ObjectIdentifier objectidentifier = PersistenceHelper	.getObjectIdentifier ( persistable );

			if (!hashset.contains ( objectidentifier )) {
				hashset.add ( objectidentifier );
				vec1.addElement ( persistable );
			}
		}
		return vec1;
	}

	public static String getIconResource(WTObject wtobject) throws Exception {
		String s = null;
		IconDelegateFactory icondelegatefactory = new IconDelegateFactory ();
		IconDelegate icondelegate = icondelegatefactory.getIconDelegate ( wtobject );
		IconSelector iconselector;
		for (iconselector = icondelegate.getStandardIconSelector (); !iconselector.isResourceKey (); iconselector = icondelegate.getStandardIconSelector ())
			icondelegate = icondelegate.resolveSelector ( iconselector );

		s = "/" + iconselector.getIconKey ();
		return s;
	}

    public static void printlnParamValues(ServletRequest request){
        
        Enumeration en = request.getParameterNames();
        Vector enVec = new Vector();
        while(en.hasMoreElements()){
            enVec.addElement(en.nextElement());
        }
        Collections.sort(enVec, ORDER);
        en = enVec.elements();
        while(en.hasMoreElements()){ 
            Object obj = en.nextElement();
            //System.out.println( obj.toString() +"    -    "+request.getParameter(obj.toString()) );
        }
    }
    
    public static WTUser getWTUserFromID(String userID){
        if ( userID == null ){
            return null;
        } 
        try {
            return (WTUser) OrganizationServicesHelper.manager.getPrincipal(userID, OrganizationServicesHelper.manager.getDefaultDirectoryService());
        } catch (WTException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static final Comparator ORDER = new Comparator() {
          public int compare(Object obj1, Object obj2) {
              int ret = ( obj1.toString() ).compareTo( obj2.toString() );
              return ret;
          }
    };

    public static String ViewState(String state) {
        if( "占쌜억옙 占쏙옙".equals(state) || "INWORK".equals(state) || "APPROVING".equals(state) || "占쏙옙占쏙옙占쏙옙".equals(state) || "CHANGE".equals(state) ) {
            return "INWORK";
        }else if( "DEVRELEASED".equals(state) ) {
            return "DEVRELEASED";
        }else if( "APPROVED".equals(state) || "占쏙옙占싸듸옙".equals(state) || "RELEASED".equals(state) ) {
            return "APPROVED";
        }else {
            return state;
        }
    }
    
    public static String zeroFill( int value, int size ) throws WTException {
        String convert="";
        int maxSize = (int)Math.pow(10,size); //size=5 ??maxSize=100,000
        if(value >= maxSize) { 
            convert = Integer.toString(maxSize-1);
        }
        else {
            int seqnoSize = (Integer.toString(value)).length();
            for(int i=0;i<(size-seqnoSize);i++){
                convert +="0";
            }
            convert = convert + value;
        }// end if
        return convert;
    }
	
	
    public static boolean isUSLocale(){
    	try{
	    	Locale userLocale = SessionHelper.manager.getLocale();
	        if(userLocale == null) {
	            userLocale = WTContext.getContext().getLocale();
	        }
	        if(userLocale.equals(Locale.US)) {
	        	return true;
	        }
    	}catch(Exception ex){
    		ex.printStackTrace();
    	}
    	return false;
    }

	public static String getBundleString(String string, String string2,
			Locale locale) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public static void setUser(final String id, final String pw)
    {
        RemoteMethodServer.getDefault().setUserName(id);
        RemoteMethodServer.getDefault().setPassword(pw);
    }
	
	public static String getWTuserFullName(WTPrincipal principal){
    	WTUser user = (WTUser)principal;
    	return getWTuserFullName(user);
    }
	/*--------------------------------- Intellian ADD-------------------------------------------*/
	public static boolean isVendor(){
		boolean isVendor = false;
		try{
//			Config conf = ConfigImpl.getInstance();
//			String vendorName = conf.getString("vendor.context.name");
//			String orgName = SessionHelper.getPrincipal().getOrganization().getName();
//			
//			if(vendorName.equals(orgName)){
//				isVendor = true;
//			}
			WTUser user = (wt.org.WTUser) SessionHelper.manager.getPrincipal();
			Config conf = ConfigImpl.getInstance();
			String vendorGroup = conf.getString("vendor.group.name");
			return isMember(vendorGroup, user);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return isVendor;
	}
	
	/**
	 * 팀장/PM 그룹
	 * @return
	 * @throws Exception
	 */
	public static boolean isPMGroup() throws Exception{
		
		WTUser user = (wt.org.WTUser) SessionHelper.manager.getPrincipal();
		return isMember("PM_Group", user);
		
	}
	
	/**
	 * 임원 그룹
	 * @return
	 * @throws Exception
	 */
	public static boolean isExecutive() throws Exception{
		
		WTUser user = (wt.org.WTUser) SessionHelper.manager.getPrincipal();
		return isMember("Executive_Group", user);
		
	}
	
	/**
	 * 인텔리안 
	 * @param contentHolder
	 * @return
	 */
	public static boolean isDocDownload(ContentHolder contentHolder){
		
		boolean isDown = true;
		try{
			if(contentHolder instanceof WTDocument){
				WTDocument  doc = (WTDocument)contentHolder;
				
				if(doc.getCreatorName().equals(SessionHelper.getPrincipal().getName()) || isAdmin()) {
					return isDown;
				}
				
				String grade = IBAUtil.getAttrValue2((WTDocument)contentHolder, AttributeKey.DocKey.IBA_GRADE);
				if(grade.length()>0){ //G001(임원),G002(팀장/PM),G003(모두)
					
					boolean isPMGroup = isPMGroup();
					boolean isExecutive = isExecutive();
					
					if(grade.equals("G001")){
						if(!isExecutive){
							isDown = false;
						}
					}else if(grade.equals("G002")){
						if(!(isPMGroup || isExecutive)){
							isDown = false;
						}
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return isDown;
		
	}
	
	public static String getOrgName() {
		ConfigExImpl conf = ConfigEx.getInstance("eSolution");
		String org = conf.getString("web.context.name");
		return org;
	}
	
	/**** 루트로닉 ***/
	
	public static String getApprovalDisplay(String approvalType){
		
		if(approvalType == null || approvalType.length()==0){
			return Message.get("기본결재");
		}
		
		if(approvalType.equals(AttributeKey.CommonKey.COMMON_BATCH)){
			
			approvalType = Message.get("일괄결재");
		}else{
			approvalType = Message.get("기본결재");
		}
		
		return approvalType;
		
	}
	
	/**
	 * 일괄 결재 유무 체크
	 * @param doc
	 * @return
	 */
	public static boolean isBatch(WTDocument doc){
		boolean isBatch = false;
		try{
			String approvalTypeCode = StringUtil.checkNull(IBAUtil.getAttrValue((IBAHolder)doc, AttributeKey.IBAKey.IBA_APPROVALTYPE));
			isBatch = approvalTypeCode.equals(AttributeKey.CommonKey.COMMON_BATCH);
		}catch(Exception e){
			e.printStackTrace();
		}
		return isBatch;
	}
	
	// 파일복사
	public static File copyFile(File source, File dest) {
		long startTime = System.currentTimeMillis();

		int count = 0;
		long totalSize = 0;
		byte[] b = new byte[128];

		FileInputStream in = null;
		FileOutputStream out = null;
		// 성능향상을 위한 버퍼 스트림 사용
		BufferedInputStream bin = null;
		BufferedOutputStream bout = null;
		try {
			in = new FileInputStream(source);
			bin = new BufferedInputStream(in);

			out = new FileOutputStream(dest);
			bout = new BufferedOutputStream(out);
			while ((count = bin.read(b)) != -1) {
				bout.write(b, 0, count);
				totalSize += count;
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		} finally {// 스트림 close 필수
			try {
				if (bout != null) {
					bout.close();
				}
				if (out != null) {
					out.close();
				}
				if (bin != null) {
					bin.close();
				}
				if (in != null) {
					in.close();
				}

			} catch (IOException r) {
				// TODO: handle exception
				//System.out.println("close 도중 에러 발생.");
			}
		}

		return dest;
	}
	
	/**
	 * 일괄 다운로드 사유
	 * @return
	 */
	public static Map<String, String> getBatchDescribe(){
		TreeMap<String, String> map = new TreeMap<String, String>();
		
		map.put("1", "공정 검토용");
		map.put("2", "제작 발주용");
		map.put("3", "수입 검사용");
		map.put("4", "인증용");
		map.put("5", "ROHS 확인용");
		map.put("6", "기타");
		return map;
	}
	
	/**
	 * 일괄 다운로드 리스트
	 * @return
	 */
	public static List<Map<String,String>> getBatchDescribeList(){
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		
		Map<String,String> map= new HashMap<String, String>();//getStatusMap();
		map = getBatchDescribe();
		
		Iterator it = map.keySet().iterator();
		
		while(it.hasNext()){
			Map<String,String> mapStatus = new HashMap<String, String>();
			String code =(String) it.next();
			mapStatus.put("code", code);
			mapStatus.put("name", map.get(code));
			
			list.add(mapStatus);
		}
		
		return list;
	}
}