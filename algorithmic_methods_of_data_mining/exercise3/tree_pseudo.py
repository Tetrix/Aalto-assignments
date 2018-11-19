 # We use a bottom-up approach and do tree traversal from the bottom

# n - length of the tre
# complete_array - array of clusters
# node_array - contains number of elements, variance and indices of all the elements that it contains

recursion to get to the bottom of the tree
then
if element has children:
	element_left_index = indexOf(element.left)
	element_right_index = indexOf(element.right)
	# get the arrays of those elements 
	element_left = complete_array[element_left_index]
	element_right = complete_array[element_right_index]
	left_right = element_left + element_right
	# self element has 1 element, variange for left and right children and the index of the node itself
	complete_array.append([left_right, self_element])


else:
	# if its 1 element, then it has 0 variance
	complete_array.append([1, 0, [node_index]])

at the end
find elements with same amount of clusters
remove the element that has higher variance
return complete_array
