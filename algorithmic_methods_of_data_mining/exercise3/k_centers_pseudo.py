when the stream starts:
	read first k elements and assign them as centers
	d = (max distance between the centers) / 2

	read next element
	c = closest center
	conmpute the distance dm to its closest center
	if dm < d:
		assign it to that cluster
	else:
		# now we update the distance d
		d = dm + d
		remove c from the centers list
		assign the new element to be the center