/* 
 * File:          Parser.h
 * Author:        Thomas Tracy
 * This contains the class that will control the parser, the file it is parsing,
 * and its elements.
 * Created on:    September 16, 2015, 2:37 PM
 * Updated last:  October 15, 2015, 2:34 PM
 */

#ifndef PARSER_H
#define	PARSER_H
#include "Reptilia.h"
#include <fstream>
#include <iostream>
#include <vector>


/**
 * A class used to parse an XML file, either line by line, or by whole files.
 * Places data into a vector m_velements of the element class. Can also provide
 * the state of the parser on a given line, rewind the file, sort by various
 * parameters, and check for "well formedness" of the file.
 */
class XML_parser {
private:
    /** holds tag names*/
    std::vector<element*> m_velements;  
    /** XML file name to be worked on */                
    std::string m_strFileName;
    /** stream object of the actual XML file */
    std::fstream m_XMLfile;
   /** the current line number being read from the file */
    int m_iLineNumber;
    /** current line of XML being worked on by the parser */
    std::string m_strLine;
    /** used to check formatting of the file */
    std::vector<element*> m_vCheckForm; 
    
    

    /**
     * Enumerated type used to distinguish the various states of the parser, 
     * Taken from the class notes of September 17th:
     * https://teaching.cs.uml.edu/~heines/91.204/91.204-2015-16f/204-lecs/lecture06.jsp
     */
   typedef enum PARSER_STATE{
        UNKNOWN, 
        STARTING_DOCUMENT,
        DIRECTIVE,
        ELEMENT_OPENING_TAG, 
        ELEMENT_CONTENT, 
        ELEMENT_NAME_AND_CONTENT,
        ELEMENT_CLOSING_TAG, 
        SELF_CLOSING_TAG,
        STARTING_COMMENT, 
        IN_COMMENT, 
        ENDING_COMMENT, 
        ONE_LINE_COMMENT,
        ERROR
    } PARSER_STATE;
    
    PARSER_STATE PS_current;
    
    
    /**
     * check the XML file for well-formedness. Essentially, check to see if the
     * XML file has valid syntax
     * @return 
     * 1 for valid
     * 0 for invalid
     */
    int check_well_formedness(std::string strTagToCompare);
    
    /**
     * prints out the current parser state. Used in tandem with the PARSER_STATE
     * enum type. Also taken from the notes of September 17th
     */
    void show_state();
   
    /**
     * prints out the child tree of all the elements in preorder
     */
    void preorder_tree(element* eleCurrent, std::vector<element*>::iterator it);
    
    /**
     * helper function to grab the elements out of a tag
     */
    void get_attributes(int iBegDelim, int iEndDelim, element* element);
    
public:

    /**
     * Constructor for an unknown file name. The user will be prompted to
     * enter a file name at time of creation.
     */
    XML_parser();       
    
    /**
     * Constructor for known file name.
     * @param p_chFileName - the XML file to be parsed
     */
    XML_parser(char* p_chFileName);
    
    /**
     * Destructor for the parser. Will remove dynamically allocated elements
     * when the class is destroyed. 
     */
    ~XML_parser();

    /**
     * Parses the entire file in m_XMLfile and fill it with elements 
     * @return: 
     * 1 for success
     * 0 for failure
     */
    int parse_file_tagname();

    /**
     * Parses the next line in the file, putting tag names and line numbers 
     * into the elements held in m_velements.
     * @return:
     * 1 for success
     * 0 for failure to find '<'
     */
    int parse_line_tagname();
    
    /**
     * Parses the whole file, returning the state of the parser and putting all
     * relevant data into the elements.
     * @param:
     * ishowState - whether or not to print the parser state while running through
     * the program. 0 for false, > 0 for true
     * @return:
     * 1 for success
     * 0 for failure
     */
    int parse_file_all(int iShowState);
    
    
    /**
     * Parses the next line in the file, getting all relevant data.
     * Used to view what is in each line of the file and the state of the parser.
     * @return:
     * state of the parser
     */
    int parse_line_all();

    /**
     * uses sort() found in <algorithm> to sort the elements in m_velements
     * by line number. I got the idea for this method of sorting the elements from:
     * http://www.cplusplus.com/articles/NhA0RXSz/
     * @return:
     * 1 for success
     * 0 for failure
     */
    int sort_by_line();

    /**
     * uses sort() found in <algorithm> to sort the elements in m_velements
     * by tag name. 
     * @return:
     * 1 for success
     * 0 for failure
     */
    int sort_by_tag();

    /**
     * This will remove duplicate elements from a list according to the tag 
     * name. List must first be sorted by name for this to work!!
     * @return:
     * number of deleted tags
     */
    int remove_duplicate_tags();

    /**
     * displays the list of sorted elements. The list will be printed by line
     * number if no sort is called.
     * @return:
     * 1 for success
     * 0 for failure
     */
    int display_sorted_list();
    
    /**
     * rewinds the file to the start of the file. HAS FUNCTIONALITY TO EMPTY THE
     * m_velements VECTOR. BE CAREFUL. 
     * @param: iEmptyVector - 0 to retain m_velements data, > 0 to empty.
     */
    void parser_rewind(int iEmptyVector);
    
    /**
     * returns a pointer to the root element of the XML tree
     */
    element* get_root_p();
    
     /**
     * a function to handle recursive display of the element tree
     * @param: iLevel - The level in the tree the current element is at (ie if it
     * was a child of the root node, it would be level 1. Root being 0)
     * eleCurrent - the element at which you want to start printing out the tree.
     */
    void recursive_display(int iLevel, element* eleCurrent);
    
    /**
     * a function to handle recursive display of what the file would look like
     * in JSON
     * @param: iLevel - The level in the tree the current element is at (ie if it
     * was a child of the root node, it would be level 1. Root being 0)
     * eleCurrent - the element at which you want to start printing out the JSON.
     */
    void output_JSON(int iLevel, element* eleCurrent);
    
   
    
};


#endif	/* PARSER_H */