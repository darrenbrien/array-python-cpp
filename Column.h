#ifndef COLUMN_H
#define COLUMN_H
namespace shapes{
	class Column {
	
		public:
			Column(int32_t type);
			virtual ~Column();
			int32_t getType();
	
		private:
			int32_t type;
	};
}
#endif
