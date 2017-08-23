# Python running example

import numpy as np
from query import PyQuery
import pandas as pd
import numpy as np
import timeit

def run():
	R1 = PyQuery()
	return R1.get_cols("gimme the data".encode('utf-8'))

result = timeit.Timer(run).repeat(repeat=10, number=1)
print("{} runs took {}, min: {}, median:{}, max:{}".format(len(result), sum(result), min(result), np.median(result), max(result))) 
print(["%.2f"%item for item in result])
