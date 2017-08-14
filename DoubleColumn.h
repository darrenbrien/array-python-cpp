
#ifndef DOUBLE_COLUMN
#define DOUBLE_COLUMN
#include "Column.h"

class DoubleColumn : public shapes::Column {
	
	public:
		DoubleColumn(int32_t type);
		~DoubleColumn(){}
		std::vector<double> getData();
	
	private:
		std::vector<double> data;
};

#endif
