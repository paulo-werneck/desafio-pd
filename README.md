## Desafio - PD

Este repositório contém a proposta de resolução do desafio de Data Engineer <br>
Toda a infraestrutura do projeto foi criada em cima de ambiente Cloud AWS

<h3> 1. Arquitetura </h3>

![arquitetura_proposta](https://public-bkt-geral.s3.amazonaws.com/teste.png)

- Kinesis: Serviço de ingestão dos jsons. Não implementado, apenas ilustrativo.
- Lambda: Recebe os eventos oriundos do Kinesis e os salva no S3. Não implementado, apenas ilustrativo.
- Bucket S3 (Raw Zone): Camada de chegada dos dados entregues pela Lambda.
- Glue spark 1: Captura os dados da Raw Zone para transformá-los em parquet, com compressão snappy e particionado e os salva na Trusted Zone.
- Bucket S3 (Trusted Zone): Camada intermediária, com dados oriundos do glue. Dados pré-processados, em perfomático para as operações.
- Glue spark 2: Captura dados da Trusted Zone para processamento entre e posterior salvamento na Refined Zone.
- Bucket S3 (Trusted Zone): Camada final, regras de negócios aplicadas, tabelas agregadas, dados pronto para consumo.

- Redshift / Athena (Serving Layer): Camada de acesso ao dado disponibilizada ao usuário final. Não implementado, apenas ilustrativo.


<h3> 2. Pré-requisitos </h3>

Para posterior setup do projeto os seguintes softwares são necessários:

- Terraform
- AWS cli


<h3> 3. Setup </h3>

Na criação do ambiente foi utilizado a ferramenta "terraform", com isso, para "subir" a infraestutura favor seguir os passos abaixo, em sua ordem:

    1 - git clone git@github.com:paulo-werneck/desafio-pd.git
    2 - cd desafio-pd/devops/terraform/
    3 - terraform init
    4 - terraform plan -target=aws_s3_bucket.raw -var "profile_aws_cli=<Coloque aqui o nome do perfil referente ao AWS cli aonde a infra sera configurada>"
    5 - terraform apply -target=aws_s3_bucket.raw -var "profile_aws_cli=<Coloque aqui o nome do perfil referente ao AWS cli aonde a infra sera configurada>" -auto-approve

Até nesse momento apenas o "bucket raw" terá sido criado, para que o restante do processo funcione é necessário "subir"
os datasets para esse bucket, nos seguintes endereços:

 BASE A: s3://passei-direto-datalake-raw-zone/ <br> 
 BASE B: s3://passei-direto-datalake-raw-zone/navigation/ 

Continuando no setup:

    6 - terraform plan -var "profile_aws_cli=<Coloque aqui o nome do perfil referente ao AWS cli aonde a infra sera configurada>"
    7 - terraform apply -var "profile_aws_cli=<Coloque aqui o nome do perfil referente ao AWS cli aonde a infra sera configurada>" -auto-approve
    8 - executar o script contido em desafio-pd/scripts/athena_scripts/all_analysis.sql no athena (apenas para fins de checagem dos dados gerados pelas análises)


<h3> 4. Descrição dos serviços e finalidades </h3>

O Terraform criará os seguintes serviços na AWS:

- 3 IAM Policies
  - Permissionamento do glue aos serviços

- 1 IAM Role
  - Permissionamento do glue aos serviços

- 4 Buckets S3
  - passei-direto-datalake-raw-zone: Zona Raw Data Lake
  - passei-direto-datalake-trusted-zone: Zona Trusted Data Lake
  - passei-direto-datalake-refined-zone: Zona Refined Data Lake
  - passei-direto-datalake-artifacts-zone: Localização dos scripts do glue e outros possíveis artefatos
  
- 2 Jobs Glue
  - raw_to_trusted: job spark para transformar os jsons em parquet e carregar na Trusted Zone  
  - analysis_subscriptions: job em spark com as análises de negócio 

- 9 Triggers Glue
    - Gatilho para executar os jobs, passando a localização dos arquivos como parâmetro