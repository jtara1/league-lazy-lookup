#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <set>
#include <vector>
#include <algorithm>
//#include <ctime>

using namespace std;

// unused function in favor of find() and erase() member functions of string, spaces acceptable for url anyways
string removeSpaces(string name) {
    vector<int> spaceIndexes;
    string::iterator it = name.begin();
    for (it; it != name.end(); it++) {
        if (*it == ' ') {
            spaceIndexes.push_back(distance(name.begin(), it));
        }
    }
}

void printSet(set<string> names) {
    set<string>::iterator it = names.begin();
    for (it; it != names.end(); it++) {
        cout << *it << endl;
    }
}

string opggMultiQueryFormat(set<string> names) {
    string output = "";
    set<string>::iterator it = names.begin();
    for (it; it != names.end(); it++) {
        output += *it;
        if (distance(names.begin(), it) < names.size() - 1) { output += "%2C"; }
    }

    return output;
}

void saveToFile(string file_name, string contents) {
    ofstream outfile;
    outfile.open(file_name.c_str());
    outfile << contents;
    outfile.close();
}

int main(int argc, char *argv[]) {
    //clock_t init_time = clock(); // used to measure compile time

    ifstream myfile;
    myfile.open(argv[1]);
    if (!myfile.is_open()) {
        cout << "file could not be opened" << endl;
        return 0;
    }

    string line, word, name;
    int pos;
    set<string> names;
    string::size_type remove_index;

    while(getline(myfile, line)) {
        istringstream iss(line);
        pos = string::npos;
        remove_index = string::npos;

        while(iss >> word) {
            if (word == "joined") {
                pos = iss.tellg();
            }
        }

        if (pos != string::npos) {
            name = line.substr(0, pos - 7); // gets the username substring from the line string
            remove_index = name.find(' ');
            if (remove_index != string::npos) { name.erase(name.begin() + remove_index) ; } // removes space in username if found
            names.insert(name);
        }
    }

    myfile.close();

    //printSet(names);
    string url = "http://na.op.gg/multi/query=";
    string query = opggMultiQueryFormat(names);
    url += query;
    saveToFile("multi-search-url.txt", url);


    //cout << clock() - init_time << endl; // used to measure compile time
    return 0;
}
