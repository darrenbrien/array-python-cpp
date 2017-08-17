# Python running example

from __future__ import print_function
import time
import numpy as np
from query import PyQuery
import pandas as pd

R1 = PyQuery()

for i in range(10):
	d = R1.get_cols("gimme the data".encode('utf-8'))
	df = pd.DataFrame.from_items(d)
	#print(df)
	#print(df.dtypes.value_counts())
	#print(df.memory_usage().sum() / 1024.0 **2)
	del d

