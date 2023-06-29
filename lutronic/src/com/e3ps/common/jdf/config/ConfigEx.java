/*
 * @(#) ConfigBox.java  Create on 2006. 6. 15.
 * Copyright (c) e3ps. All rights reserverd
 */
package com.e3ps.common.jdf.config;

import java.io.InputStream;
import java.util.Hashtable;
import java.util.Properties;

import com.e3ps.common.jdf.log.Logger;
import com.e3ps.common.jdf.message.MessageException;

/**
 * MessageImpl�� Ȯ��� ����� ConfigEx�� �Ű� Property ���� �پ��ϰ� ����Ѵ�.
 * @author Choi Seunghwan, skyprda@e3ps.com
 * @version 1.00, 2006. 6. 15.
 * @since 1.4
 */
public class ConfigEx
{
    private static Hashtable INSTANCE = new Hashtable();

    private ConfigEx()
    {}

    /**
     * Ư�� Ű�� �ش��ϴ� Configuration File�� �ʱ�ȭ �����ִ� Method
     */
    public synchronized static ConfigExImpl getInstance(String _propertiesFileName)
    {
        if (INSTANCE == null) INSTANCE = new Hashtable();

        if (!INSTANCE.contains(_propertiesFileName))
        {
            new ConfigEx().initialize(_propertiesFileName);
        }

        return (ConfigExImpl) INSTANCE.get(_propertiesFileName);
    }

    /**
     * Message Definition File�� ã���� ���ų� load�� �� ������ �߻��Ѵ�.
     */
    private synchronized void initialize(String _fileName) throws MessageException
    {
        try
        {
            InputStream is = this.getClass().getResourceAsStream("/com/e3ps/"+_fileName+".properties");
            
            Properties props = new Properties();
            props.load(is);

            Config instance = new ConfigExImpl(props);
            INSTANCE.put(_fileName, instance);
        }
        catch (Exception e)
        {
            Logger.err.println("e3ps.common.jdf.config.ConfigEx:initialize() - Can't initialize ConfigEx : " + _fileName + "  error : "
                    + e.getMessage());
            throw new MessageException("e3ps.common.jdf.config.ConfigEx:initialize() - Can't initialize ConfigEx : " + _fileName + "  error : "
                    + e.getMessage());
        }
    }
}
