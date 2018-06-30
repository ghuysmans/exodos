Foncteur pour combiner différents moteurs avec un point partagé.
Mettre en cache les résultats intermédiaires ??
utiliser du mapping intérieur pour les temps de correspondance ?
	ou fixer par point intermédiaire (selon la taille de la gare...)

s'il y a un retard sur le trajet (demander par paquets et reconnaître),
demander en t+1 et voir s'il n'y a pas mieux


path: je veux arriver le plus tôt possible après t
Quand il n'y en a qu'un, c'est équivalent au trajet le plus court :
	en arrivant plus tôt, ça dure moins longtemps (on n'attend pas)
1) A.path est le premier possible
t   <------A------->
2) B.path en t=A.end est le premier possible après A
!! en fait je prends le plus tôt parmi les plus courts, donc pas tout à fait ça
t   <------A------->      <---B--->
3) A.path_retro en t=B.end évite d'attendre entre les deux
!! doit supposer que fixes ? parce que je le recalcule, quand même...
t         <-------A'-----><---B--->
Optimisation : minimiser B.end-A'.start

path_retro: je veux arriver le plus tard possible avant t
1) B.path_retro est le dernier possible avant t
                      <---B--->  t
2) A.path_retro en t=B.start est le dernier possible avant B
    <-----A----->     <---B--->  t
Optimisation : minimiser t-B.end
!! tester conseil de Raph : maximiser A.start

path_retro_min_wait: presque pareil que path_retro
3) B.path en t=A.end est le premier possible après A
    <-----A-----><---B'-->       t
Optimisation : minimiser B'.end-A.start
