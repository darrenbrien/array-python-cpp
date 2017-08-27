# cython: boundscheck=False, cdivision=True, wraparound=False, profile=True

# distutils: language = c++
# distutils: sources = querySubmitter.cpp
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair
import numpy as np
cimport numpy as np
import pandas as pd
from column cimport ColumnBase
from column cimport Column
from cython cimport view
from cpython cimport array
import array

ctypedef np.uint8_t BIT
ctypedef np.int32_t INT
ctypedef np.int64_t BIGINT
ctypedef np.float64_t DOUBLE

# c++ interface to cython
cdef extern from "drill/querySubmitter.hpp": 
  cdef cppclass Query:
        vector[ColumnBase*] get_cols(vector[pair[string, string]])

# creating a cython wrapper class
cdef class PyQuery:
    cdef Query *thisptr
    def get_cols(self, string query):
        params = [tuple(i.split('=')) for i in query.split(' ')]
        cdef vector[ColumnBase*] result = self.thisptr.get_cols(params)
        return to_array(result)

cdef to_array(vector[ColumnBase*] cols):
    cdef d = []
    cdef string name
    cdef size_t i
    for i in range(cols.size()):
        name = cols[i].getName()
        d.append((name.decode('utf-8'), to_numpy(cols[i])))
    return pd.DataFrame.from_items(d)

cdef to_numpy(ColumnBase* i):
    cdef t = i.getType()
    if t == 101:
        return create_bool(<Column[BIT]*> i)
    elif t == 102:
        return create_int32(<Column[INT]*> i)
    elif t == 103:
        return create_int64(<Column[BIGINT]*> i) 
    elif t == 104:
        return create_float64(<Column[DOUBLE]*> i) 
    elif t == 105:
        return create_datetime64(<Column[BIGINT]*> i) 
    else: #t == 106:
        return create_string(<Column[string]*> i)

cdef create_int32(Column[INT]* col):
    cdef np.ndarray[INT, ndim=1] data = np.array(<INT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i4'))
    col.dispose()
    return data

cdef create_float64(Column[DOUBLE]* col):
    cdef np.ndarray[DOUBLE, ndim=1] data = np.array(<DOUBLE[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('f8'))
    col.dispose()
    return data

cdef create_bool(Column[BIT]* col):
    cdef np.ndarray[BIT, ndim=1] data = np.array(<BIT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('u1'))
    col.dispose()
    return data.view(dtype=np.bool)

cdef create_int64(Column[BIGINT]* col):
    cdef np.ndarray[BIGINT, ndim=1] data = np.array(<BIGINT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i8'))
    col.dispose()
    return data

cdef create_datetime64(Column[BIGINT]* col):
    cdef np.ndarray[BIGINT, ndim=1] data = np.array(<BIGINT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i8'))
    col.dispose()
    return np.asarray(data, dtype='datetime64[ns]' )

cdef create_string(Column[string]* col):
    cdef data = np.empty(col.vec.size(), dtype='O')
    cdef size_t i
    for i in range(col.vec.size()):
        data[i] = col.vec[i].decode('utf-8')
    col.dispose()
    return data 


