
#include "Column.h"

IntegerColumn::IntegerColumn(int32_t type) : Column(type){
	data.reserve(100);
}

std::vector<int32_t> IntegerColumn::getData(){
	return this->data;
}

