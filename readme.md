```yaml
  storage:
    image: febalist/storage
    restart: always
    environment:
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_REGION=${AWS_REGION}
      - AWS_BUCKET=s3://${AWS_BUCKET}
      - BACKUP_INTERVAL=2h
    volumes:
      - storage:/storage
```

```bash
docker-compose run --rm storage restore_empty
docker-compose up --detach
```
