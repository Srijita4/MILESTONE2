FROM python:3.8
WORKDIR /quotes
COPY . .
ENV PYTHONUNBUFFERED=1
RUN pip install -r requirements.txt
COPY . /quotes.py 
CMD [ "python", "quotes.py" ]
EXPOSE 5000
