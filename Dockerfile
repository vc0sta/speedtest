FROM python:3-slim

# Install basics
RUN apt-get update && apt-get install -y curl

# Install speedtest cli
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash &&\
    apt-get install speedtest

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./speedtest.py .
CMD ["python", "./speedtest.py"]
