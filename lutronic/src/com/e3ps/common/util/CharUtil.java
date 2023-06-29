/**
 * @(#) CharUtil.java Copyright (c) jerred. All rights reserverd
 * @version 1.00
 * @since jdk 1.4.02
 * @createdate 2004. 3. 3.
 * @author Cho Sung Ok, jerred@bcline.com
 * @desc
 */

package com.e3ps.common.util;

import java.io.UnsupportedEncodingException;

/**
 * �ѱ� CharSet ���� ����
 * <p>
 * KS_C_5601-1987 , 5601 , KSC5601 , KSC5601-1987 , KSC5601_1987, <br>
 * KSC_5601 , EUCKR , EUC_KR , EUC-KR ��� ������ �ϼ��� �ѱ� �ڵ��� <br>
 * <br>
 * WINDOW-949 , MS949 ��� ������ Ȯ�� �ϼ��� �ѱ� �ڵ� <br>
 * <br>
 * KSC5601_1992 , KSC5601-1992 , MS1361 , JOHAB ��� ������ ������ �ѱ� �ڵ� <br>
 */
public final class CharUtil {
	/**
	 * ��ü ������ �����ϱ� ���ؼ� ����Ʈ �����ڸ� Private�� ����
	 */
	private CharUtil() {
	}

	/**
	 * �⺻���� CharSet ��ȯ Method ( KSC5601 => 8859_1 )
	 * 
	 * @param korean
	 *                  <code>java.lang.String</code> KSC5601 �� CharSet String
	 * @return <code>java.lang.String</code> 8859_1 ��ȯ�� String
	 */
	public static synchronized String K2E(String korean) {
		if (korean == null) return "";
		String english = null;
		try {
			english = new String ( new String ( korean.getBytes ( "KSC5601" ) , "8859_1" ) );
		} catch (UnsupportedEncodingException e) {
			english = new String ( korean );
		}
		return english;
	}

	/**
	 * �⺻���� CharSet ��ȯ Method ( 8859_1 => KSC5601 )
	 * 
	 * @param english
	 *                  <code>java.lang.String</code> 8859_1�� CharSet String
	 * @return <code>java.lang.String</code> KSC5601 ��ȯ�� String
	 */
	public static synchronized String E2K(String english) {
		if (english == null) return "";
		String korean = null;
		try {
			korean = new String ( new String ( english.getBytes ( "8859_1" ) , "KSC5601" ) );
		} catch (UnsupportedEncodingException e) {
			korean = new String ( english );
		}
		return korean;
	}

	/**
	 * Ȯ��� ���ڵ� Method ( Some CharSet => KSC5601 )
	 * 
	 * @param str
	 *                  <code>java.lang.String</code> parameter charSet�� CharSet
	 *                  String
	 * @param charSet
	 *                  <code>java.lang.String</code> parameter str�� CharSet
	 * @return <code>java.lang.String</code> KSC5601�� ��ȯ�� String
	 */
	public static synchronized String S2K(String str, String charSet) {
		if (str == null) return "";
		try {
			boolean bConvert = false;
			if (charSet.equalsIgnoreCase ( "8859_1" )) bConvert = true;
			else if (charSet.equalsIgnoreCase ( "MS949" )) bConvert = true;
			else if (charSet.equalsIgnoreCase ( "WINDOW-949" )) bConvert = true;
			else if (charSet.equalsIgnoreCase ( "KS_C_5601-1987" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "KSC5601" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "5601" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "KSC5601-1987" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "KSC5601_1987" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "KSC_5601" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "EUC-KR" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "EUC_KR" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "EUCKR" )) bConvert = false;
			else if (charSet.equalsIgnoreCase ( "UTF8" )) bConvert = false;
			else {
				charSet = "8859_1";
				bConvert = true;
			}

			if (bConvert) return new String ( str.getBytes ( charSet ) , "KSC5601" );
			else return str;
		} catch (UnsupportedEncodingException e) {
			return str;
		}
	}

	/**
	 * �Ķ���� String ��ü�� code2�� encoding�ؼ� �����Ѵ�.
	 * 
	 * @param str
	 *                  <code>java.lang.String</code> code1�� encoding�� String ��ü
	 * @param code1
	 *                  <code>java.lang.String</code> decoding�� CharSet String �ڵ�
	 * @param cdoe2
	 *                  <code>java.lang.String</code> encoding�� CharSet String �ڵ�
	 * @return <code>java.lang.String</code> code2�� encoding�� String ��ü
	 * @see java.lang.String#getBytes(String enc)
	 */
	public static synchronized String S2S(String str, String decodeCharSet, String encodeCharSet) {
		if (str == null) return null;
		String returnData = null;
		try {
			returnData = new String ( new String ( str.getBytes ( decodeCharSet ) , encodeCharSet ) );
		} catch (UnsupportedEncodingException e) {
			returnData = new String ( str );
		}
		return returnData;
	}
}