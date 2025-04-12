#!/usr/bin/env python3
import sys
from collections import defaultdict

person_movies = defaultdict(lambda: [0, 0])

for line in sys.stdin:
    line = line.strip()
    nconst, is_actor, is_director = line.split("\t")

    is_actor = int(is_actor)
    is_director = int(is_director)

    person_movies[nconst][0] += is_actor
    person_movies[nconst][1] += is_director

for nconst, (count_as_actor, count_as_director) in person_movies.items():
    print(f"{nconst}\t{count_as_actor}\t{count_as_director}")
