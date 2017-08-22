#include "Query.h"

std::vector<ColumnBase* > Query::get_cols(std::string query)
{
int svrows = 300000;
int svcols = 30;
std::vector<ColumnBase* > cols;

for (int ii=0; ii<svcols; ii++)
{
	if(ii % 6 == 0){
		Column<uint8_t> * col = new Column<uint8_t>(SSTR(ii), 101);
		for(int i =0; i < svrows; i++){
			col->vec.push_back(i % 2 == 0);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else if(ii % 6 == 1){
		Column<int32_t> * col = new Column<int32_t>(SSTR(ii), 102);
		for(int32_t i =0; i < svrows; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else if(ii % 6 == 2){
		Column<int64_t> * col = new Column<int64_t>(SSTR(ii), 103);
		for(int64_t i =0; i < svrows; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else if(ii % 6 == 3){
		Column<double> * col = new Column<double>(SSTR(ii), 104);
		for(double i =0; i < svrows; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else if(ii % 6 == 4){
		Column<int64_t> * col = new Column<int64_t>(SSTR(ii), 105);
		for(int64_t i = 1503183628275000000; i < 1503183628275000000 + svrows; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else{
		ByteStringColumn * col = new ByteStringColumn(SSTR(ii), 106);
		size_t offset = 0;
		for(int i =0; i < svrows; i++){
			char string[10];
			size_t length = sprintf(string, "%d", 100* (i % 50));
			col->lengths.push_back(length);
			col->offsets.push_back(offset);
			offset += length;
			col->vec.insert(col->vec.end(), string, string + length);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
}       
return cols;
}

