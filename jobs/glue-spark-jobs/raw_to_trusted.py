import logging
import sys
from pyspark.sql import SparkSession
from awsglue.utils import getResolvedOptions


args = getResolvedOptions(sys.argv, ['FILE_PATH', 'FILE_NAME'])
file_name = args['FILE_NAME']
file_path = args['FILE_PATH']


log_format = '%(asctime)s - %(levelname)s - %(filename)s[%(lineno)s] %(message)s'
logging.basicConfig(format=log_format, level=logging.INFO)

spark = SparkSession.builder.\
    appName('raw_to_trusted').\
    getOrCreate()


def trim_header(data_frame):
    for col in data_frame.columns:
        if " " in col:
            data_frame = data_frame.withColumnRenamed(col, col.replace(" ", "_"))
    return data_frame


logging.info(f"Reading dataset {file_path} in raw zone")
df = spark.read.json(file_path)

df1 = trim_header(df)
output_path = "s3://passei-direto-datalake-trusted-zone/{file}/".format(file=file_name.split('.')[0])

logging.info(f"Saving dataset {output_path} in trusted zone")
df1.write.parquet(path=output_path,
                  mode="overwrite",
                  compression="snappy")

logging.info(f"Finished process.")
