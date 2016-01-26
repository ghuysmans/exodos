import pygraphviz as pgv
import networkx as nx
import matplotlib.pyplot as plt
dot = pgv.AGraph("x.dot")
G = nx.Graph(dot) #nx.read_dot("x.dot"))
print nx.shortest_path(G, source='a', target='d', weight='dist')
nx.draw(G)
plt.show()
