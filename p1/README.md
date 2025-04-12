# **Instrukcja uruchomienia MapReduce i Hive**

## **1. Przygotowanie środowiska**
### **1.1. Tworzymy nowy klaster
```bash
gcloud dataproc clusters create ${CLUSTER_NAME} --enable-component-gateway \
--region ${REGION} --subnet default --public-ip-address \
--master-machine-type n2-standard-4 --master-boot-disk-size 50 \
--num-workers 2 --worker-machine-type n2-standard-2 --worker-boot-disk-size 50 \
--image-version 2.2-debian12 --optional-components=ZEPPELIN \
--project ${PROJECT_ID} --max-age=3h
```

### **1.2. Wchodzimy do ssh mastera

### **1.3. Pobranie zbiorów danych, rozpakowanie ich i przeniesienie do folderu, z którego będziemy używać danych**
```bash
wget http://www.cs.put.poznan.pl/kjankiewicz/bigdata/projekty/zestaw4.zip

mkdir /tmp/source
unzip zestaw4.zip -d /tmp/source

hadoop fs -mkdir -p /tmp/source/input/datasource1
hadoop fs -mkdir -p /tmp/source/input/datasource4
hadoop fs -copyFromLocal /tmp/source/input/datasource1/* /tmp/source/input/datasource1/
hadoop fs -copyFromLocal /tmp/source/input/datasource4/* /tmp/source/input/datasource4/

hadoop fs -put /tmp/source/input/datasource1/* /tmp/source/input/datasource1/
hadoop fs -put /tmp/source/input/datasource4/* /tmp/source/input/datasource4/
```

### **1.4. Nadanie plikom praw do wykonania**
```bash
chmod +x mapper.py reducer.py combiner.py
```

### **1.5. Sprawdzenie wersji Pythona**
```bash
python --version
```

### **1.6. Usunięcie wyników, jeśli istnieją**
```bash
hadoop fs -rm -r /tmp/source/output/mapreduce_results
hadoop fs -rm -r /tmp/source/output/hive_results.json
```

## **2. Uruchomienie MapReduce w Hadoop Streaming**
```bash
mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input /tmp/source/input/datasource1 \
    -output /tmp/source/output/mapreduce_results \
    -mapper mapper.py \
    -combiner combiner.py \
    -reducer reducer.py
```

## **3. Uruchom skrypt hive**
```bash
hive -hivevar MAPREDUCE_OUTPUT_PATH=/tmp/source/output/mapreduce_results --hivevar DATASOURCE4_PATH=/tmp/source/input/datasource4 --hivevar RESULT_PATH=/tmp/source/output/hive_results.json -f hive_script.hql
```


## **4. Wyświetl rezultat**
```bash
cat /tmp/source/output/hive_results.json/HIVE_UNION_SUBDIR_1/*
cat /tmp/source/output/hive_results.json/HIVE_UNION_SUBDIR_2/*
```