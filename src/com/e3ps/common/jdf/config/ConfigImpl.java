/**
 * @(#) ConfigImp.java
 * Copyright (c) jerred. All rights reserverd
 * 
 *	@version 1.00
 *	@since jdk 1.4.02
 *	@createdate 2004. 3. 3.
 *	@author Cho Sung Ok, jerred@bcline.com
 *	@desc	
 */

package com.e3ps.common.jdf.config;

import java.io.InputStream;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.StringTokenizer;

import com.e3ps.common.util.CharUtil;

/**
 * <b>�� �ҽ��� <a href="http://www.javaservice.net/">JavaService Net</a>�� <br>
 * Java Development Framework(JDF) ver1.0.0�� ���ʷ� ����������� �����ϴ�.</b>
 * <p>
 * <code>ConfigImpl</code>Ŭ������ �ϳ��� Configuration�� ���� �ϳ��� ��ü�� �����ϴ� Ŭ���� �̴�.<br>
 * �� Ư�� Configuration File�� �� Ŭ������ �̿��ؼ� ����Ҽ� �ְ� �ȴ�.
 */
public class ConfigImpl implements Config
{
    private static Properties DEFAULT = null;
    private static ConfigImpl INSTANCE = null;

    /**
     * ��ü ������ �����ϱ� ���ؼ� �����ڸ� Private�� ����
     */
    private ConfigImpl()
    {
        this.initialize();
    }

    /**
     * ��ü�� �ʱ�ȭ �����ִ� Method
     * 
     * @exception <code>e3ps.config.ConfigurationException</code> Configutation
     *                File�� ã���� ���ų� �ε��Ҽ� ������ �߻�
     */
    private void initialize()
    {
        if (ConfigImpl.DEFAULT == null)
        {
            // Ŭ������ �ε��ϸ鼭 �⺻���� ������ ������ �ִ� System Properties �Ӽ��� config.fileName
            // �� �ش��ϴ� ������ �ε��Ѵ�.
            try
            {
//                WTProperties prop = WTProperties.getServerProperties();
//                String configFileName = prop.getProperty("e3ps.config.fileName");

//                File file = new File(configFileName);
//                FileInputStream fin = new FileInputStream(file);
//                ConfigImpl.DEFAULT = new Properties();
//                ConfigImpl.DEFAULT.load(fin);
//                fin.close();
                
                InputStream is = this.getClass().getResourceAsStream("/com/e3ps/eSolution.properties");
                ConfigImpl.DEFAULT = new Properties();
                ConfigImpl.DEFAULT.load(is);
                is.close();
            }
            catch (Exception e)
            {
                System.err.println(this.getClass().getName() + ":initialize() ConfigImpl - Can't initialize : "
                        + e.getMessage());
            }
        }
    }

    /**
     * Ư�� Ű�� �ش��ϴ� Configuration File�� �ʱ�ȭ �����ִ� Method
     * 
     * @return <code>e3ps.config.Configuraion</code> key�� �ش��ϴ� Configuration
     *         File�� �ʱ�ȭ�� Configuration��ü
     * @param key
     *            <code>java.lang.String</code> neocast.properties�� ������ Ư�� Ű
     */
    public synchronized static Config getInstance()
    {
        if (INSTANCE == null)
            INSTANCE = new ConfigImpl();
        return INSTANCE;
    }

    /**
     * system�� Root�� �����ϴ� Method
     * 
     * @return <code>java.lang.String</code>
     */
    public static String getRoot()
    {
        return DEFAULT.getProperty("root.path");
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>boolean</code>���·� �����ϴ� Method<br>
     * key�� ���� ���� ��� _default �� �����Ѵ�.
     * 
     * @param key
     *            <code>java.lang.String</code> ����� �ϴ� value�� key
     * @return <code>boolean</code> key�� �ش��ϴ� value
     * @exception <code>e3ps.config.ConfigurationException</code> �߸��� key�� �̿��߰ų�
     *                ������ ���� boolean�� �ƴ� ��� �߻�
     */
    public boolean getBoolean(String key)
    {
        boolean value = false;
        try
        {
            if (getString(key).equalsIgnoreCase("true"))
                value = true;
        }
        catch (Exception e)
        {
            throw new ConfigurationException(this.getClass().getName() + ":getBoolean(key) - Illegal Boolean Key : "
                    + key);
        }
        return value;
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>boolean</code>���·� �����ϴ� Method
     * 
     * @return <code>boolean</code>
     * @param key
     *            <code>java.lang.String</code>
     */
    public boolean getBoolean(String key, boolean _default)
    {
        boolean value = false;

        if (getString(key, "" + _default).equalsIgnoreCase("true"))
            value = true;

        return value;
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>int</code>���·� �����ϴ� Method
     * 
     * @param key
     *            <code>java.lang.String</code> ����� �ϴ� value�� key
     * @return <code>int</code> key�� �ش��ϴ� value
     * @exception <code>e3ps.config.ConfigurationException</code> �߸��� key�� �̿��߰ų�
     *                ������ ���� int�� �ƴ� ��� �߻�
     */
    public int getInt(String key)
    {
        int value = -1;
        try
        {
            value = Integer.parseInt(getString(key));
        }
        catch (Exception e)
        {
            throw new ConfigurationException(this.getClass().getName() + ":getInt(key) - Illegal Integer Key : " + key);
        }
        return value;
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>int</code>���·� �����ϴ� Method <br>
     * key�� ���� ���� ��� _default �� �����Ѵ�.
     * 
     * @param key
     * @param _default
     * @return
     */
    public int getInt(String key, int _default)
    {
        return Integer.parseInt(getString(key, "" + _default));
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>java.lang.String</code>���·� �����ϴ� Method
     * 
     * @param key
     *            <code>java.lang.String</code> ����� �ϴ� value�� key
     * @return <code>java.lang.String</code> key�� �ش��ϴ� value
     * @exception <code>e3ps.config.ConfigurationException</code> �߸��� key�� �̿�����
     *                ��� �߻�
     */
    public String getString(String key)
    {

        String value = DEFAULT.getProperty(key);
        if (value == null)
            throw new ConfigurationException(this.getClass().getName() + ":getString(key) - Illegal String Key : "
                    + key);
        else
            value = CharUtil.E2K(value);
        return value;
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>java.lang.String</code>���·� �����ϴ� Method
     * key�� ���� ���� ��� _default �� �����Ѵ�.
     */
    public String getString(String _key, String _default)
    {
        String value = DEFAULT.getProperty(_key);
        return value == null ? _default : CharUtil.E2K(value);
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>long</code>���·� �����ϴ� Method
     * 
     * @param key
     *            <code>java.lang.String</code> ����� �ϴ� value�� key
     * @return <code>long</code> key�� �ش��ϴ� value
     * @exception <code>e3ps.config.ConfigurationException</code> �߸��� key�� �̿��߰ų�
     *                ������ ���� double�� �ƴ� ��� �߻�
     */
    public long getLong(String key)
    {
        long value = -1;
        try
        {
            value = Long.parseLong(getString(key));
        }
        catch (Exception e)
        {
            throw new ConfigurationException(this.getClass().getName() + ":getLong(key) - Illegal String Key : " + key);
        }
        return value;
    }

    /**
     * key�� �޾Ƽ� key�� �ش��ϴ� ���� <code>long</code>���·� �����ϴ� Method <br>
     * key�� ���� ���� ��� _default �� �����Ѵ�.
     * 
     * @param key
     * @param _default
     * @return
     */
    public long getLong(String key, long _default)
    {
        return Long.parseLong(getString(key, "" + _default));
    }

    /**
     * Default �̿��� properties �� �����´�
     */
    private ResourceBundle getBundle(String add)
    {
        try
        {
            return ResourceBundle.getBundle(add, Locale.getDefault());
        }
        catch (Exception e)
        {
            System.err.println(this.getClass().getName() + ":getBundle(add) ConfigImpl - Can't initialize " + add
                    + "  : " + e.getMessage());
            return null;
        }
    }

    /**
     * Default �̿��� properties ���� ���� �о�´�
     */
    public String getStringFromOther(String add, String key)
    {
        String value = getBundle(add).getString(key);
        if (value == null)
            throw new ConfigurationException(this.getClass().getName()
                    + ":getStringFromOther(add,key) - Illegal String Key : " + key);
        else
            value = CharUtil.E2K(value);
        return value;
    }

    /**
     * �־��� key�� ���� ,�� �����Ǿ����� ��� �迭�� �����Ѵ�.
     * 
     * @param key
     * @return
     */
    public String[] getArray(String key)
    {
        String value = getString(key);
        if (value == null)
            return null;
        StringTokenizer st = new StringTokenizer(value, ";");
        String[] result = new String[st.countTokens()];

        int idx = 0;
        while (st.hasMoreElements())
        {
            result[idx++] = st.nextToken();
        }

        return result;
    }
}