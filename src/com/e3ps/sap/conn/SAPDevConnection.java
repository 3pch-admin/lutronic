package com.e3ps.sap.conn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import com.e3ps.common.jdf.config.Config;
import com.e3ps.common.jdf.config.ConfigImpl;

import wt.util.WTProperties;

public class SAPDevConnection {

	protected static String properties_filename = "sap_dev.properties";
	protected static Properties sapProps = null;

	public static String DESTINATION_NAME = "";
	public static boolean isSAPSend = true;

	static {
		setSAPInit();
	}

	public static void setSAPInit() {

		Config conf = ConfigImpl.getInstance();
		System.out.println("erp_dev.destination = " + conf.getString("erp_dev.destination"));
		System.out.println("erp.send = " + conf.getString("erp.send"));
		DESTINATION_NAME = conf.getString("erp_dev.destination");

//		isSAPSend = conf.getString("erp.send").equals("true") ? true : false;

		System.out.println("==== setSAPInit ====");
		System.out.println("DESTINATION_NAME =" + DESTINATION_NAME);
		System.out.println("isSAPSend =" + isSAPSend);
		if (isSAPSend) {
			getLoginProperties();
			createDestinationDataFile(DESTINATION_NAME, sapProps);
		}

	}

	public static Properties getLoginProperties() {
		if (sapProps == null) {
			sapProps = new Properties();
			try {
				String wt_home = WTProperties.getServerProperties().getProperty("wt.home");

				StringBuffer sb = new StringBuffer();
				sb.append(wt_home);
				sb.append(File.separator);
				sb.append("codebase");
				sb.append(File.separator);
				sb.append("com");
				sb.append(File.separator);
				sb.append("e3ps");
				sb.append(File.separator);
				sb.append(properties_filename);
				sapProps.load(new FileInputStream(sb.toString()));
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

		return sapProps;
	}

	public static void createDestinationDataFile(String destinationName, Properties connectProperties) {

		File destCfg = new File(destinationName + ".jcoDestination");
		System.out.println("destC1fg.isFile() =" + destCfg.isFile());
		if (!destCfg.isFile()) {
			return;
		}

		System.out.println("destCfg.isFile() =" + destCfg.isFile());
		System.out.println(destCfg.getAbsolutePath());
		try {
			FileOutputStream fos = new FileOutputStream(destCfg, false);
			connectProperties.store(fos, "for tests only !");
			System.out.println("connectProperties =" + connectProperties);
			System.out.println("fos =" + fos.getFD().toString());
			fos.close();
		} catch (Exception e) {
			throw new RuntimeException("Unable to create the destination files", e);
		}
	}

	public static void main(String[] args) {
		try {
			// ET_OUTPUT
			// System.out.println("TEST");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
