import Cython.Compiler.Options
Cython.Compiler.Options.annotate = True

from cpython cimport array
cimport numpy as cnp
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
        array.array[uchar] arr = array.array('B') 
        array.array[uchar] template = array.array('B') 
        int i, j

    for j in range(10000):
        arr = array.clone(template, 127, False)

        for i in range(127):
            arr[i] = i

        a = arr.data.as_chars[:len(arr)].decode('utf-8')
    return a

def cfuncC():
    cdef size_t length = 127000
    cdef int strLength = 5
    cdef data = np.empty(length, dtype='O')
    cdef:
        unicode a
        array.array[uchar] arr, template = array.array('B')
        int i, j
    arr = array.clone(template, strLength, False)
    for i in range(100, 100 + strLength):
        arr[i-100] = i
    for j in range(length):
        data[j] = arr.tobytes().decode('utf-8')
    return data

def cfuncD():
    cdef size_t length = 127000
    cdef int strLength = 5
    cdef data = np.empty(length, dtype='O')
    cdef lengths = np.ones(length, dtype=np.dtype('i4')) * 5
    cdef offsets = np.arange(0, length * strLength, strLength)
    cdef arr, template = array.array('B')
    arr = array.clone(template, strLength * length, False)
    cdef size_t i, j
    for j in range(strLength * length):
        arr[j] = j % strLength + 100
    cdef unicode string = arr.tobytes().decode('utf-8')
    for i in range(length):
        data[i] = string[offsets[i]:offsets[i] + lengths[i]]
    return data                                                                                             
