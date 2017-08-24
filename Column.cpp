#ifndef column
#define column

#include <vector>
#include <iostream>
#include <stdint.h>

class ColumnBase {
    public:
	
	ColumnBase(std::string name, int32_t type){
        	this->name = name;
        	this->type = type;
	}
	
	virtual ~ColumnBase(){}

	int32_t getType(){ return type;}
	std::string getName() {return name;}
	protected:
		std::string name;
		int32_t type;
};


template<typename VALUE_TYPE>
class Column : public ColumnBase {
   public:
      std::vector<VALUE_TYPE> vec;
      Column(std::string name, int32_t type) : ColumnBase(name, type) {
	    vec.reserve(1000000);	
      }
	
      virtual ~Column(){
      }
      
      void dispose(){
	  delete this;
      }
};


class ByteStringColumn : public ColumnBase {
   public:
      std::vector<char> vec;
      std::vector<size_t> lengths;
      std::vector<size_t> offsets;
      ByteStringColumn(std::string name, int32_t type) : ColumnBase(name, type) {
            vec.reserve(1000000);
            offsets.reserve(1000000);
            lengths.reserve(1000000);
      }

      virtual ~ByteStringColumn(){
      }

      void dispose(){
          delete this;
      }
};


#endif
