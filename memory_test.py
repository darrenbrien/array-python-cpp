# Python running example
from tabulate import tabulate
import sys
import numpy as np
from query import PyQuery
import pandas as pd
import numpy as np
import os
import gc
import psutil

def run(connString, mem0, proc):
	def doRun():
		mem1 = proc.memory_info().rss
		R1 = PyQuery()
		df = R1.get_cols(connString)
		print(df.memory_usage().sum() / 1024**2)
		gc.collect()
		mem2 = proc.memory_info().rss
		pd = lambda x2, x1: 100.0 * (x2 - x1) / mem0
		print('allocation for this run {}, total {}'.format(pd(mem2, mem1), pd(mem2, mem0)))
		return 0		
	return doRun

results = sys.argv[1] if len(sys.argv) > 1 else 10
connString = {'query' : 'select * from dfs.flights.flights_by_yr limit {}'.format(results), 
	      'type': 'sql', 
	      'connectStr' : 'local=172.17.0.2:31010',
	      'api' : 'async',
	      'logLevel' : 'error'}
proc = psutil.Process(os.getpid())
gc.collect()
mem0 = proc.memory_info().rss
r = run(connString, mem0, proc)
for i in range(10):
	r()
gc.collect(2)
df = pd.DataFrame(proc.memory_maps())
df.set_index('path', inplace=True)
df.sort_values('rss', inplace=True)
df = df.apply(lambda c: c/1024**2)
print(tabulate(df, headers='keys', tablefmt='psql'))
