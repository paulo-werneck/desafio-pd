## Desafio - PD

Este repositório contém a proposta de resolução do desafio de Data Engineer


1. Arquitetura

![arquitetura_proposta](https://public-bkt-geral.s3.amazonaws.com/teste.png)

- Kinesis: Serviço de ingestão dos jsons. Não implementado, apenas ilustrativo.
- Lambda: Recebe os eventos oriundos do Kinesis e os salva no S3. Não implementado, apenas ilustrativo.
- Bucket S3 (Raw Zone): Camada de chegada dos dados entregues pela Lambda.
- Glue spark 1: Captura os dados da Raw Zone para transformá-los em parquet, com compressão snappy e particionado e os salva na Trusted Zone.
- Bucket S3 (Trusted Zone): Camada intermediária, com dados oriundos do glue. Dados pré-processados, em perfomático para as operações.
- Glue spark 2: Captura dados da Trusted Zone para processamento entre e posterior salvamento na Refined Zone.
- Bucket S3 (Trusted Zone): Camada final, regras de negócios aplicadas, tabelas agregadas, dados pronto para consumo.

- Redshift / Athena (Serving Layer): Camada de acesso ao dado disponibilizada ao usuário final. Não implementado, apenas ilustrativo.