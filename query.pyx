# cython: boundscheck=False
# cython: cdivision=True
# cython: wraparound=False
# distutils: language = c++
# distutils: sources = Query.cpp
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair
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
    cdef d = []
    cdef string name
    for i from 0 <= i < cols.size():
        name = cols[i].getName().decode('utf-8')
        d.append((name, to_numpy(cols[i])))
    return(d)

cdef to_numpy(ColumnBase* i):
    if i.getType() == 101:
        return create_bool(<Column[np.int8_t]*> i)
    elif i.getType() == 102:
        return create_int32(<Column[np.int32_t]*> i)
    elif i.getType() == 103:
        return create_int64(<Column[np.int64_t]*> i) 
    elif i.getType() == 104:
        return create_float64(<Column[np.float64_t]*> i) 
    elif i.getType() == 105:
        return create_datetime64(<Column[np.int64_t]*> i) 
    else: #i.getType() == 106:
        return create_string(<Column[string]*> i)

cdef create_int32(Column[np.int32_t]* col):
    cdef data = np.asarray(<np.int32_t[:col.vec.size()]> &(col.vec[0]))
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result

cdef create_float64(Column[np.float64_t]* col):
    cdef data = np.asarray(<np.float64_t[:col.vec.size()]> &(col.vec[0]))
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result

cdef create_bool(Column[np.int8_t]* col):
    cdef data = np.asarray(<np.int8_t[:col.vec.size()]> &(col.vec[0]))
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result

cdef create_int64(Column[np.int64_t]* col):
    cdef data = np.asarray(<np.int64_t[:col.vec.size()]> &(col.vec[0]))
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result

cdef create_datetime64(Column[np.int64_t]* col):
    cdef data = np.asarray(<np.int64_t[:col.vec.size()]> &(col.vec[0]))
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result

cdef create_string(Column[string]* col):
    cdef data = np.asarray(col.vec)
    cdef result = np.asarray(data.copy())
    col.dispose()
    return result
