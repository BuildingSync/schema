////////////////////////////////////////////////////////////////////////
//
// Table.java
//
// This file was generated by MapForce 2016r2.
//
// YOU SHOULD NOT MODIFY THIS FILE, BECAUSE IT WILL BE
// OVERWRITTEN WHEN YOU RE-RUN CODE GENERATION.
//
// Refer to the MapForce Documentation for further details.
// http://www.altova.com/mapforce
//
////////////////////////////////////////////////////////////////////////

package com.altova.text.tablelike;

import java.util.ArrayList;

import com.altova.AltovaException;

public abstract class Table {
    private ArrayList<Record> m_Records = new ArrayList<Record>();

    protected com.altova.typeinfo.TypeInfo tableType;

    private Header m_Header = new Header();

    protected ISerializer m_Serializer = null;

    protected abstract ISerializer createSerializer();

    protected abstract void initHeader(Header header);

    protected Table() {
        init();
    }

	protected Table(boolean b) {
	}
	
    protected void init() {
        this.initHeader(m_Header);
        m_Serializer = this.createSerializer();
    }

    public com.altova.typeinfo.TypeInfo getTableType() {
        return tableType;
    }

    public Header getHeader() {
        return m_Header;
    }

    public int size() {
        return m_Records.size();
    }

    public void add(Record rhs) {
        m_Records.add(rhs);
    }

    public void clear() {
        m_Records.clear();
    }

    public Record getAt(int index) {
        return (Record) m_Records.get(index);
    }

    public void setEncoding(String encoding, boolean bBigEndian, boolean bBOM) {
        m_Serializer.setEncoding(encoding, bBigEndian, bBOM);
    }

    public void save(com.altova.io.Output output) throws Exception
    {
    	switch (output.getType())
    	{
    		case com.altova.io.Output.IO_DOM:
    			throw new Exception ("This is text component, it cannot be written into DOM!");
    			
    		case com.altova.io.Output.IO_STREAM:
    			save(output.getStream());
    			break;
    			
    		case com.altova.io.Output.IO_WRITER:
    			save(output.getWriter());
    			break;
    			
    		default:
    			throw new Exception ("Unknown output type");
    	}
    }
    
    public void save(java.io.OutputStream stream) 
    {
        try 
        {
            m_Serializer.serialize(stream);
        } 
        catch (MappingException x) 
        {
            throw new AltovaException(x);
        }
    }
    
    public void save(java.io.Writer writer) 
    {
        try 
        {
            m_Serializer.serialize(writer);
        } 
        catch (MappingException x) 
        {
            throw new AltovaException(x);
        }
    }
    
    public void parse (com.altova.io.Input input) throws Exception
    {
    	switch (input.getType())
    	{
    		case com.altova.io.Input.IO_DOM:
    			throw new Exception ("This is text component, it cannot be read from DOM!");
    			
    		case com.altova.io.Input.IO_STREAM:
    			parse(input.getStream());
    			break;
    		
    		case com.altova.io.Input.IO_READER:
    			parse(input.getReader());
    			break;
    			
    		default:
    			throw new Exception ("Unknown output type");
    	}
    }

    public void parse(java.io.Reader reader)
    {
    	try 
    	{
    		m_Serializer.deserialize(reader);
    	}
    	catch (MappingException x) 
    	{
            throw new AltovaException(x);
        }
    }
    
    public void parse(java.io.InputStream stream) 
    {
        try 
        {
            m_Serializer.deserialize(stream);
        } 
        catch (MappingException x) 
        {
            throw new AltovaException(x);
        }
    }
}
