FROM python:3.10

RUN mkdir -p /appfolder

COPY . /appfolder

RUN /bin/bash python3 -m pip install -r /appfolder/requirements.txt

EXPOSE 5000

CMD ["python", "/appfolder/app.py"]