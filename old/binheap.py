from heapq import * #let's be lazy

class PriorityQueue(object):
	"""
	Simple yet usable priority queue based on a binary heap.
	Threading is absolutely not supported.
	"""

	def __init__(self):
		"""
		>>> h=PriorityQueue()
		"""
		self.h = []

	def pop(self):
		"""
		>>> h=PriorityQueue()
		>>> h.push(1, 2)
		>>> h.push(2, 3)
		>>> h.push(0, "hello")
		>>> h.pop()
		'hello'
		>>> h.pop()
		2
		>>> h.pop()
		3
		>>> h.pop()
		Traceback (most recent call last):
		...
		IndexError: index out of range
		"""
		return heappop(self.h)[1]

	def push(self, priority, x):
		"""
		>>> h=PriorityQueue()
		>>> h.push(1, 2)
		>>> h.pop()
		2
		"""
		return heappush(self.h, (priority, x))

	def decrease(self, priority, x):
		"""
		>>> h=PriorityQueue()
		>>> h.push(19, 2)
		>>> h.push(2, 3)
		>>> h.decrease(1, 2)
		>>> h.pop()
		2
		>>> h.pop()
		3
		"""
		for i, e in enumerate(self.h):
			if e[1]==x:
				assert(e[0] >= priority)
				self.h[i] = (priority, e[1])
				while i>0:
					p = (i+1)/2-1 #parent
					if self.h[p][0] > priority:
						#percolate up
						self.h[i], self.h[p] = self.h[p], self.h[i]
						i = p
					else:
						break
				return
	def __len__(self):
		"""
		>>> h=PriorityQueue()
		>>> h.push(19, 2)
		>>> h.push(2, 3)
		>>> len(h)
		2
		"""
		return len(self.h)

if __name__ == "__main__":
	import doctest
	doctest.testmod()
