chmod +x mapper.py reducer.py combiner.py

mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input /tmp/source/input/datasource1 \
    -output /tmp/source/output/mapreduce_results \
    -mapper mapper.py \
    -combiner combiner.py \
    -reducer reducer.py