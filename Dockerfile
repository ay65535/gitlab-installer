FROM ubuntu:16.04
ADD . /vagrant
WORKDIR /home/vagrant
#RUN pip install -r requirements.txt
#CMD ["python", "app.py"]
CMD ["bash"]
