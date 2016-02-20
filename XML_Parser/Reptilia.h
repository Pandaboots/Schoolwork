/* 
 * File:         Reptilia.h
 * Author:       Thomas Tracy
 * Header for the element class used to parse XML
 * Created on:   September 3, 2015, 7:42 PM
 * Updated last: October 15, 2015, 5:30 PM
 */

#ifndef REPTILIA_H
#define	REPTILIA_H

#include <string>
#include <vector>
#include <iostream>
#include <iomanip>
#include <map>

/**
 * A class used to hold all of the information taken out of a given line in an
 * XML file. To be used with the XML_parser class.
 */
class element{
    
private:
    /** stores element tag names */
    std::string m_strTagName;
    /** stores the line number the element is on */
    int  m_iLineNumber;
    /** content of the element */
    std::string m_strContent;   
    /** Direct children of this element */
    std::vector<element*> m_children;
    /** attributes taken from a tag */
    std::map<std::string, std::string> m_attribute; 
                                 
public:
    
    /**
     * Default Constructor
     */
    element();
    
    /**
     * Default Destructor. 
     */
    ~element();
    
    /**
     * getter for m_strTagName
     * @return - tag name of the element
     * 
     */
    std::string get_tagName();
    
    /**
     * getter for m_iLineNumber
     * @return - the line number the element is found on
     */
    int get_lineNumber();
 
    /**
     * mutator for m_iLineNumber
     * @param iLineNumber - set the line number the element is found on
     */
    void setILineNumber(int iLineNumber);
    
    /**
     * mutator for m_strTagName
     * @param strTagName - the name of the tag you would like the element to have
     */
    void setStrTagName(std::string strTagName);
    
    /**
     * mutator for m_strContent
     * @param strContent - the content you wish the element to have
     */
    void setStrContent(std::string strContent);
    
    /**
     * getter for m_strContent
     * @return - the content of the element
     */
    std::string getStrContent() const;
    
    /**
     * adds a child to the children vector of the current element
     */
    void add_child(element* eleChild);
    
    
    /**
     * Returns whether or not the child vector is empty
     * @return - 0 for child vector = NULL, >0 for anything else
     */
    int child_empty();
    
    /**
     * A function to find the begining of the child vector
     * @return - an iterator to the begining of the child vector
     */
    std::vector<element*>::iterator child_begin();
    
    /**
     * A funtion to the find the end of the child vector
     * @return - an iterator to the end of the child vector
     */
    std::vector<element*>::iterator child_end();
    
    /**
     * getter to return the size of the vector of children this element has
     * @return - integer amount of children
     */
    int child_size();
    
    /**
     * getter to return to the caller a vector of this current elements children.
     * THE VECTOR IS CONSTANT AND MAY NOT BE MODIFIED IN ANY WAY. Used to display
     * a tree of data.
     * @return - vector of children
     */
    std::vector<element*> getChildren() const;
    
    /**
     * Used to set an attribute of the given element. Uses C++11, will not compile
     * WITHOUT c++11
     * @param strKey - the key name for the attribute
     * @param strContent - the content attached to the key
     */
    void setAttribute(std::string strKey, std::string strContent);
    
    /**
     * This is used to get a copy of the whole atribute map of an element. Cannot
     * be modified.
     * @return - the attribute map
     */
    std::map<std::string, std::string> getAttribute() const;
    
    /**
     * a quick function used to display the attributes of an element. Works best
     * when used with the show_states() function from Parser.h.
     * @param: iLevel The level of the tree the current attribute is on
     */
    void display_attributes(int iLevel);
    
};

#endif	/* REPTILIA_H */

