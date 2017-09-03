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
from column cimport ByteStringColumn
from column cimport MinorType
from column cimport TINYINT, SMALLINT, INT, BIGINT, TIMESTAMP, FLOAT4, FLOAT8, BIT, VARCHAR
from cython cimport view
from cpython cimport array
import array

ctypedef np.uint8_t cBIT
ctypedef np.int32_t cINT
ctypedef np.int64_t cBIGINT
ctypedef np.float64_t cDouble
ctypedef np.float32_t cFloat

# c++ interface to cython
cdef extern from "drill/querySubmitter.hpp": 
  cdef cppclass Query:
        vector[ColumnBase*] get_cols(vector[pair[string, string]])

# creating a cython wrapper class
cdef class PyQuery:
    cdef Query *thisptr
    def get_cols(self, query):
        params = [map(lambda s: s.encode('utf-8'), (k, v)) for k, v in query.items()]
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
    if t == <int> BIT:
        return create_bool(<Column[cBIT]*> i)
    elif t == <int> INT:
        return create_int32(<Column[cINT]*> i)
    elif t == <int> BIGINT:
        return create_int64(<Column[cBIGINT]*> i) 
    elif t == <int> FLOAT4:
        return create_float32(<Column[cFloat]*> i) 
    elif t == <int> FLOAT8:
        return create_float64(<Column[cDouble]*> i) 
    elif t == <int> TIMESTAMP:
        return create_datetime64(<Column[cBIGINT]*> i) 
    else: #t == <int> VARCHAR:
        return create_string(<ByteStringColumn*> i)

cdef create_int32(Column[cINT]* col):
    cdef np.ndarray[cINT, ndim=1] data = np.array(<cINT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i4'))
    col.dispose()
    return data

cdef create_float32(Column[cFloat]* col):
    cdef np.ndarray[cFloat, ndim=1] data = np.array(<cFloat[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('f4'))
    col.dispose()
    return data

cdef create_float64(Column[cDouble]* col):
    cdef np.ndarray[cDouble, ndim=1] data = np.array(<cDouble[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('f8'))
    col.dispose()
    return data

cdef create_bool(Column[cBIT]* col):
    cdef np.ndarray[cBIT, ndim=1] data = np.array(<cBIT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('u1'))
    col.dispose()
    return data.view(dtype=np.bool)

cdef create_int64(Column[cBIGINT]* col):
    cdef np.ndarray[cBIGINT, ndim=1] data = np.array(<cBIGINT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i8'))
    col.dispose()
    return data

cdef create_datetime64(Column[cBIGINT]* col):
    cdef np.ndarray[cBIGINT, ndim=1] data = np.array(<cBIGINT[:col.vec.size()]> &(col.vec[0]), dtype=np.dtype('i8'))
    col.dispose()
    return np.asarray(data, dtype='datetime64[ms]' )

cdef create_string(ByteStringColumn* col):
    cdef np.ndarray[size_t] lengths = np.asarray(<size_t[:col.lengths.size()]> &(col.lengths[0]))
    cdef np.ndarray[size_t] offsets = np.asarray(<size_t[:col.offsets.size()]> &(col.offsets[0]))
    cdef data = np.empty(col.lengths.size(), dtype='O')
    cdef size_t i
    for i in range(col.lengths.size()):
        data[i] = get_c_string(&(col.vec[0]) + offsets[i], lengths[i])
    col.dispose()
    return data

cdef unicode get_c_string(unsigned char* c_string, size_t length):
    return c_string[:length].decode('ascii', 'ignore')
