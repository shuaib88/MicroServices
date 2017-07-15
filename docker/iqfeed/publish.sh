docker build -t ncllc_iqfeed .
docker tag ncllc_iqfeed controller.local:5000/ncllc_iqfeed
docker push controller.local:5000/ncllc_iqfeed

