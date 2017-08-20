# cython: boundscheck=False, cdivision=True, wraparound=False
# distutils: language = c++
# distutils: sources = Query.cpp
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
cdef extern from "Query.h": 
  cdef cppclass Query:
        vector[ColumnBase*] get_cols(string)

# creating a cython wrapper class
cdef class PyQuery:
    cdef Query *thisptr
    def get_cols(self, string query):
        cdef vector[ColumnBase*] result = self.thisptr.get_cols(query)
        return to_array(result)

cdef to_array(vector[ColumnBase*] cols):
    cdef d = []
    cdef string name
    cdef size_t i
    for i in range(cols.size()):
        name = cols[i].getName().decode('utf-8')
        d.append((name, to_numpy(cols[i])))
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
    cdef vector[INT] new
    new.swap(col.vec)
    cdef np.ndarray[INT, ndim=1] data = np.array(<INT[:new.size()]> &(new[0]), dtype=np.dtype('i4'))
    col.dispose()
    return data

cdef create_float64(Column[DOUBLE]* col):
    cdef vector[DOUBLE] new
    new.swap(col.vec)
    cdef np.ndarray[DOUBLE, ndim=1] data = np.array(<DOUBLE[:new.size()]> &(new[0]), dtype=np.dtype('f8'))
    col.dispose()
    return data

cdef create_bool(Column[BIT]* col):
    cdef vector[BIT] new
    new.swap(col.vec)
    cdef np.ndarray[BIT, ndim=1] data = np.asarray(<BIT[:new.size()]> &(new[0]), dtype=np.dtype('u1'))
    bools = np.ones_like(data, dtype=np.uint8) 
    col.dispose()
    return bools.view(dtype=np.bool)

cdef create_int64(Column[BIGINT]* col):
    cdef vector[BIGINT] new
    new.swap(col.vec)
    cdef np.ndarray[BIGINT, ndim=1] data = np.array(<BIGINT[:new.size()]> &(new[0]), dtype=np.dtype('i8'))
    col.dispose()
    return data

cdef create_datetime64(Column[BIGINT]* col):
    cdef vector[BIGINT] new
    new.swap(col.vec)
    cdef np.ndarray[BIGINT, ndim=1] data = np.array(<BIGINT[:new.size()]> &(new[0]), dtype=np.dtype('i8'))
    col.dispose()
    return np.asarray(data, dtype='datetime64[ns]' )

cdef create_string(Column[string]* col):
    cdef data = np.empty(col.vec.size(), dtype='O')
    cdef size_t i
    for i in range(col.vec.size()):
        data[i] = col.vec[i]
    col.dispose()
    return data
