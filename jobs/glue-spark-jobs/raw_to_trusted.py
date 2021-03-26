import sys
from pyspark.sql import SparkSession
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, ['FILE_PATH', 'FILE_NAME'])
file_name = args['FILE_NAME']
file_path = args['FILE_PATH']

spark = SparkSession.builder.\
    appName('raw_to_trusted').\
    getOrCreate()

df = spark.read.json(file_path)

df.write.parquet(path="s3://passei-direto-datalake-trusted-zone/{file}/".format(file=file_name.split('.')[0]),
                 mode="overwrite",
                 compression="snappy")
