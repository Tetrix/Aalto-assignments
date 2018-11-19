vertex_array = []
edge_array = []
connectivity = []

while edges are coming:
	# check is there is still space in the window
	if len(edge_array) == W:
		remove oldest edge from edge_array
	# add next edge to the edge_array
	edge_array.append(edge)
	# if node does not exist in the vertex_array, add it
	if node not in vertex_array:
		vertex_array.append(node)
	# add the element to the graph G
	G.append(edge)

	# check connectivity
	if len(edge_array) - len(edge_array) == 1:
		connectivity.append(True)
	if len(edge_array) - len(edge_array) > 1:
		connectivity.append(False)
	# cycle detected
	if len(edge_array) - len(edge_array) == 0:
		connectivity.append(True)
		depth_first_search(G):
			find cycle
			remove oldest edge in the cycle
stop when the stream ends