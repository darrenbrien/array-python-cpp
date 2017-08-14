#include "Column.h"

Column::Column(int32_t type){ 
	this->type = type;
}

Column::~Column(){}

int32_t Column::getType() { 
	return this->type ;
}


