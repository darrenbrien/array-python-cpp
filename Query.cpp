#include "Query.h"

std::vector<ColumnBase* > Query::get_cols(std::string query)
{
int svrows = 300000;
int svcols = 30;
std::vector<ColumnBase* > cols;
for (int ii=0; ii<svcols; ii++)
{
	if(ii %2 != 0){
		Column<double> * col = new Column<double>(SSTR(ii), 101);
		for(double i =0; i < svrows; i++){
			col->vec.push_back(i);
		}
		
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else{
		Column<int32_t> * col = new Column<int32_t>(SSTR(ii), 202);
		for(int i =0; i < svrows; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
}        
return cols;
}

