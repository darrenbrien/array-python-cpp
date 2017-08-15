# distutils: language = c++
# distutils: sources = Rectangle.cpp

# Cython interface file for wrapping the object
#
#
from libcpp.string cimport string
from libcpp.vector cimport vector
import numpy as np
cimport numpy as np
from column cimport ColumnBase
from column cimport Column
from cython cimport view

# c++ interface to cython
cdef extern from "Rectangle.h" namespace "shapes":
  cdef cppclass Rectangle:
        Rectangle(int, int, int, int) except +
        int x0, y0, x1, y1
        int getLength()
        int getHeight()
        int getArea()
        void move(int, int)
        double sum_vec(vector[double])
        double sum_mat(vector[vector[double]])
        double sum_mat_ref(vector[vector[double]] &)
        vector[vector[double]] ret_mat(vector[vector[double]])
        vector[ColumnBase*] ret_map()

# creating a cython wrapper class
cdef class PyRectangle:
    cdef Rectangle *thisptr      # hold a C++ instance which we're wrapping
    def __cinit__(self, int x0, int y0, int x1, int y1):
        self.thisptr = new Rectangle(x0, y0, x1, y1)
    def __dealloc__(self):
        del self.thisptr
    def getLength(self):
        return self.thisptr.getLength()
    def getHeight(self):
        return self.thisptr.getHeight()
    def getArea(self):
        return self.thisptr.getArea()
    def move(self, dx, dy):
        self.thisptr.move(dx, dy)
    def sum_vec(self, sv):
        return self.thisptr.sum_vec(sv)
    def sum_mat(self, sv):
        return self.thisptr.sum_mat(sv)
    def sum_mat_ref(self, sv):
        return self.thisptr.sum_mat_ref(sv)
    def ret_mat(self, sv):
        return self.thisptr.ret_mat(sv)
    def ret_map_uint(self):
        result = self.thisptr.ret_map()
        d = {}
        for column in result:
            d[column.getName().decode('utf8')] = to_numpy(column)
        return(d)

cdef to_numpy(ColumnBase* i):
    if i.getType() == 101:
        return np.asarray(<np.float64_t[:(<Column[np.float64_t]*> i).vec.size()]> &(<Column[np.float64_t]*> i).vec[0])
    if i.getType() == 202:
        return create_ints(<Column[np.int32_t]*> i)

cdef create_ints(Column[np.int32_t]* col):
    cdef view.array ints = <np.int32_t[:col.vec.size()]> &col.vec[0]
    #ints.callback_free_data = lambda 
    return np.asarray(ints)









