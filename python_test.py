# Python running example

import numpy as np
from query import PyQuery
import pandas as pd
import numpy as np
import timeit

def run():
	R1 = PyQuery()
	connString = 'query="select * from dfs.flights.flights_by_yr limit 10" type=sql connectStr=local=172.17.0.2:31010 api=async logLevel=info'
	df = R1.get_cols(connString)
	print(df.head())
	return df

result = timeit.Timer(run).repeat(repeat=10, number=1)
print("{} runs took {}, min: {}, median:{}, max:{}".format(len(result), sum(result), min(result), np.median(result), max(result))) 
print(["%.2f"%item for item in result])
