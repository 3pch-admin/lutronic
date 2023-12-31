package com.ptc.wvs.util.queues;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.Locale;

import com.ptc.core.meta.common.DisplayOperationIdentifier;
import com.ptc.wvs.common.util.WVSProperties;
import wt.epm.EPMDocument;
import wt.epm.EPMAuthoringAppType;
import wt.epm.EPMDocumentType;
import wt.fc.Persistable;

@SuppressWarnings({"rawtypes","unchecked"})
public class PublishJobUtil {

  private static final String CLASS_NAME = "com.ptc.wvs.util.queues.PublishJobUtil";
  private static final String QUEUE_SET_NAME = "publish.publishqueue.priorities.filtermethod.queueSetName.";
  private static final String SEP = ".";
  private static final String DEFAULT = "0";
  private static boolean VERBOSE = false;
  private static String IBA_IDENTIFIER = "typeDisplayName";

  private static Vector queueSets = new Vector();
  private static Vector typeDisplayName = new Vector();
  private static Hashtable queueSetByType = new Hashtable();

  static {
	// Get Verbose property
//	WVSProperties wvsProperties = new WVSProperties();
	try {
		String tmp = WVSProperties.getPropertyValue(CLASS_NAME + ".verbose");
        if ( tmp!=null && tmp.equalsIgnoreCase("TRUE") ) {
			VERBOSE = true;
        }
	}
	catch (Throwable e) {
		System.out.println(CLASS_NAME  +": Error reading properties ");
		e.printStackTrace();
	}

	try {
		// Get list of Queue sets
		String p = WVSProperties.getPropertyValue("publish.publishqueue.setnames");
		if( p != null && p.trim().length() > 0 ) {
			StringTokenizer tok = new StringTokenizer(p.trim(), " ");
			while( tok.hasMoreTokens() ) {
				String t = tok.nextToken();
				boolean valid = true;
				for(int i=0; i<t.length(); i++) {
					if( Character.getType( t.charAt(i) ) != Character.UPPERCASE_LETTER ) {
						valid = false;
						break;
					}
				}
				if(valid) queueSets.add( t );
			}
		}

		// Get list of type
		String p2 = WVSProperties.getPropertyValue("publish.publishqueue.priorities.filtermethod.typeDisplayName");
		if( p2 != null && p2.trim().length() > 0 ) {
			StringTokenizer tok2 = new StringTokenizer(p2.trim(), ",");
			while( tok2.hasMoreTokens() ) {
				String t2 = tok2.nextToken();
				typeDisplayName.add( t2 );
			}
		}

	} catch (Throwable e) {
		System.out.println(CLASS_NAME + ": Error reading properties publish.publishqueue.setnames");
		e.printStackTrace();
	}


	// Cache the queue set names by CAD type
	try {
		Enumeration keys = WVSProperties.getProperties().keys();
		while( keys.hasMoreElements() ) {
			String k = (String)keys.nextElement();
			if( k.startsWith(QUEUE_SET_NAME) ) {
				String v = WVSProperties.getPropertyValue(k);
				if( v != null ) {
					v = v.toUpperCase();
					k = k.substring(QUEUE_SET_NAME.length());
					queueSetByType.put(k, v);
					}
				}
			} // while
		}
	catch (Throwable e) {
		System.out.println(CLASS_NAME + ": Error reading properties "+QUEUE_SET_NAME);
		e.printStackTrace();
		}
	}


  @SuppressWarnings("deprecation")
  public static String[] filterQueueSet (Persistable object, String cadType, Integer rqstType, Integer rqstSource, String rqstPriority, String rqstSet, String repName, String repDesc) {

	String[] ret = {rqstPriority, rqstSet, repName, repDesc};

	try {
		if (object instanceof EPMDocument) {

			EPMDocument cadDoc = (EPMDocument)object;
			EPMDocumentType epmdocType = cadDoc.getDocType();

			com.ptc.core.lwc.server.LWCNormalizedObject obj = new com.ptc.core.lwc.server.LWCNormalizedObject(object, null, Locale.US, new DisplayOperationIdentifier());
			/* Get value of IBAName soft attribute */
			obj.load(IBA_IDENTIFIER); //Logical Identifier
//			String iba_value = ((String)obj.getAsString(IBA_IDENTIFIER)).replaceAll("\\s","");
			String iba_value = (String)obj.getAsString(IBA_IDENTIFIER);

			if (VERBOSE) {
				System.out.println(CLASS_NAME + ".filterQueueSet() START");
				System.out.println(CLASS_NAME + ".filterQueueSet : Param cadDoc       : "+object );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param AuthoringApp : "+cadType );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param EPMDocType   : "+epmdocType );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param IBA          : "+iba_value );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param rqstType     : "+rqstType );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param rqstSource   : "+rqstSource );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param rqstPriority : "+rqstPriority );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param rqstSet      : "+rqstSet );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param repName      : "+repName );
				System.out.println(CLASS_NAME + ".filterQueueSet : Param repDesc      : "+repDesc );
			}

			if (cadType != null && epmdocType != null) {

				String string_type = cadType + epmdocType.toString();
				if ( iba_value != null && typeDisplayName.contains(iba_value) ) string_type = (iba_value.replaceAll("\\s","")).toUpperCase();

				String queueName = (String)queueSetByType.get(string_type + SEP + rqstType + SEP + rqstSource);

				if (VERBOSE) {
					System.out.println(CLASS_NAME + ".filterQueueSet : Authoring Application :" + string_type);
					System.out.println("*** " + queueName + " ***");
				}

				// is Entry appType.source.type exist ?
				if( queueName == null ) {
					// is Entry appType.source.0 exist ?
					queueName = (String)queueSetByType.get(string_type + SEP + rqstType + SEP + DEFAULT);
					if( queueName == null ) {
						// is Entry appType.0.type exist ?
						queueName = (String)queueSetByType.get(string_type + SEP + DEFAULT + SEP + rqstSource);
						if( queueName == null ) {
							// is Entry appType.0.0 exist ?
							queueName = (String)queueSetByType.get(string_type + SEP + DEFAULT + SEP + DEFAULT);
							}
						}
					}

				if (queueSets.contains(queueName)) {
					if (VERBOSE) System.out.println(CLASS_NAME + ".filterQueueSet : Name of Queue Set: " + queueName);
					ret[1] = queueName;
					}
				}

			}
		}
	catch (Exception e) {
		if (VERBOSE) System.out.println(CLASS_NAME + ".filterQueueSet() ERROR Impossible to get the Authoring Application");
		e.printStackTrace();
		}

	if (VERBOSE) System.out.println(CLASS_NAME + ".filterQueueSet() END");
	return ret;
  }


}
