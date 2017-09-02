# distutils: language = c++
# distutils: sources = column.hpp

# Cython interface file for wrapping the object
#
#
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.map cimport map
import numpy as np
cimport numpy as np

# c++ interface to cython
cdef extern from "drill/column.hpp": 
    cdef cppclass ColumnBase:
        ColumnBase(string name, int type)
        int getType()
        string getName()

cdef extern from "drill/column.hpp": 
    cdef cppclass Column[T]:
        Column(string name, int type) 
        int getType()
        string getName()
        vector[T] vec
        void dispose()

cdef extern from "drill/column.hpp":
    cdef cppclass ByteStringColumn:
        ByteStringColumn(string name, int type)
        int getType()
        string getName()
        vector[char] vec
        vector[size_t] offsets
        vector[size_t] lengths
        void dispose()

cdef extern from "drill/protobuf/Types.pb.h":
    cdef cppclass MinorType:
        pass

cdef extern from "drill/protobuf/Types.pb.h" namespace "common":
    cdef MinorType TINYINT
    cdef MinorType SMALLINT
    cdef MinorType INT
    cdef MinorType BIGINT 
    cdef MinorType TIMESTAMPTZ 
    cdef MinorType TIMESTAMP 
    cdef MinorType FLOAT4
    cdef MinorType FLOAT8 
    cdef MinorType BIT 
    cdef MinorType VARCHAR 
