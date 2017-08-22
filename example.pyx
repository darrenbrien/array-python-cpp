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
    cdef size_t length = 1500000
    cdef data = np.empty(length, dtype='O')
    cdef:
        unicode a
        arr, template = array.array('B')
        int i, j
    arr = array.clone(template, 10, False)
    for i in range(100, 105):        
        arr[i-100] = i

    for j in range(length):
        data[j] = arr.tobytes().decode('utf-8')
    return data


# https://stackoverflow.com/questions/23064141/optimizing-strings-in-cython
# http://cython.readthedocs.io/en/latest/src/tutorial/array.html
# https://docs.python.org/3/library/array.html#array.array.frombytes
