FROM ubuntu:16.04
ADD . /vagrant
WORKDIR /vagrant
RUN /vagrant/localize.sh
#CMD ["python", "app.py"]
CMD ["bash"]
