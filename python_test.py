# Python running example
import sys
import numpy as np
from query import PyQuery
import pandas as pd
import numpy as np
import timeit
def run(connString):
	def doRun():
		R1 = PyQuery()
		df = R1.get_cols(connString)
		print(df.head())
		print(df.shape)
		del df
		return 0		
	return doRun

results = sys.argv[1] if len(sys.argv) > 1 else 10
connString = {'query' : 'select * from dfs.flights.flights_by_year limit {}'.format(results), 
	      'type': 'sql', 
	      'connectStr' : 'local=172.17.0.2:31010',
	      'api' : 'async',
	      'logLevel' : 'error'}
result = timeit.Timer(run(connString)).repeat(repeat=10, number=1)
print("{} runs took {}, min: {}, median:{}, max:{}".format(len(result), sum(result), min(result), np.median(result), max(result))) 
print(["%.2f"%item for item in result])
