/* bcwti
 *
 * Copyright (c) 2008 Parametric Technology Corporation (PTC). All Rights
 * Reserved.
 *
 * This software is the confidential and proprietary information of PTC
 * and is subject to the terms of a software license agreement. You shall
 * not disclose such confidential information and shall use it only in accordance
 * with the terms of the license agreement.
 *
 * ecwti
 */

package com.e3ps.change;

import com.e3ps.change.ECOChange;
//import com.e3ps.change.EChangeOrder;
//import java.io.Externalizable;
//import java.io.IOException;
//import java.io.ObjectInput;
//import java.io.ObjectOutput;
//import java.lang.ClassNotFoundException;
//import java.lang.Object;
//import java.lang.String;
//import java.sql.SQLException;
//import wt.fc.ObjectReference;
//import wt.pds.PersistentRetrieveIfc;
//import wt.pds.PersistentStoreIfc;
//import wt.pom.DatastoreException;
import wt.util.WTException;
//import wt.util.WTPropertyVetoException;
import com.ptc.windchill.annotations.metadata.*;

/**
 *
 * <p>
 * Use the <code>newEChangeNotice</code> static factory method(s), not the
 * <code>EChangeNotice</code> constructor, to construct instances of this
 * class.  Instances must be constructed using the static factory(s), in
 * order to ensure proper initialization of the instance.
 * <p>
 *
 *
 * @version   1.0
 **/

@GenAsPersistable(superClass=ECOChange.class,
   foreignKeys={
   @GeneratedForeignKey(
      foreignKeyRole=@ForeignKeyRole(name="eco", type=com.e3ps.change.EChangeOrder.class,
         constraints=@PropertyConstraints(required=true)),
      myRole=@MyRole(name="ecn", cardinality=Cardinality.ZERO_TO_ONE))
   })
public class EChangeNotice extends _EChangeNotice {


   static final long serialVersionUID = 1;




   /**
    * Default factory for the class.
    *
    * @return    EChangeNotice
    * @exception wt.util.WTException
    **/
   public static EChangeNotice newEChangeNotice()
            throws WTException {

      EChangeNotice instance = new EChangeNotice();
      instance.initialize();
      return instance;
   }

}
