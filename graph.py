from heapq import *

class TransportationGraph(object):
	def make_arrivals(self, dest, origins, time):
		"""
		time is in minutes from midnight.
		Returns a list of (origin, departure, arrival) tuples.
		"""
		def first_letter(s):
			return ord(s[0].upper()) - ord('A')
		def distance(a, b):
			"""
			Mock for the distance between two cities (mock-ception!).
			"""
			return abs(ord(a[0]) - ord(b[0]))
		def to_city(dest, origins, time):
			"""
			Returns hh:mm times between midnight and time (in minutes).
			Here, mm only depends on dest.
			"""
			minutes = 2*first_letter(dest)
			ret = []
			for hour in range(0, time/60+1):
				t = hour*60 + minutes + 7
				if t <= time:
					ret.append(t)
			ret.reverse()
			return ret
		#main body
		ret = []
		for origin in origins:
			dur = 5 * distance(dest, origin)
			for x in to_city(dest, origin, time):
				if x-dur >= 0:
					ret.append((origin, x-dur, x))
		return ret
	def arrivals(self, dest, time):
		#TODO only keep one edge for each origin
		"""
		Obviously a mock for DB access.
		time is in minutes from midnight.
		Returns a list of (origin, departure, arrival) tuples.
		"""
		if dest=="A":
			return self.make_arrivals(dest, ["B", "L"], time)
		elif dest=="B":
			return self.make_arrivals(dest, ["A", "C", "W"], time)
		elif dest=="C":
			return self.make_arrivals(dest, ["A"], time)
		elif dest=="L":
			return self.make_arrivals(dest, ["A"], time)
		elif dest=="W":
			return self.make_arrivals(dest, ["B", "C"], time)
	def shortest(self, source, target, time, wait_cost=1, route_cost=1, delta=0):
		"""
		time: arrival time
		delta: connection margin time
		Adapted from networkx/algorithms/shortest_paths/weighted.py
		"""
		succ = {} #best successors
		dist = {} #dictionary of final distances
		seen = {target: 0} #labels which could yet be improved
		fringe = [] #heapq with (distance,label) tuples
		heappush(fringe, (0, time, target))
		while fringe: #not empty
			(d, t, v) = heappop(fringe)
			if v in dist:
				continue #already searched this node
			"""
			print "making", v, "final"
			"""
			dist[v] = t #make it final
			if v == source:
				break #no need to search further
			for u, dt, at in self.arrivals(v, t):
				cost = route_cost*(at-dt) + wait_cost*(t-at)
				vu_dist = dist[v] + cost #distance using v-u
				"""
				print "considering", dt, "->", at, "before", t
				"""
				s = (v, dt, at) #segment we consider using
				if u in dist:
					pass #no need to even try improving it
				elif u not in seen or vu_dist < seen[u]:
					"""
					if u in seen:
						print u, "-", v, ":", vu_dist, "<", seen[u]
					else:
						print u, "-", v, ":", vu_dist, "discovered"
					"""
					seen[u] = vu_dist
					heappush(fringe, (vu_dist, dt-delta, u))
					succ[u] = s
		ret = []
		v = source
		while True:
			ret.append((v, succ[v][1:]))
			v = succ[v][0]
			if v == target:
				break
		return ret


import sys
G=TransportationGraph()
print G.shortest("L", "W", 9*60, 1, 1, int(sys.argv[1]))
