#!/usr/bin/env python3
import sys

current_nconst = None
total_movies_as_actor = 0
total_movies_as_director = 0

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    try:
        nconst, movies_as_actor, movies_as_director = line.split("\t")
    except ValueError:
        continue

    if current_nconst == nconst:
        total_movies_as_actor += int(movies_as_actor)
        total_movies_as_director += int(movies_as_director)
    else:

        if current_nconst:
            print(f"{current_nconst}\t{total_movies_as_actor}\t{total_movies_as_director}")

        current_nconst = nconst
        total_movies_as_actor = int(movies_as_actor)
        total_movies_as_director = int(movies_as_director)

if current_nconst:
    print(f"{current_nconst}\t{total_movies_as_actor}\t{total_movies_as_director}")
