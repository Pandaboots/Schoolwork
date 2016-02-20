/* 
 * File:          Parser.cpp
 * Implementation file for the Parser class.
 * Author:        TJ Tracy
 * Created on:    September 17, 2015, 7:42 PM
 * Updated last:  October 15, 2015, 2:34 PM
 * 
 */

#include "Parser.h"
#include "Reptilia.h"
#include <string>
#include <fstream>
#include <algorithm>
#include <iostream>
#include <iomanip>
using namespace std;

/**
 * compares line numbers of 2 elements and returns the result.
 * for use with sort()
 */
bool compare_by_line(element* tag1, element* tag2)
{ 
    return tag1->get_lineNumber() < tag2->get_lineNumber(); 
}

/**
 * compares tag names of 2 elements and returns the result.
 * for use with sort()
 */
bool compare_by_tag(element* tag1, element* tag2)
{ 
    return tag1->get_tagName() < tag2->get_tagName(); 
}

/**
 * Constructor for unknown filename
 */
XML_parser::XML_parser()
{
    this->m_iLineNumber = 1;
    
    cout << "Please enter the file or path of the file you wish to parse.\n";
    cout << "\\> ";
    cin >> m_strFileName;
    
 
    
    m_XMLfile.open(m_strFileName.c_str(), fstream::in);
    
    if(m_XMLfile == NULL)
    {
        cout << "Could not open that file. try again.\n";
        exit(1);
    }
}


XML_parser::XML_parser(char* p_chFileName)
{
    m_iLineNumber = 1;
    
    m_XMLfile.open(p_chFileName, fstream::in);
    
    if(m_XMLfile == NULL)
    {
        cout << "Could not open that file. try again.\n";
        exit(1);
    }
    
    m_strFileName = p_chFileName;
}


XML_parser::~XML_parser()
{
    m_XMLfile.close();
    
    //CLEAR THE MEMORY FOR THE LIST
    std::vector<element*>::iterator it_delete;
    it_delete = this->m_velements.begin();

    //iterate over the vector, clearing dynamic memory, if it is not empty
    if(!this->m_velements.empty())
    {
        while(it_delete != this->m_velements.end())
        {
            delete *(it_delete);
            this->m_velements.erase(it_delete);
        }
    }
    
    if(!this->m_vCheckForm.empty())
    {
        while(it_delete != this->m_vCheckForm.end())
        {
            delete *(it_delete);
            this->m_vCheckForm.erase(it_delete);
        }
    }
}



int XML_parser::parse_file_tagname()
{
    while(!m_XMLfile.eof())
    {
        parse_line_tagname();
    }
    return 1;
}


int XML_parser::parse_line_tagname()
{
    
    int         iBegDelim,              // position of '<' 
                iEndDelim,              // position of '>' after initial '<'
                iWhiteSpace;            // position of any ' ' after initial '<'
    element*    eleTemp = new element;  // temporary element to be pushed into v_elements
   
    
    
    getline(m_XMLfile, m_strLine);
    
    
    // find the first delimiter
    iBegDelim = m_strLine.find_first_of('<', 0);
    
    //check if the tag is not an end tag
    if(m_strLine[iBegDelim + 1] != '/' && m_strLine[iBegDelim + 1] != '!')
    {
        //skip the first '?' for xml version at the top
        if(m_strLine[iBegDelim + 1] == '?')
            iBegDelim++;
        
        // find whichever second delimiter comes first
        iEndDelim = m_strLine.find_first_of('>', iBegDelim);
        iWhiteSpace = m_strLine.find_first_of(' ', iBegDelim);
        
        if (iWhiteSpace < iEndDelim && iWhiteSpace > iBegDelim)
            iEndDelim = iWhiteSpace;
        
       // create the element and push it back into velements
        if(m_strLine != "")
        {
            eleTemp->setStrTagName(m_strLine.substr(iBegDelim + 1, iEndDelim - (iBegDelim + 1)));
            eleTemp->setILineNumber(m_iLineNumber);
            m_velements.push_back(eleTemp);
        }
        
        //increment the line number for the file
        this->m_iLineNumber++;
       return 1;
    }
    
    
    this->m_iLineNumber++;
    return 0;
    
}


int XML_parser::sort_by_line()
{
    sort(m_velements.begin(), m_velements.end(), compare_by_line);
    return 1;
}


int XML_parser::sort_by_tag()
{
    sort(m_velements.begin(), m_velements.end(), compare_by_tag);
    return 1;
}


int XML_parser::remove_duplicate_tags()
{
    
    unsigned int x = 0;              // index counter for the list
    int iNumberDeleted = 0; // return variable for number of deleted tags
    
    
    // iterate over the list 
    while(x < m_velements.size())
    {
        
        // if a tag name is equal to the next tag name, delete it from the list
        // if not, continue iterating over the list
        if(m_velements[x]->get_tagName() == m_velements[x+1]->get_tagName())
        {
            delete m_velements[x];
            m_velements.erase(m_velements.begin() + x);
            iNumberDeleted ++;
        }
        else
            x++;
    }
    
    return iNumberDeleted;
    
}


int XML_parser::display_sorted_list()
{
    vector<element*>::iterator vIndex = m_velements.begin(); // used to iterate over the list
    
    
    while(vIndex != m_velements.end())
    {
        cout << "Line "  << setw(3) << (*vIndex)->get_lineNumber() << ": "
             << (*vIndex)->get_tagName() << endl;
        ++vIndex;
    }
    
    return 0;
}


 int XML_parser::parse_line_all()
 {
      int       iBegDelim = -1,              // position of '<' 
                iEndDelim = -1,              // position of '>' after initial '<'
                iBegDelim2 = -1,             // position of 2nd '<' in a line 
                iEndDelim2 = -1,             // position of 2nd '>' in a line
                iWhiteSpace = -1;            // position of any ' ' after initial '<'
    element*    eleTemp = new element;       // temporary element to be pushed into v_elements
    string      strEndTag;                   // the ending tagname to compare for wellformedness
                                             // when the parser is in ELEMENT_CLOSING_TAG state
    
   
    
    // help move through the string and to gather tokens.              
    getline(this->m_XMLfile, this->m_strLine);
    string::iterator it_line = this->m_strLine.begin();
    
    
    // grab all the possible delimiters in the line that we are concerned with
    iBegDelim = this->m_strLine.find_first_of('<', 0);
    iEndDelim = this->m_strLine.find_first_of('>', 0);
    iBegDelim2 = this->m_strLine.find_first_of('<', iBegDelim + 1);
    iEndDelim2 = this->m_strLine.find_first_of('>', iEndDelim + 1);
    iWhiteSpace = this->m_strLine.find_first_of(' ', iBegDelim + 1);
    
    eleTemp->setILineNumber(this->m_iLineNumber);
    
    if(iEndDelim == -1)
    {
        // checking for inside comments
        if(this->PS_current == STARTING_COMMENT || this->PS_current == IN_COMMENT)
        {
            eleTemp->setStrContent(this->m_strLine);
            this->PS_current = IN_COMMENT;
        }
        else if(*((it_line + iBegDelim) + 1) == '!')
        {
            if(*((it_line + iBegDelim) + 2) == '-' && *(it_line + iBegDelim + 3) == '-')
            {
                PS_current = STARTING_COMMENT;
            }
            else
            {
                PS_current = ERROR;
            }
                
        }
        else
        {
            eleTemp->setStrContent(m_strLine); 
            PS_current = UNKNOWN;
        }
    }
    
    // checking for the end of a comment
    else if(iBegDelim == -1 && *((it_line + iEndDelim) - 1) == '-' && *((it_line + iEndDelim) - 2) == '-')
    {
        PS_current = ENDING_COMMENT;
    }
    
    // checking for the beginning of a comment
    else if(*((it_line + iBegDelim)+1) == '!' && *((it_line + iBegDelim)+2) == '-' && *((it_line + iBegDelim)+3) == '-')
    {
        eleTemp->setStrContent(m_strLine.substr(iBegDelim + 4, (iEndDelim - 3) - (iBegDelim + 3)));
        PS_current = ONE_LINE_COMMENT;
    }
    
    // checking for a closing tag
    else if(*((it_line + iBegDelim)+1) == '/')
    {
        // set the state to ELEMENT_CLOSING_TAG
        PS_current = ELEMENT_CLOSING_TAG;
        
    }
    
    // checking for a directive
    else if(*((it_line + iBegDelim)+1) == '?')
    {
        eleTemp->setStrContent(m_strLine.substr(iBegDelim + 2, (iEndDelim - 2) - (iBegDelim + 1)));
        PS_current = DIRECTIVE;
    }
    
    // if its not one of the special cases, it must be a opening tag
    else
    {
        // remove any attributes if applicable and set the tag name in the temp
        // element
        if (iWhiteSpace < iEndDelim && iWhiteSpace > iBegDelim)
        {
           //gather any attributes this element might have 
           this->get_attributes(iBegDelim, iWhiteSpace, eleTemp);
           eleTemp->setStrTagName(m_strLine.substr(iBegDelim + 1, (iWhiteSpace - 1) - (iBegDelim)));
        }
         
        else
        {
            eleTemp->setStrTagName(m_strLine.substr(iBegDelim + 1, (iEndDelim - 1) - (iBegDelim)));
        }
        
        // check for single line element
        if(iBegDelim2 != -1)
        {
            eleTemp->setStrContent(m_strLine.substr(iEndDelim+1, (iBegDelim2 - 1) - (iEndDelim)));
            PS_current = ELEMENT_NAME_AND_CONTENT;
            
            // if the stack is not empty, add this element as a direct child of the last element
            // in the stack.
            if(!this->m_vCheckForm.empty()) 
            {
                this->m_vCheckForm.back()->add_child(eleTemp);
            }
        }
        
        // check for self closing element
        else if (*((it_line + iEndDelim2)- 1) == '/')
        {
            eleTemp->setStrContent("(no_content)");
            PS_current = SELF_CLOSING_TAG;
            
            // if the stack is not empty, add this element as a direct child of the last element
            // in the stack.
            if(!this->m_vCheckForm.empty()) 
            {
                this->m_vCheckForm.back()->add_child(eleTemp);
            }       
            
        }
        else
        {
            PS_current = ELEMENT_OPENING_TAG;
            // if the stack is not empty, add this element as a direct child of the last element
            // in the stack.
            if(!this->m_vCheckForm.empty()) 
            {
                this->m_vCheckForm.back()->add_child(eleTemp);
            }
        }
    }
    
    // set the line number and push back the element
    //eleTemp->setILineNumber(this->m_iLineNumber);
    this->m_velements.push_back(eleTemp);
    
    // in order to be pushed into the comparing vector, check to make sure the state
    // is either an opening or closing tag
    if(this->PS_current == ELEMENT_OPENING_TAG || this->PS_current == ELEMENT_CLOSING_TAG)
    {
        // compare the tags if it is a closing tag, otherwise, push the tagname
        // onto the stack
        if(this->PS_current == ELEMENT_CLOSING_TAG)
        {
        strEndTag = m_strLine.substr(iBegDelim + 2, (iEndDelim - 1) - (iBegDelim + 1));
        this->check_well_formedness(strEndTag);
        }
        else
        {
            this->m_vCheckForm.push_back(eleTemp);            
        }
    }
    
    this->m_iLineNumber++;
    return 0;
    
    
 }
 

int XML_parser::parse_file_all(int iShowState)
{
    while(!m_XMLfile.eof())
    {
        parse_line_all();
        
        if(iShowState > 0)
        {
            this->show_state();
        }
    }
    
    return 1;
}


void XML_parser::show_state()
{
    //shows the stack checking well formedness
    cout << "\nCurrent Tag Stack:\n";

    // print out the current tag stack
    vector<element*>::iterator vIndex = m_vCheckForm.begin(); // used to iterate over the list
    while(vIndex != m_vCheckForm.end())
    {
        cout << (*vIndex)->get_tagName() << endl;
        ++vIndex;
    }

    cout << "--\n";

    //Shows the parser state at a given line
    cout << "Line Number: ";
    cout << this->m_velements.back()->get_lineNumber() << endl; 
    cout << "Parser Sate: ";
    switch ( this->PS_current ) {
    case UNKNOWN : cout << "UNKNOWN" ; break ;
    case STARTING_DOCUMENT : cout << "STARTING_DOCUMENT" ; break ;
    case DIRECTIVE : cout << "DIRECTIVE" ; break ;
    case ELEMENT_OPENING_TAG : cout << "ELEMENT_OPENING_TAG" ; break ;
    case ELEMENT_CONTENT : cout << "ELEMENT_CONTENT" ; break ;
    case ELEMENT_NAME_AND_CONTENT : cout << "ELEMENT_CONTENT" ; break ;
    case ELEMENT_CLOSING_TAG : cout << "ELEMENT_CLOSING_TAG" ; break ;
    case SELF_CLOSING_TAG : cout << "SELF_CLOSING_TAG" ; break ;
    case STARTING_COMMENT : cout << "STARTING_COMMENT" ; break ;
    case IN_COMMENT : cout << "IN_COMMENT" ; break ;
    case ENDING_COMMENT : cout << "ENDING_COMMENT" ; break ;
    case ONE_LINE_COMMENT : cout << "ONE_LINE_COMMENT" ; break ;
    case ERROR : cout << "ERROR" ; break ;
    default : cout << "UNKNOWN" ; break ;
  }
  cout << endl ;
  
  //Added ability to show the tag name of given line along with any content
  //Added ability to show attributes
  cout << "Tag Name (if any): ";
  cout << m_velements.back()->get_tagName() << endl;
  cout << "Content of line (if any): ";
  cout << m_velements.back()->getStrContent() << endl;
  cout << "Attributes (if any): ";
  cout << "____________________________________________" << endl;
}


void XML_parser::parser_rewind(int iEmptyVector)
{
    //return the reading pointer to position 0
    this->m_XMLfile.seekg(0);
    
    if(iEmptyVector > 0)
    {
        // an iterator to delete the pointers in the m_velements vector
        std::vector<element*>::iterator it_delete;
        it_delete = this->m_velements.begin();
        
        //iterate over the vector, clearing memeory inside of the vector
        while(it_delete != this->m_velements.end())
        {
            delete *(it_delete);
            this->m_velements.erase(it_delete);
        }
    }
    
    return;
}


int XML_parser::check_well_formedness(string strTagToCompare)
{   
    string strLastTagname;      //the tagname string in the last place of the
                                //comparing vector
    
    //set the last tag name to be compared to the one passed into the function
    strLastTagname = this->m_vCheckForm.back()->get_tagName();
    
    if(strLastTagname == strTagToCompare )
    {
        this->m_vCheckForm.pop_back();
        //cout << "\nThe \"" << strTagToCompare << "\" tag has closed.\n";
    }
    else
    {
        //if the tags don't match, give an error
        cout << "Error on line " << this->m_iLineNumber << ", Tags don't match.";
        exit(1);
    }
    
    return 1;
}


element* XML_parser::get_root_p()
{
    
    vector<element*>::iterator it = this->m_velements.begin();
    
    while((*it)->get_tagName() == "(no_tagname)")
    {
            it++;
    }
    return *it;
}


void XML_parser::recursive_display(int iLevel,  element* eleCurrent)
{
  
    
    //if it is not empty, step through the vector, recalling the function for each
    //individual child, adding 1 to the level.
    vector<element*> eleChildren = eleCurrent->getChildren();
    vector<element*>::iterator it = eleChildren.begin();
    
    if(iLevel == 0)
    {
        cout << eleCurrent->get_tagName() << " is the root element, found on line: " << eleCurrent->get_lineNumber() << ". ";
            cout << "It has: " << eleCurrent->child_size() << " Children" << endl;
    }
    
      if(!eleChildren.empty())
    {
         while(it != eleChildren.end())
        {
             for(int i = 0; i <= iLevel; i++)
            {
                cout << ". ";

            }

            cout << (*it)->get_tagName() << " found on line: " << (*it)->get_lineNumber() << ". ";
            cout << "It has: " << (*it)->child_size() << " Children" << endl;
            this->recursive_display(iLevel + 1, (*it));
            it++;
        }
    }
       
   
    
    return;    
}


void XML_parser::get_attributes(int iBegDelim, int iWhiteSpace, element* element)
{
    int iEqDelim = 0;       //delimiter finding the first equals symbol
    int iFirstQuote = 0;    //find the quote at the very start of an attribute
    int iSecondQuote = 0;   // find the quote at the very end of an attribute
    string key = "";        // The key of the attribute that will be loaded into the map
    string content = "";    // The content on the attribute that will be loaded into the map
    
    
    //find the first equals symbol
    iEqDelim = this->m_strLine.find_first_of('=', iEqDelim + 1);
    while(iEqDelim != -1)
    {
        //get the key
        key = this->m_strLine.substr(iWhiteSpace+1,((iEqDelim - 1) - iWhiteSpace));

        //find the delimiters of the content
        iFirstQuote = this->m_strLine.find_first_of('"',iEqDelim);
        iSecondQuote = this->m_strLine.find_first_of('"', iFirstQuote + 1);
        
        //get the content
        content = this->m_strLine.substr(iFirstQuote + 1, ((iSecondQuote - 1) - (iFirstQuote)));
       
        //set the attribute to the element
        element->setAttribute(key, content);
        
        //start all over, searching for more attributes
        iEqDelim = this->m_strLine.find_first_of('=', iEqDelim + 1);
        iWhiteSpace = this->m_strLine.find_first_of(' ', iSecondQuote);
    }
    
    //This function can be easily modified to remove white space to allow for any ammount
    //of white space in a tag name for attributes using find_first_not_of(). I am aware of
    //this but ran out of time to impliment it.
    
}

void XML_parser::output_JSON(int iLevel, element* eleCurrent)
{
    vector<element*> eleChildren = eleCurrent->getChildren();
    vector<element*>::iterator it = eleChildren.begin();
    
    if(iLevel == 0)
    {
        cout << "{\n";
    }
    
      if(!eleChildren.empty())
    {
         while(it != eleChildren.end())
        {
            //indentation
            for(int i = 0; i <= iLevel; i++)
            {
                cout << "  ";

            }

            // print out the tag name
            cout <<"\"" << (*it)->get_tagName() << "\" : ";
            
            //print out the content (if any))
            if((*it)->getStrContent() != "(no_content)")
            {
                
                cout << "\"" << (*it)->getStrContent() << "\"";
                
                //if its not the last child, print out a comma
                if((*it) != eleChildren.back())
                {
                    cout << ",";
                }
            }
            
            //print out the bracket if there is no content
            else
            {
                cout << setw(2) << "{";
                
                //show any attributes that may be included in the tag
                if(!(*it)->getAttribute().empty())
                {
                    cout << endl;
                    
                    (*it)->display_attributes(iLevel);
                }
            }
            
            // end the filly formed line of JSON
            cout << endl;
            
            //recursive call to the next child, if any
            this->output_JSON(iLevel + 1, (*it));
            
            //print out the closing brakets, adding commas
            //if there is more data inside of a tag
            if((*it)->getStrContent() == "(no_content)")
            {
                 for(int i = 0; i <= iLevel ; i++)
                {
                    cout << "  ";
                }

                cout << "}";
                if(*it != eleChildren.back())
                {
                    cout << ",";
                }
                cout << endl;
            }
            
            //finally, iterate to the next child
            it++;
        }
         // print out the final closing tag
         if (iLevel == 0)
         {
            cout << "}" << endl;
         }
    }
    
}