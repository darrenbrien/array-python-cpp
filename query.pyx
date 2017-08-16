# cython: boundscheck=False
# cython: cdivision=True
# cython: wraparound=False
# distutils: language = c++
# distutils: sources = Query.cpp
from libcpp.string cimport string
from libcpp.vector cimport vector
import numpy as np
cimport numpy as np
from column cimport ColumnBase
from column cimport Column
from cython cimport view

# c++ interface to cython
cdef extern from "Query.h": 
  cdef cppclass Query:
        vector[ColumnBase*] get_cols(string)

# creating a cython wrapper class
cdef class PyQuery:
    cdef Query *thisptr
    def get_cols(self, string query):
        result = self.thisptr.get_cols(query)
        return to_dict(result)

cdef to_dict(vector[ColumnBase*] cols):
    d = {}
    for i in range(cols.size()):
        name = cols[i].getName().decode('utf8')
        d[name] = to_numpy(cols[i])
    return(d)

cdef to_numpy(ColumnBase* i):
    if i.getType() == 101:
        return create_floats(<Column[np.float64_t]*> i) 
    if i.getType() == 202:
        return create_ints(<Column[np.int32_t]*> i)

cdef create_ints(Column[np.int32_t]* col):
    data = np.asarray(<np.int32_t[:col.vec.size()]> &(col.vec[0]))
    result = np.asarray(data.copy())
    del data
    col.dispose()
    return result

cdef create_floats(Column[np.float64_t]* col):
    data = np.asarray(<np.float64_t[:col.vec.size()]> &(col.vec[0]))
    result = np.asarray(data.copy())
    del data
    col.dispose()
    return result
