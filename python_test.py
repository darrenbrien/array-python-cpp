# Python running example

import numpy as np
from query import PyQuery
import pandas as pd
import numpy as np
import timeit

def run():
	R1 = PyQuery()
	df = R1.get_cols("gimme the data".encode('utf-8'))
	print(df.head(10))
	return df

result = timeit.Timer(run).repeat(repeat=10, number=1)
print("{} runs took {}, min: {}, median:{}, max:{}".format(len(result), sum(result), min(result), np.median(result), max(result))) 
print(["%.2f"%item for item in result])
