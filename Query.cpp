#include "Query.h"

std::vector<ColumnBase* > Query::get_cols(std::string query)
{
int svrows = 10000;
std::vector<ColumnBase* > cols;
for (int ii=0; ii<svrows; ii++)
{
	if(ii %2 != 0){
		Column<double> * col = new Column<double>(SSTR(ii), 101);
		for(double i =0; i < 10000; i++){
			col->vec.push_back(i);
		}
		
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else{
		Column<int32_t> * col = new Column<int32_t>(SSTR(ii), 202);
		for(int i =0; i < 10000; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
}        
return cols;
}

