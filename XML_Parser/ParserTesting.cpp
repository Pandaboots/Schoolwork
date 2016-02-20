/* 
 * File:             ParserTesting.cpp
 * The main file used to test the parser class and test the well-formedness 
 * of an XML document.
 * Author:           TJ Tracy
 * Created on:       September 16, 2015, 3:45 PM
 * Updated last:     October 15, 2015, 12:03 PM
 */

#include <cstdlib>
#include "Parser.h"     // I decided to put everything related to the parser
                        // into its own class to create an interface for myself.
                        // Please look into the declaration of the XML_parser class.
#include "Reptilia.h"   // Declaration of the element class
using namespace std;

/**
 * The main function of the program. Parses the file, and checks the tags for
 * file well-formedness.
 * it then prints out the Tree of children for the XML file
 * @param argc - command line argument count
 * @param argv - actual arguments entered to the command line
 * @return - returns success or failure to the OS (0 for success)
 */
int main(int argc, char** argv) {
    
    
    XML_parser reptilia(argv[1]);  // initialize parser (filename on the command line)
    element* ele = new element;
            
    //Display the parser state, the tag names, content attributes, and line number
    reptilia.parse_file_all(0);
    
   
    ele = reptilia.get_root_p();
    reptilia.output_JSON(0, ele);
    
    return 0;
}