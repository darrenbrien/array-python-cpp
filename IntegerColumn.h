#ifndef INTEGER_COLUMN
#define INTEGER_COLUMN
#include "Column.h"
namespace shapes {
	class IntegerColumn : public shapes::Column {
		
		public:
			IntegerColumn(int32_t type);
			~IntegerColumn(){}
			std::vector<int32_t> getData();
		
		private:
			std::vector<int32_t> data;
	};
}
#endif
