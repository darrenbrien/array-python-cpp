from libcpp.string cimport string

cdef extern from "Column.cpp":
    cdef cppclass ColumnBase:
        ColumnBase(string name, int t)
        int getType()

