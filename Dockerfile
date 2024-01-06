FROM python:3.8

WORKDIR /usr/src/app

# Copy the project files into the Docker image
COPY . .
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Run the commands from the Makefile manually
RUN python3 -m venv env \
    && env/bin/pip install --upgrade pip \
    && env/bin/pip install --upgrade setuptools wheel \
    && env/bin/pip install -r requirements.txt \
    && echo '#!/bin/sh' > fernet.sh \
    && echo '' >> fernet.sh \
    && echo "$(pwd)/env/bin/python $(pwd)/fernet.py \"\$$@\"" >> fernet.sh \
    && chmod +x fernet.sh \
    && ln -s $(pwd)/fernet.sh /usr/local/bin/fernet

# Set the entry point to the fernet.sh script
ENTRYPOINT ["python", "/usr/src/app/fernet.py"]
CMD ["--help"]  # You can change this to the default command you want to run
