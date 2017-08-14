#include "Column.h"

DoubleColumn::DoubleColumn(int32_t type) : Column(type){
	data.reserve(100);
}

std::vector<double> DoubleColumn::getData(){
	return this->data;
}
