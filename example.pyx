%%cython

from cpython cimport array
cimport numpy as np
import numpy as np

def cfuncA():
    cdef str a
    cdef int i,j
    for j in range(1000):
        a = ''.join([chr(i) for i in range(127)])
    return a

def cfuncB():
    cdef:
        unicode a
        arr, template = array.array('B')
        int i, j

    for j in range(1000):
        arr = array.clone(template, 127, False)

        for i in range(127):
            arr[i] = i

        a = arr.tobytes().decode('utf-8')
    return a

def cfuncC():
    cdef size_t length = 1000
    cdef int strLength = 5
    cdef data = np.empty(length, dtype='O')
    cdef:
        unicode a
        arr, template = array.array('B')
        int i, j
    arr = array.clone(template, strLength, False)
    for i in range(100, 100 + strLength):        
        arr[i-100] = i
    for j in range(length):
        data[j] = arr[1:3].tobytes().decode('utf-8')
    return data

def cfuncD():
    cdef size_t length = 1000
    cdef int strLength = 5
    cdef data = np.empty(length, dtype='O')
    cdef lengths = np.ones(length, dtype=np.dtype('i4')) * 5
    cdef offsets = np.arange(0, 5000, 5)
    cdef arr, template = array.array('B')
    arr = array.clone(template, 5 * length, False)
    cdef size_t i, j
    for j in range(strLength * length):
        arr[j] = j % strLength + 100
    cdef unicode string = arr.tobytes().decode('utf-8')
    for i in range(length):
        data[i] = string[offsets[i]:offsets[i] + lengths[i]]    
    return data

# https://stackoverflow.com/questions/23064141/optimizing-strings-in-cython
# http://cython.readthedocs.io/en/latest/src/tutorial/array.html
# https://docs.python.org/3/library/array.html#array.array.frombytes
