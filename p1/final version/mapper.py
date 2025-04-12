#!/usr/bin/env python3
import sys

for line in sys.stdin:
    fields = line.strip().split("\t")

    if len(fields) < 6:
        continue

    tconst, ordering, nconst, role, job, characters = fields

    movies_as_actor = 0
    movies_as_director = 0

    if role in ["actor", "actress", "self"]:
        movies_as_actor = 1
    if role == "director":
        movies_as_director = 1

    print(f"{nconst}\t{movies_as_actor}\t{movies_as_director}")
