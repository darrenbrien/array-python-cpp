# Python running example

from __future__ import print_function
import time
import numpy as np
from rect import PyRectangle
import pandas as pd

R1 = PyRectangle()

for i in range(10):
	d = R1.get_cols()
	df = pd.DataFrame.from_dict(d)
	print(df)
	del df
	del d

