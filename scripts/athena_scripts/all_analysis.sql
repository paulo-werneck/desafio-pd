create database datalake_refined
location 's3://passei-direto-datalake-refined-zone';


create external table datalake_refined.subscriptions_per_type_month
(
    PaymentMonthYear string,
    PlanType string,
    QtdSubscriptionPerType bigint
)
stored as parquet
location 's3://passei-direto-datalake-refined-zone/analysis_subscripts/subscriptions_per_type_month/';


create external table datalake_refined.students_without_subscription
(
    Id string,
    RegisteredDate string,
    UniversityId int,
    CourseId int,
    SignupSource string
)
stored as parquet
location 's3://passei-direto-datalake-refined-zone/analysis_subscripts/students_without_subscription/';
