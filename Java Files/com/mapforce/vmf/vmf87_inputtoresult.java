/**
 * vmf/vmf87_inputtoresult.java
 *
 * This file was generated by MapForce 2016r2.
 *
 * YOU SHOULD NOT MODIFY THIS FILE, BECAUSE IT WILL BE
 * OVERWRITTEN WHEN YOU RE-RUN CODE GENERATION.
 *
 * Refer to the MapForce Documentation for further details.
 * http://www.altova.com/mapforce
 */
package com.mapforce.vmf;
import com.altova.mapforce.*;
import com.altova.types.*;
import com.altova.xml.*;
import java.util.*;

public class vmf87_inputtoresult extends com.altova.TraceProvider 
{

	
	static class Main implements IEnumerable
	{
		double var1_input;
	
		public Main(double var1_input)
		{
			this.var1_input = var1_input;
		}

		public IEnumerator enumerator() {return new MFEmptySequence().enumerator();}
				
	}





	public static IEnumerable create(double var1_input)
	{
		if (hash == null) init();
		Object o = hash.get(var1_input);
		if (o != null)
			return new MFSingletonSequence(o);
		else
			return new MFSingletonSequence(com.altova.CoreTypes.box("Total"));

	}
	
	private static java.util.HashMap hash = null;

	private synchronized static void init()
	{
		hash = new java.util.HashMap();
	}

	public static java.lang.String eval(double var1_input) throws java.lang.Exception
	{

		com.altova.mapforce.IEnumerator e = create(var1_input).enumerator();
		if (e.moveNext())
		{
			java.lang.String result = ((java.lang.String)e.current());
			e.close();
			return result;
		}
		e.close();
		throw new com.altova.AltovaException("Expected a function result.");		
	
	}

}
