FROM python:3.9 as builder

WORKDIR /app

COPY app.py requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.9-slim

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app/app.py .

RUN apt update && \
    apt install curl -y

EXPOSE 8000

CMD ["python", "app.py"]