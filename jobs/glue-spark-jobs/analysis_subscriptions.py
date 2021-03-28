import logging
import sys
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, ['FILE_PATH_STUDENTS', 'FILE_PATH_SUBSCRIPTIONS'])
file_path_students = args['FILE_PATH_STUDENTS']
file_path_subscriptions = args['FILE_PATH_SUBSCRIPTIONS']


log_format = '%(asctime)s - %(levelname)s - %(filename)s[%(lineno)s] %(message)s'
logging.basicConfig(format=log_format, level=logging.INFO)

spark = SparkSession.builder.\
    appName('analysis_subscriptions').\
    getOrCreate()


def read_parquet(parquet_path: str):
    """
    :param parquet_path: parquet file or directory path
    :return: spark dataframe
    """

    parquet = spark.read.parquet(parquet_path)
    logging.info(f"Read dataset students - {parquet.count()} lines processed")
    return parquet


def subscriptions_per_type_month(df_subscriptions: spark.createDataFrame):
    """
    :param df_subscriptions: subscriptions data frame
    :return: data frame with amount of payers by type
    """

    logging.info("Generating table subscriptions_per_type_month")
    return df_subscriptions.select(
        "StudentId",
        "PlanType",
        df_subscriptions.PaymentDate.cast("timestamp").alias("PaymentDate")
    ).groupBy(
        F.concat(F.month("PaymentDate"), F.lit("-"), F.year("PaymentDate")).alias("PaymentMonthYear"),
        "PlanType",
    ).agg(
        F.count("StudentId").alias("QtdSubscriptionPerType")
    )


def students_without_subscription(df_subscriptions: spark.createDataFrame, df_students: spark.createDataFrame):
    """
    :param df_subscriptions: subscriptions data frame
    :param df_students: students data frame
    :return: data frame with non-paying users
    """

    logging.info("Generating table students_without_subscription")
    return df_students.join(
        other=df_subscriptions,
        on=df_students.Id == df_subscriptions.StudentId,
        how="left_anti"
    )


def write_s3(data_frame, s3_bucket="passei-direto-datalake-refined-zone", s3_path=None):
    """
    :param data_frame: input data frame to salve in AWS S3
    :param s3_bucket: AWS S3 bucket name
    :param s3_path: AWS S3 bucket path
    """

    logging.info("Writing table in data lake")
    data_frame.write.parquet(path=f"s3://{s3_bucket}/{s3_path}/",
                             mode="overwrite",
                             compression="snappy")
    logging.info(f"saved in s3://{s3_bucket}/{s3_path}")


if __name__ == '__main__':
    students = read_parquet(file_path_students)
    subscriptions = read_parquet(file_path_subscriptions)

    d1 = subscriptions_per_type_month(df_subscriptions=subscriptions)
    write_s3(data_frame=d1, s3_path='analysis_subscriptions/subscriptions_per_type_month/')

    d2 = students_without_subscription(df_subscriptions=subscriptions, df_students=students)
    write_s3(data_frame=d2, s3_path='analysis_subscriptions/students_without_subscription')
