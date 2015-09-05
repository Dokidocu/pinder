#!/usr/bin/env python
# -*- coding: latin-1 -*-
from sqlalchemy import *
from sqlalchemy.orm import relationship, backref
from sqlalchemy.orm import mapper, sessionmaker, clear_mappers
from sqlalchemy.ext.declarative import declarative_base
import sys
import xml.etree.ElementTree as ET
import datetime
import json
from pprint import pprint as pp
import requests
import time
import os
import csv
import codecs
from openpyxl import Workbook, load_workbook
import importlib
import hashlib
import datetime

class Question(object):
    pass


class Tag(object):
    pass

engine = create_engine('mysql://root:root@localhost/pinder')
metadata = MetaData()
clear_mappers()
db_tags = Table('tags', metadata, autoload=True, autoload_with=engine)
mapper(Tag, db_tags)

db_questions = Table('questions', metadata, autoload=True, autoload_with=engine)
mapper(Question, db_questions)

Session = sessionmaker(bind=engine)
my_session = Session()

print 'test'

import csv
with open('tweets.csv', 'rb') as csvfile:
	reader = csv.reader(csvfile, delimiter=',', quotechar='"')

	last_id = 0
	current_id = 0
	change = 1

	for row in reader:
		print row[0]
		print row[1]
		print row[2]
		print row[3]

		my_question = Question()

		current_id = int(row[0])
		new_id = current_id

		if current_id < last_id:
			new_id = current_id + (change * 100)
			change = change + 1
		elif change > 1:
			new_id = current_id + (change * 100)

		last_id = current_id
	
		my_question.id = new_id
		my_question.title = '' 
		my_question.link = '' 
		my_question.text = row[3]
		my_question.source = 'twitter'
		my_question.author = row[1]
		my_question.created_at = row[2]
		my_question.updated_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	
		my_session.add(my_question)
		my_session.commit()

