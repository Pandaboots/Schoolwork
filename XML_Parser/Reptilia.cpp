/* 
 * File:             Reptilia.cpp
 * Implementation file for the Element class
 * Author:           Thomas Tracy
 * Created on:       September 3, 2015, 7:42 PM
 * Updated last:     October 15, 2015, 1:38 PM
 * 
 */

#include "Reptilia.h"
using namespace std;


element::element() : m_strTagName("(no_tagname)"), m_iLineNumber(0), m_strContent("(no_content)")
{}
 
element::~element()
{}


string element::get_tagName()
{
    return m_strTagName;
}

int element::get_lineNumber()
{
    return m_iLineNumber;
}

void element::setILineNumber(int iLineNumber) {
    m_iLineNumber = iLineNumber;
}

void element::setStrTagName(std::string strTagName) {
    m_strTagName = strTagName;
}

void element::setStrContent(std::string strContent) {
    m_strContent = strContent;
}

std::string element::getStrContent() const {
    return m_strContent;
}

void element::add_child(element* eleChild)
{
    this->m_children.push_back(eleChild);
}


int element::child_empty()
{
    return this->m_children.empty();
}

std::vector<element*>::iterator element::child_begin()
{
    return this->m_children.begin();
}

std::vector<element*>::iterator element::child_end()
{
    return this->m_children.end();
}

std::vector<element*> element::getChildren() const {
    return m_children;
}

void element::setAttribute(string strKey, string strContent) {
    m_attribute.insert({strKey, strContent});
}


map<std::string, std::string> element::getAttribute() const {
    
    return this->m_attribute;
    
}


int element::child_size()
{
    return this->m_children.size();
}

void element::display_attributes(int iLevel)
{
    if(this->m_attribute.empty())
    {
        cout << "(no_attributes)\n";
        return;
    }
    
    map<string,string>::iterator it = this->m_attribute.begin();
    
    while(it != this->m_attribute.end())
    {
        for(int i = 0; i <= iLevel + 1; i++)
        {
            cout << "  ";
        }
        cout << "\""<<  (*it).first << "\" : \""<< (*it).second << "\"";
        cout << ",";
        
        //janky way to point to the last value in the map
        if((*it).second != this->m_attribute.rbegin()->second)
        {
            cout << endl;
        }
        it++;
    }
}