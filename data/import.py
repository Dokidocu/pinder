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

class QuestionTag(object):
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

db_questions_tags = Table('question_tag', metadata, autoload=True, autoload_with=engine)
mapper(QuestionTag, db_questions_tags)

Session = sessionmaker(bind=engine)
my_session = Session()

print 'test'

import csv
with open('tweets.csv', 'rb') as csvfile:
	reader = csv.reader(csvfile, delimiter=',', quotechar='"')

	for row in reader:
		print row[0]
		print row[1]
		print row[2]
		print row[3]

		my_question = Question()
	
		my_question.id = int(row[0])
		my_question.title = '' 
		my_question.link = '' 
		my_question.text = row[3]
		my_question.source = 'twitter'
		my_question.author = row[1]
		my_question.created_at = row[2]
		my_question.updated_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	
		try:
			my_session.add(my_question)
			my_session.commit()
		except:
			print 'error'

with open('tags.csv', 'rb') as csvfile:
	reader = csv.reader(csvfile, delimiter=',', quotechar='"')

	for row in reader:
		my_tag = Tag()

		name = row[0]

		my_tag = my_session.query(Tag).filter(
		    Tag.name.like(name)).first()

		if not my_tag:
			my_tag = Tag()
			my_tag.name = name
			my_tag.created_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
			my_tag.updated_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
			my_session.add(my_tag)
			my_session.commit()

		my_question_tag = QuestionTag()
		my_question_tag.question_id = row[2]
		my_question_tag.tag_id = my_tag.id

		my_session.add(my_question_tag)
		my_session.commit()


